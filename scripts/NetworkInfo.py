#            Muminjon Abduraimov
#       De Montfort University (Leicester)
# This script relies on the NetworkInfo.ps1 script

import csv
import json
import logging
import os
import subprocess
import threading
import time

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to load suspicious criteria from a config file
def load_suspicious_criteria(config_file='suspicious_criteria.json'):
    try:
        with open(config_file, 'r') as file:
            return json.load(file)
    except Exception as e:
        logging.error(f"Failed to load suspicious criteria: {e}")
        return None

# Function to run the PowerShell script silently
def run_powershell_script(script_name):
    try:
        subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", "-File", script_name],
                       capture_output=True, check=True)
        logging.info("PowerShell script executed successfully.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to run PowerShell script: {e}")

# Function to check if a connection is suspicious
def is_suspicious(connection, criteria):
    return (
        int(connection['LocalPort']) in criteria['suspicious_ports'] or
        int(connection['RemotePort']) in criteria['suspicious_ports'] or
        connection['RemoteAddress'] in criteria['suspicious_remote_addresses']
    )

# Analyze connections in a separate thread
def analyze_connections(file_path, criteria):
    try:
        with open(file_path, 'r') as csvfile:
            reader = csv.DictReader(csvfile)
            for connection in reader:
                if is_suspicious(connection, criteria):
                    logging.info(f"Suspicious connection found: {connection}")
    except Exception as e:
        logging.error(f"Failed to analyze connections: {e}")

# Main function to run the analysis
def main():
    criteria = load_suspicious_criteria()
    if not criteria:
        return

    folder_path = os.path.join(os.path.expanduser('~'), 'Documents', 'CyberKombatData')
    file_path = os.path.join(folder_path, 'network_info.csv')

    run_powershell_script("NetworkInfo.ps1")

    # Wait briefly for the CSV file to be ready
    time.sleep(0.25)

    # Start analysis in a separate thread
    analysis_thread = threading.Thread(target=analyze_connections, args=(file_path, criteria))
    analysis_thread.start()

if __name__ == "__main__":
    main()
