import os
import subprocess
import sys

def scan_directory(path):
    try:
        cmd = ["clamscan", "-r","--infected", path]
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        if result.returncode == 0:
            return f"{path} is clean."
        else:
            return result.stdout
    except subprocess.CalledProcessError as e:
        return f"{e.stdout}"
    except Exception as e:
        return f"An error occurred while scanning {path}: {e}"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <directory_to_scan>")
        sys.exit(1)

    directory_to_scan = sys.argv[1]

    try:
        for root, dirs, files in os.walk(directory_to_scan):
            for file in files:
                path = os.path.join(root, file)
                print(scan_directory(path))
    except Exception as e:
        print(f"An error occurred: {e}")