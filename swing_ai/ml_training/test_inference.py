import tensorflow as tf
import numpy as np
import cv2
import mediapipe as mp
from data_collector import extract_keypoints

# Load model
interpreter = tf.lite.Interpreter(model_path="models/swing_error_detector.tflite")
interpreter.allocate_tensors()

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Error categories
error_types = ['good swing', 'over-the-top', 'early extension', 'casting']

def analyze_swing(video_path):
    """Analyze a golf swing video."""
    # Extract keypoints
    frames, keypoints = extract_keypoints(video_path, 'temp')
    
    # Normalize data as in training
    if len(keypoints) > 60:
        start_idx = max(0, len(keypoints) // 2 - 30)
        keypoints = keypoints[start_idx:start_idx + 60]
    else:
        padding = np.zeros((60 - len(keypoints), len(keypoints[0])))
        keypoints = np.vstack([keypoints, padding])
    
    # Run inference
    keypoints = np.array([keypoints], dtype=np.float32)
    interpreter.set_tensor(input_details[0]['index'], keypoints)
    interpreter.invoke()
    
    # Get results
    output = interpreter.get_tensor(output_details[0]['index'])[0]
    
    # Find most likely error
    max_idx = np.argmax(output)
    result = {
        'detected_error': error_types[max_idx],
        'confidence': float(output[max_idx]),
        'all_scores': {error_types[i]: float(output[i]) for i in range(len(error_types))}
    }
    
    return result

# Test on a new video
test_video = "data/test_swings/test_swing1.mp4"
result = analyze_swing(test_video)
print(f"Analysis result: {result['detected_error']} (confidence: {result['confidence']:.2f})")
print("All scores:", result['all_scores'])
