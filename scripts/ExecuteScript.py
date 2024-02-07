import subprocess
import time

# Define the PowerShell script path
powershell_script = 'SaveNetworkInfo.ps1'

# Run the PowerShell script from Python
subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "./" + powershell_script], capture_output=True)

# Wait for the file to be written (adjust the sleep time as needed)
time.sleep(5)

# Now read the CSV and check for suspicious activity
# (The CSV reading code from the previous example would be here)
