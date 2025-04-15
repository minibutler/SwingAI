import os
import argparse
from golfer_metadata import GolferMetadata
from recording_protocol import setup_recording
from enhanced_data_collector import EnhancedDataCollector

def main():
    parser = argparse.ArgumentParser(description='Golf Swing Data Collector')
    parser.add_argument('--setup', action='store_true', help='Run camera setup guide')
    parser.add_argument('--new-golfer', action='store_true', help='Add a new golfer')
    parser.add_argument('--record', action='store_true', help='Record a new swing')
    parser.add_argument('--golfer-id', type=str, help='Existing golfer ID')
    parser.add_argument('--club', type=str, help='Club type (e.g., driver, 7-iron)')
    parser.add_argument('--angle', type=str, choices=['face-on', 'down-the-line'], 
                        default='face-on', help='Camera angle')
    parser.add_argument('--category', type=str, 
                        choices=['good', 'over-the-top', 'early-extension', 'casting'],
                        help='Swing error category')
    
    args = parser.parse_args()
    
    # Initialize helpers
    metadata_manager = GolferMetadata()
    data_collector = EnhancedDataCollector()
    
    # Run appropriate action
    if args.setup:
        setup_recording()
        
    elif args.new_golfer:
        # Collect golfer info
        print("\n=== NEW GOLFER REGISTRATION ===")
        height = float(input("Height (cm): "))
        weight = float(input("Weight (kg): "))
        gender = input("Gender (m/f/other): ")
        age = int(input("Age: "))
        handicap = float(input("Handicap (enter 0 for beginner): "))
        years_playing = float(input("Years playing golf: "))
        hand = input("Dominant hand (right/left): ")
        
        # Register golfer
        golfer_id = metadata_manager.add_golfer(
            height, weight, gender, age, handicap, years_playing, hand)
            
        print(f"\nGolfer registered with ID: {golfer_id}")
        print("Use this ID when recording swings")
        
    elif args.record:
        if not args.golfer_id:
            print("Error: --golfer-id is required for recording")
            return
            
        if not args.club:
            print("Error: --club is required for recording")
            return
            
        if not args.category:
            print("Error: --category is required for recording")
            return
            
        # Set up output directory based on category
        output_dir = f"data/raw_videos/{args.category}"
        os.makedirs(output_dir, exist_ok=True)
        
        # Get recording parameters
        camera_distance = float(input("Camera distance from golfer (feet): "))
        camera_height = float(input("Camera height (feet): "))
        
        # Record the swing
        data_collector.record_swing(
            args.golfer_id, 
            args.club,
            camera_distance,
            camera_height,
            args.angle,
            output_dir
        )
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
