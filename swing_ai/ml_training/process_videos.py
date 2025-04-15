import os
import glob
from data_collector import extract_keypoints

# Directories
VIDEO_DIR = 'data/raw_videos'
OUTPUT_DIR = 'data/processed_keypoints'

# Create output directories
for category in ['good', 'over_the_top', 'early_extension', 'casting']:
    os.makedirs(f'{OUTPUT_DIR}/{category}', exist_ok=True)

# Process each category
for category in os.listdir(VIDEO_DIR):
    category_path = os.path.join(VIDEO_DIR, category)
    if not os.path.isdir(category_path):
        continue
        
    print(f"Processing {category} swings...")
    videos = glob.glob(f"{category_path}/*.mp4")
    
    for video_path in videos:
        print(f"  Extracting from {os.path.basename(video_path)}")
        frames, keypoints = extract_keypoints(
            video_path, 
            f"{OUTPUT_DIR}/{category}"
        )
        print(f"  Extracted {len(keypoints)} frames of data")

print("Processing complete!")
