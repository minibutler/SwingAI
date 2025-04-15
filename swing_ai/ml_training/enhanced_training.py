import tensorflow as tf
import numpy as np
import pandas as pd
import json
import os
import glob
from sklearn.model_selection import train_test_split

def load_dataset_with_metadata(base_dir='data/raw_videos'):
    """Load processed data with metadata."""
    categories = ['good', 'over-the-top', 'early-extension', 'casting']
    
    all_data = []
    for category in categories:
        # Get all keypoint files for this category
        keypoint_files = glob.glob(f"{base_dir}/{category}/*_keypoints.csv")
        
        for keypoint_file in keypoint_files:
            # Derive base name to find corresponding metadata
            base_name = os.path.basename(keypoint_file).replace('_keypoints.csv', '')
            metadata_file = f"{base_dir}/{category}/{base_name}_metadata.json"
            
            if not os.path.exists(metadata_file):
                print(f"Warning: No metadata for {base_name}, skipping")
                continue
                
            # Load keypoints
            keypoints_df = pd.read_csv(keypoint_file)
            keypoints = keypoints_df.values
            
            # Load metadata
            with open(metadata_file, 'r') as f:
                metadata = json.load(f)
                
            # Get golfer info
            golfer_id = metadata.get('golfer_id')
            golfer_metadata = get_golfer_metadata(golfer_id)
            
            if not golfer_metadata:
                print(f"Warning: No golfer data for ID {golfer_id}, using defaults")
                golfer_metadata = {
                    'height_cm': 175.0,
                    'weight_kg': 75.0,
                    'handicap': 15.0,
                    'years_playing': 5.0,
                    'gender': 'unknown'
                }
            
            # Normalize sequence length
            if len(keypoints) > 60:
                start_idx = max(0, len(keypoints) // 2 - 30)
                keypoints = keypoints[start_idx:start_idx + 60]
            else:
                padding = np.zeros((60 - len(keypoints), keypoints.shape[1]))
                keypoints = np.vstack([keypoints, padding])
                
            # Create record with metadata features
            record = {
                'file_name': base_name,
                'category': category,
                'keypoints': keypoints.tolist(),
                'height_cm': golfer_metadata.get('height_cm', 175.0),
                'weight_kg': golfer_metadata.get('weight_kg', 75.0),
                'handicap': golfer_metadata.get('handicap', 15.0),
                'experience_years': golfer_metadata.get('years_playing', 5.0),
                'male': 1 if golfer_metadata.get('gender', '').lower().startswith('m') else 0,
                'female': 1 if golfer_metadata.get('gender', '').lower().startswith('f') else 0,
                'camera_distance_ft': metadata.get('camera_distance_ft', 12.0),
                'camera_height_ft': metadata.get('camera_height_ft', 4.0),
                'face_on': 1 if metadata.get('angle_type') == 'face-on' else 0,
                'down_the_line': 1 if metadata.get('angle_type') == 'down-the-line' else 0,
                'club_type': metadata.get('club_type', 'unknown'),
                'label_good': 1 if category == 'good' else 0,
                'label_over_the_top': 1 if category == 'over-the-top' else 0,
                'label_early_extension': 1 if category == 'early-extension' else 0,
                'label_casting': 1 if category == 'casting' else 0
            }
            all_data.append(record)
    
    return pd.DataFrame(all_data)

def get_golfer_metadata(golfer_id):
    """Get metadata for a specific golfer."""
    metadata_file = 'data/golfer_metadata.csv'
    if not os.path.exists(metadata_file):
        return None
        
    df = pd.read_csv(metadata_file)
    golfer_row = df[df['golfer_id'] == golfer_id]
    
    if golfer_row.empty:
        return None
        
    return golfer_row.iloc[0].to_dict()

def build_enhanced_model(input_shape, metadata_shape):
    """Build model that incorporates golfer metadata."""
    # Pose sequence input
    pose_input = tf.keras.Input(shape=input_shape, name='pose_input')
    pose_features = tf.keras.layers.LSTM(64, return_sequences=True)(pose_input)
    pose_features = tf.keras.layers.LSTM(32)(pose_features)
    pose_features = tf.keras.layers.Dense(16, activation='relu')(pose_features)
    
    # Metadata input
    metadata_input = tf.keras.Input(shape=metadata_shape, name='metadata_input')
    metadata_features = tf.keras.layers.Dense(8, activation='relu')(metadata_input)
    
    # Combine pose and metadata
    combined = tf.keras.layers.Concatenate()([pose_features, metadata_features])
    combined = tf.keras.layers.Dense(16, activation='relu')(combined)
    combined = tf.keras.layers.Dropout(0.2)(combined)
    
    # Output for each error type
    outputs = tf.keras.layers.Dense(4, activation='sigmoid')(combined)
    
    # Create model with multiple inputs
    model = tf.keras.Model(
        inputs=[pose_input, metadata_input],
        outputs=outputs
    )
    
    model.compile(
        optimizer='adam',
        loss='binary_crossentropy',
        metrics=['accuracy']
    )
    
    return model

def train_enhanced_model():
    # Load dataset with metadata
    dataset = load_dataset_with_metadata()
    
    # Prepare features
    X_pose = np.array([np.array(k) for k in dataset['keypoints']])
    
    # Metadata features (golfer stats + recording conditions)
    metadata_columns = [
        'height_cm', 'weight_kg', 'handicap', 'experience_years',
        'male', 'female', 'camera_distance_ft', 'camera_height_ft',
        'face_on', 'down_the_line'
    ]
    
    X_metadata = dataset[metadata_columns].values
    
    # Labels
    y = dataset[['label_good', 'label_over_the_top', 
                'label_early_extension', 'label_casting']].values
    
    # Split data
    X_pose_train, X_pose_test, X_metadata_train, X_metadata_test, y_train, y_test = train_test_split(
        X_pose, X_metadata, y, test_size=0.2, random_state=42
    )
    
    # Build model
    model = build_enhanced_model(
        input_shape=(X_pose_train.shape[1], X_pose_train.shape[2]),
        metadata_shape=(X_metadata_train.shape[1],)
    )
    
    # Train
    history = model.fit(
        {'pose_input': X_pose_train, 'metadata_input': X_metadata_train},
        y_train,
        epochs=30,
        batch_size=16,
        validation_data=({'pose_input': X_pose_test, 'metadata_input': X_metadata_test}, y_test),
        callbacks=[
            tf.keras.callbacks.EarlyStopping(patience=5, restore_best_weights=True),
            tf.keras.callbacks.ModelCheckpoint('models/enhanced_model.h5', save_best_only=True)
        ]
    )
    
    # Save model
    model.save('models/enhanced_swing_analyzer.h5')
    
    # Convert to TFLite
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()
    
    with open('models/enhanced_swing_analyzer.tflite', 'wb') as f:
        f.write(tflite_model)
        
    print("Enhanced model trained and exported!")
    return model, history

if __name__ == "__main__":
    train_enhanced_model()
