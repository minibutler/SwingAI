import cv2
import mediapipe as mp
import numpy as np
import os
import json
import pandas as pd
from golfer_metadata import GolferMetadata
import time

class EnhancedDataCollector:
    def __init__(self):
        # Initialize MediaPipe Pose
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose(min_detection_confidence=0.5)
        
        # Initialize metadata tracker
        self.metadata_manager = GolferMetadata()
        
        # Load calibration if exists
        self.px_per_inch = 1.0
        if os.path.exists('data/calibration.txt'):
            with open('data/calibration.txt', 'r') as f:
                self.px_per_inch = float(f.read().strip())
        
    def record_swing(self, golfer_id, club_type, camera_distance_ft, 
                     camera_height_ft, angle_type='face-on', output_dir='data/swings'):
        """Record a new swing with metadata."""
        # Create output directory if needed
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        # Generate unique swing ID
        swing_id = f"{golfer_id}_{club_type}_{angle_type}_{int(time.time())}"
        
        # Prepare for recording
        cap = cv2.VideoCapture(0)
        frames = []
        recording = False
        
        print("Position for swing and press SPACE to start recording")
        print("Press ESC to cancel")
        
        while True:
            ret, frame = cap.read()
            if not ret:
                break
                
            # Show recording status
            status_text = "RECORDING" if recording else "Press SPACE to start"
            cv2.putText(frame, status_text, (10, 30), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, 
                       (0, 0, 255) if recording else (0, 255, 0), 2)
                       
            cv2.imshow('Record Swing', frame)
            
            key = cv2.waitKey(1) & 0xFF
            if key == ord(' ') and not recording:
                # Start recording
                recording = True
                print("Recording started... make your swing")
            elif key == 27:  # ESC
                print("Recording cancelled")
                cap.release()
                cv2.destroyAllWindows()
                return None
            
            if recording:
                frames.append(frame.copy())
                
                # Auto-stop after 5 seconds (150 frames at 30fps)
                if len(frames) >= 150:
                    break
        
        cap.release()
        cv2.destroyAllWindows()
        
        # Save video
        video_path = f"{output_dir}/{swing_id}.mp4"
        height, width = frames[0].shape[:2]
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')
        out = cv2.VideoWriter(video_path, fourcc, 30, (width, height))
        
        for frame in frames:
            out.write(frame)
        out.release()
        
        # Extract keypoints
        keypoints = self.extract_keypoints(frames)
        
        # Save keypoints
        keypoints_df = pd.DataFrame(keypoints)
        keypoints_df.to_csv(f"{output_dir}/{swing_id}_keypoints.csv", index=False)
        
        # Save metadata
        metadata = {
            'swing_id': swing_id,
            'golfer_id': golfer_id,
            'club_type': club_type,
            'camera_distance_ft': camera_distance_ft,
            'camera_height_ft': camera_height_ft,
            'angle_type': angle_type,
            'timestamp': time.time(),
            'frame_count': len(frames),
            'px_per_inch': self.px_per_inch
        }
        
        with open(f"{output_dir}/{swing_id}_metadata.json", 'w') as f:
            json.dump(metadata, f, indent=2)
            
        print(f"Swing recorded: {swing_id}")
        print(f"Video saved to: {video_path}")
        
        return swing_id
        
    def extract_keypoints(self, frames):
        """Extract pose keypoints from a sequence of frames."""
        keypoints = []
        
        for frame in frames:
            # Convert to RGB for MediaPipe
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            results = self.pose.process(frame_rgb)
            
            if results.pose_landmarks:
                # Extract frame keypoints
                frame_keypoints = []
                for landmark in results.pose_landmarks.landmark:
                    frame_keypoints.extend([landmark.x, landmark.y, landmark.z, landmark.visibility])
                keypoints.append(frame_keypoints)
            else:
                # If no landmarks detected, add zeros
                keypoints.append([0.0] * (33 * 4))  # 33 landmarks * 4 values
                
        return keypoints
