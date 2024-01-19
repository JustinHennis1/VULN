import argparse
import subprocess
import time
from datetime import datetime, timedelta
import os

def schedule_daily_task(time_str, file_path, log_file, custom_dir):
    try:
        # Parse the input time
        scheduled_time = datetime.strptime(time_str, '%H:%M:%S')

        while True:
            # Calculate the delay until the scheduled time
            now = datetime.now()
            scheduled_datetime = datetime(now.year, now.month, now.day, scheduled_time.hour, scheduled_time.minute, scheduled_time.second)
            delay = (scheduled_datetime - now).total_seconds()

            if delay > 0:
                print(f"Task scheduled at {scheduled_datetime}. Waiting for {delay} seconds...")
                time.sleep(delay)

                # Execute the command and redirect output to the log file
                with open(log_file, 'a') as log:
                    command = ['python', custom_dir, file_path]
                    subprocess.Popen(command, stdout=log, stderr=log, text=True, close_fds=True)
                    print(f"Command executed: {' '.join(command)}")

                # Schedule for the next day
                scheduled_datetime += timedelta(days=1)


            else:
                time.sleep(10)
                print("Scheduled time has already passed for today. Rescheduling for tomorrow.")
                print((datetime.now() - scheduled_datetime).total_seconds())

    except Exception as e:
        print(f"Error scheduling the task: {e}")

import os






if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Schedule a daily task to run customdirscan.py at a specified time.")
    parser.add_argument("time", help="Scheduled time in the format 'HH:MM:SS'")
    parser.add_argument("filepath", help="File path for customdirscan.py to operate on")
    parser.add_argument("logfile", help="Path to the log file")
    parser.add_argument("customdir", help="Path to the CustomDirScan.py")

    args = parser.parse_args()

    schedule_daily_task(args.time, args.filepath, args.logfile, args.customdir)
