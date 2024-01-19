import subprocess
import concurrent.futures
import os


def scan_directory(path):
    try:
        cmd = ["sudo", "clamscan", "-r", "/"]
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        if result.returncode == 0:
            return f"{path} is clean."
        else:
            return f"{path} may contain infected files. ClamAV detected an issue."
    except Exception as e:
        return f"An error occurred while scanning {path}: {e}"

if __name__ == "__main__":
    try:
        for root, dirs, files in os.walk("/"):
            for file in files:
                path = os.path.join(root, file)
                print(scan_directory(path))
    except Exception as e:
        print(f"An error occurred: {e}")