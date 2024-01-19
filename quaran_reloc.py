import os
import shutil

def quaran_reloc(quarantine_folder, destin_dir):
    
    # Loop through all files in the quarantine folder
    for file_name in os.listdir(quarantine_folder):
        quarantined_file = os.path.join(quarantine_folder, file_name)

        # Check if it's a file and not a directory
        if os.path.isfile(quarantined_file):
            # Construct the destination path
            destin_path = os.path.join(destin_dir, file_name)

            # Move the file to the destination
            shutil.move(quarantined_file, destin_path)

            print(f"Moved: {file_name} to {destin_dir}")

