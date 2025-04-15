import cv2
import numpy as np
import time

def setup_recording(camera_id=0):
    """Guide for setting up consistent recording conditions."""
    cap = cv2.VideoCapture(camera_id)
    
    # Instructions
    instructions = [
        "RECORDING SETUP GUIDE",
        "=====================",
        "1. Place camera 10-15 feet from golfer",
        "2. Camera should be at chest height (4 feet)",
        "3. Use alignment sticks for consistent positioning",
        "4. Ensure good lighting conditions",
        "5. Press 'c' to start calibration"
    ]
    
    # Display instructions
    print("\n".join(instructions))
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
            
        # Display guide overlay
        h, w = frame.shape[:2]
        
        # Draw height reference lines (chest height)
        cv2.line(frame, (0, h//2-50), (w, h//2-50), (0, 255, 0), 1)
        cv2.putText(frame, "Target chest height", (10, h//2-60), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)
        
        # Draw distance guide
        cv2.putText(frame, "Camera should be 10-15 feet away", (10, 30), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)
        
        # Display alignment rectangle
        cv2.rectangle(frame, (w//4, h//4), (3*w//4, 3*h//4), (0, 0, 255), 2)
        cv2.putText(frame, "Golfer should fit in this box", (w//4, h//4-10), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1)
                   
        # Show frame
        cv2.imshow('Recording Setup Guide', frame)
        
        key = cv2.waitKey(1) & 0xFF
        if key == ord('c'):  # Start calibration
            break
        elif key == ord('q'):  # Quit
            cap.release()
            cv2.destroyAllWindows()
            return False
    
    # Calibration measurements
    print("\nCALIBRATION")
    print("===========")
    print("1. Place a standard golf club (e.g., 7-iron) in the frame")
    print("2. Make sure the club is upright and visible")
    print("3. Press 'space' to capture reference frame")
    
    reference_captured = False
    club_length_px = 0
    
    while not reference_captured:
        ret, frame = cap.read()
        if not ret:
            break
            
        cv2.putText(frame, "Position club and press SPACE", (10, 30), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        cv2.imshow('Calibration', frame)
        
        key = cv2.waitKey(1) & 0xFF
        if key == ord(' '):
            # Here you would measure club length in pixels
            # For simplicity, we'll ask the user
            cv2.destroyAllWindows()
            club_length_px = 300  # In a real app, detect this automatically
            
            # Get actual club length in inches
            club_length_in = float(input("Enter actual club length in inches: "))
            
            # Calculate pixels per inch
            px_per_inch = club_length_px / club_length_in
            print(f"Calibration: {px_per_inch:.2f} pixels per inch")
            
            # Save calibration to file
            with open('data/calibration.txt', 'w') as f:
                f.write(f"{px_per_inch}")
                
            reference_captured = True
        elif key == ord('q'):
            break
    
    cap.release()
    cv2.destroyAllWindows()
    return True
