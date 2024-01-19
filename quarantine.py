import os
import shutil
import sys

def quarantine_file(file_path, quarantine_folder):
    try:
        # Create the quarantine folder if it doesn't exist
        if not os.path.exists(quarantine_folder):
            os.makedirs('quarantine_folder')
            quarantine_folder = 'quarantine_folder'

        # Move the file to the quarantine folder
        shutil.move(file_path, os.path.join(quarantine_folder, os.path.basename(file_path)))
        print(f"File '{file_path}' moved to quarantine.")
    except Exception as e:
        print(f"Error while quarantining file '{file_path}': {e}")
def main():
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 3:
        print("Usage: python script.py <file_path> <quarantine_folder>")
        sys.exit(1)

    # Extract command-line arguments
    file_path = sys.argv[1]
    quarantine_folder = sys.argv[2]

    # Call the quarantine_file function with the provided arguments
    quarantine_file(file_path, quarantine_folder)
    
if __name__ == "__main__":
    main()

