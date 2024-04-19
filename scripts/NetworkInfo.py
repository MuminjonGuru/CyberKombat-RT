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
    "suspicious_ports": [6667, 23, 21, 22, 80, 443, 8080, 445, 135, 139, 1433, 3306, 3389, 5900, 6000],
    "suspicious_remote_addresses": ["123.123.123.123", "192.168.1.100", "203.0.113.5"]
}

# Function to run the PowerShell script silently
def run_powershell_script(script_name):
    try:
        subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "-File", script_name],
                       capture_output=True, check=True)
        logging.info("PowerShell script executed successfully.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to run PowerShell script: {e}")

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

    run_powershell_script("NetworkInfo.ps1")

    # Wait briefly for the CSV file to be ready
    time.sleep(0.25)

    # Start analysis in a separate thread
    analysis_thread = threading.Thread(target=analyze_connections, args=(file_path,))
    analysis_thread.start()

if __name__ == "__main__":
    main()
