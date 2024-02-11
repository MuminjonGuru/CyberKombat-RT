#            Muminjon Abduraimov
#       De Montfort University (Leicester)
# This script relies on the NetworkInfo.ps1 script

import csv
import os
import subprocess
import time

# Function to run the PowerShell script silently
def run_powershell_script(script_name):
    # Define startup info for subprocess to run silently
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
    startupinfo.wShowWindow = subprocess.SW_HIDE

    # Run the PowerShell script
    subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "-File", script_name],
                   startupinfo=startupinfo, capture_output=True)

# Function to check if a connection is suspicious
def is_suspicious(connection):
    return (
        int(connection['LocalPort']) in suspicious_ports or
        int(connection['RemotePort']) in suspicious_ports or
        connection['RemoteAddress'] in suspicious_remote_addresses
    )

# Define suspicious ports and IP addresses
suspicious_ports = [6667, 23, 21, 22, 80, 443, 8080, 445, 135, 139, 1433, 3306, 3389, 5900, 6000]
suspicious_remote_addresses = ['123.123.123.123', '192.168.1.100', '203.0.113.5']

# Path for the network_info.csv file
folder_path = os.path.join(os.path.expanduser('~'), 'Documents', 'CyberKombatData')
file_path = os.path.join(folder_path, 'network_info.csv')

# Run the PowerShell script
run_powershell_script("NetworkInfo.ps1")

# Read and analyze the network information from the CSV file
with open(file_path, 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for connection in reader:
        if is_suspicious(connection):
            print(f"Suspicious connection found: {connection}")

# Note: Ensure both this Python script and NetworkInfo.ps1 are in the same directory.
