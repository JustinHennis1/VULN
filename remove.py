import subprocess
import sys

def remove_file(filename):
    try:
        # Run the 'rm' command using subprocess
        subprocess.run(["rm", filename])
        print(f"File '{filename}' removed successfully.")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def main():
    # Check if a file path is provided as a command-line argument
    if len(sys.argv) != 2:
        print("Usage: python script.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    remove_file(file_path)

if __name__ == "__main__":
    main()
