import subprocess
import sys
import os

def scan_directory_for_infections(path):
    try:
        result = subprocess.run(['clamscan', '-r', '--infected', path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)

        if result.returncode == 0:
            return "No infected files found."
        else:
            return result.stdout
    except subprocess.CalledProcessError as e:
        return f"{e.stdout}"
    except OSError as e:
        return f"Error accessing {path}: {e}"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <directory_to_scan>")
        sys.exit(1)

    directory_to_scan = sys.argv[1]

    try:
        if not os.path.exists(directory_to_scan):
            print(f"Error: Directory '{directory_to_scan}' not found.")
            sys.exit(1)

        # Use the absolute path to handle the current directory correctly
        abs_path = os.path.abspath(directory_to_scan)

        scan_result = scan_directory_for_infections(abs_path)
        print(scan_result)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
