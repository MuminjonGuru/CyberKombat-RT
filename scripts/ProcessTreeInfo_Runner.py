import subprocess

# Run the PowerShell script from Python
subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "./SaveProcessTreeInfo.ps1"], capture_output=True)

# The output CSV is now ready to be read by the Python script for analysis
# (The CSV reading and analysis code from the previous example would be here)
