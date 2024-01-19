import subprocess
import sys

def clamd_scan(file_path):
    try:
        # Run clamdscan command
        result = subprocess.run(['clamdscan', '--infected', file_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        print(result.stdout)
        # Check if the file is clean or infected
        if "FOUND" in result.stdout:
            return f"Virus detected in {file_path}:\n{result.stdout}"
        else:
            return f"No viruses found in {file_path}"
    except subprocess.CalledProcessError as e:
        return f"{e.stdout}"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python clamd_scan.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    scan_result = clamd_scan(file_path)

    print(scan_result)
