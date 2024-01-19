import subprocess

def run_freshclam():
    try:
        # Run the sudo freshclam command
        subprocess.run(['sudo', 'freshclam'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)  
        print("freshclam command executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error executing freshclam command: {e}")

if __name__ == "__main__":
    run_freshclam()