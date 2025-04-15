import tensorflow as tf
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

# Load dataset
dataset = pd.read_pickle('data/swing_dataset.csv')

# Prepare features and labels for multi-class model
X = np.array([np.array(k) for k in dataset['keypoints']])
y = dataset[['label_good', 'label_over_the_top', 
             'label_early_extension', 'label_casting']].values

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Define model
model = tf.keras.Sequential([
    tf.keras.layers.LSTM(64, input_shape=(X_train.shape[1], X_train.shape[2]), return_sequences=True),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.LSTM(32),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(4, activation='sigmoid')  # 4 classes
])

model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

# Train
history = model.fit(
    X_train, y_train,
    epochs=20,
    batch_size=16,
    validation_data=(X_test, y_test),
    callbacks=[
        tf.keras.callbacks.EarlyStopping(patience=5, restore_best_weights=True),
        tf.keras.callbacks.ModelCheckpoint('models/best_model.h5', save_best_only=True)
    ]
)

# Export to TFLite for mobile
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('models/swing_error_detector.tflite', 'wb') as f:
    f.write(tflite_model)

print("Model trained and exported to TFLite!")
