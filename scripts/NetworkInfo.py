import csv
import json
import logging
import os
import subprocess
import threading
import time

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Suspicious criteria defined directly in the script
suspicious_criteria = {
    "suspicious_ports": [
        # Common ports used for malicious activity
        135, 139, 445, 3389, # Windows services often exploited
        21, 22, 23, # FTP, SSH, Telnet (often used for brute-forcing)
        6667, # IRC (can be used for command and control)
        # Ports for common services that are often misconfigured or vulnerable
        80, 443, 8080,  # HTTP, HTTPS (web servers)
        1433, # Microsoft SQL Server
        3306, # MySQL
        5900, 6000 # VNC (remote desktop)
    ],
    "suspicious_remote_addresses": [
        # Well-known malicious IP addresses or ranges (examples)
        "123.123.123.123",  # Placeholder for a known bad IP
        "198.51.100.0/24",  # Example of a malicious network range
        # Reserved private IP addresses (should not be seen in external traffic)
        "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" 
    ],
}

# Function to run the PowerShell script silently
def run_powershell_script(script_name):
    try:
        # Configure startup settings to prevent the PowerShell window from showing
        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startupinfo.wShowWindow = subprocess.SW_HIDE

        # Execute the PowerShell script with the specified startup settings
        subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "-File", script_name],
                       capture_output=True, check=True, startupinfo=startupinfo)
        logging.info("PowerShell script executed successfully.")
    except subprocess.CalledProcessError as e:
        logging.error("Failed to run PowerShell script:")
        logging.error(e.stdout)  # Log standard output on error
        logging.error(e.stderr)  # Log standard error

# Function to check if a connection is suspicious
def is_suspicious(connection):
    return (
        int(connection['LocalPort']) in suspicious_criteria['suspicious_ports'] or
        int(connection['RemotePort']) in suspicious_criteria['suspicious_ports'] or
        connection['RemoteAddress'] in suspicious_criteria['suspicious_remote_addresses']
    )

# Analyze connections in a separate thread
def analyze_connections(file_path):
    try:
        with open(file_path, 'r') as csvfile:
            reader = csv.DictReader(csvfile)
            for connection in reader:
                if is_suspicious(connection):
                    logging.info(f"Suspicious connection found: {connection}")
    except Exception as e:
        logging.error(f"Failed to analyze connections: {e}")

# Main function to run the analysis
def main():
    folder_path = os.path.join(os.path.expanduser('~'), 'Documents', 'CyberKombatData')
    file_path = os.path.join(folder_path, 'network_info.csv')

    run_powershell_script(r"D:\CyberKombat RT\scripts\NetworkInfo.ps1")

    # Wait briefly for the CSV file to be ready
    time.sleep(0.25)

    # Start analysis in a separate thread
    analysis_thread = threading.Thread(target=analyze_connections, args=(file_path,))
    analysis_thread.start()

if __name__ == "__main__":
    main()
