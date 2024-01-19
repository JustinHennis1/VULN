import subprocess
import schedule
import time
from datetime import datetime

def run_script_b():
    try:
        # Run script_b.py using subprocess
        process = subprocess.Popen(['python3 Database_reset.py'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
#        print("Database Reset!")
        return_code = process.wait()
        
        if return_code == 0:
            print("Database Reset!")
        else:
            error_message = process.stderr.read()
            print(f"Error executing script_b.py. Return code: {return_code}. Error message: {error_message}")

    except subprocess.CalledProcessError as e:
        print(f"Error executing script_b.py: {e}")

def job():
    print(f"Running job at {datetime.now()}")
    run_script_b()

if __name__ == "__main__":
    # Schedule the job to run every 30 minutes
    schedule.every(1).minutes.do(job)

    # Keep the script running to allow the scheduler to work
    while True:
        schedule.run_pending()
        time.sleep(1)
        