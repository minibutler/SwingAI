import os
import pandas as pd
import numpy as np
import glob

# Directories
KEYPOINTS_DIR = 'data/processed_keypoints'
OUTPUT_FILE = 'data/swing_dataset.csv'

def normalize_sequence_length(keypoints, target_length=60):
    """Normalize all sequences to the same length."""
    if len(keypoints) > target_length:
        # Take frames focusing on the critical part of the swing
        start_idx = max(0, len(keypoints) // 2 - target_length // 2)
        return keypoints[start_idx:start_idx + target_length]
    else:
        # Pad with zeros if too short
        padding = np.zeros((target_length - len(keypoints), keypoints.shape[1]))
        return np.vstack([keypoints, padding])

# Create dataset
all_data = []
for category in ['good', 'over_the_top', 'early_extension', 'casting']:
    csv_files = glob.glob(f"{KEYPOINTS_DIR}/{category}/*.csv")
    
    for csv_file in csv_files:
        # Load keypoints
        df = pd.read_csv(csv_file)
        keypoints = df.values
        
        # Normalize sequence length
        keypoints = normalize_sequence_length(keypoints)
        
        # Create record with label
        record = {
            'file_name': os.path.basename(csv_file),
            'category': category,
            'keypoints': keypoints.tolist(),
            'label_good': 1 if category == 'good' else 0,
            'label_over_the_top': 1 if category == 'over_the_top' else 0,
            'label_early_extension': 1 if category == 'early_extension' else 0,
            'label_casting': 1 if category == 'casting' else 0
        }
        all_data.append(record)

# Save dataset
dataset_df = pd.DataFrame(all_data)
dataset_df.to_pickle(OUTPUT_FILE)
print(f"Dataset created with {len(dataset_df)} samples")
