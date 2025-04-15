import csv
import os
import uuid

class GolferMetadata:
    def __init__(self, metadata_file='data/golfer_metadata.csv'):
        self.metadata_file = metadata_file
        self.ensure_metadata_file()
        
    def ensure_metadata_file(self):
        """Create metadata file with headers if it doesn't exist."""
        if not os.path.exists(os.path.dirname(self.metadata_file)):
            os.makedirs(os.path.dirname(self.metadata_file))
            
        if not os.path.exists(self.metadata_file):
            with open(self.metadata_file, 'w', newline='') as f:
                writer = csv.writer(f)
                writer.writerow([
                    'golfer_id', 'height_cm', 'weight_kg', 'gender', 
                    'age', 'handicap', 'years_playing', 'dominant_hand'
                ])
    
    def add_golfer(self, height_cm, weight_kg, gender, age, 
                  handicap, years_playing, dominant_hand='right'):
        """Add a new golfer to the database and return their ID."""
        golfer_id = str(uuid.uuid4())[:8]  # Generate unique ID
        
        with open(self.metadata_file, 'a', newline='') as f:
            writer = csv.writer(f)
            writer.writerow([
                golfer_id, height_cm, weight_kg, gender, 
                age, handicap, years_playing, dominant_hand
            ])
        
        return golfer_id
