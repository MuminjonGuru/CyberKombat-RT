#            Muminjon Abduraimov
#       De Montfort University (Leicester)
# This script relies on the  ProcessTreeInfo.ps1 script

import csv
import subprocess

# Define lists for known behaviors
known_malicious_processes = ['malware.exe', 'ransomware.exe', 'keygen.exe', 'patch.exe']
critical_system_processes = ['svchost.exe', 'lsass.exe']
# Example attributes
suspicious_attributes = {'hidden_window': True, 'high_memory_usage': 100000000}  

# Function to check if a process is suspicious based on various heuristics
def is_suspicious(process_info, child_processes):
    # High number of child processes
    if len(child_processes) > 5:
        return True

    # Check for known malicious child processes
    if any(child in known_malicious_processes for child in child_processes):
        return True

    # Special handling for critical system processes
    if process_info['ProcessName'] in critical_system_processes:
        return True

    # Check for suspicious attributes
    if process_info['MemoryUsage'] > suspicious_attributes['high_memory_usage']:
        return True
    if process_info.get('HasHiddenWindow', False) == suspicious_attributes['hidden_window']:
        return True

    # Additional heuristics can be added here

    return False

# Function to run the PowerShell script and get process information
def run_powershell_script(script_path):
    subprocess.run(["powershell.exe", "-ExecutionPolicy", "Unrestricted", script_path], capture_output=True)

# Main function to analyze processes
def analyze_processes():
    script_path = 'ProcessTreeInfo.ps1'
    run_powershell_script(script_path)

    # Read and analyze the process tree information
    with open('process_tree_info.csv', 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        process_tree = {}
        for entry in reader:
            process_id = entry['ParentId']
            if process_id not in process_tree:
                process_tree[process_id] = {'ProcessName': entry['ParentName'], 'ChildProcesses': []}
            process_tree[process_id]['ChildProcesses'].append(entry['ChildName'])

        for pid, info in process_tree.items():
            if is_suspicious(info, info['ChildProcesses']):
                print(f"Suspicious process detected: {info['ProcessName']} with PID {pid} and children {info['ChildProcesses']}")

analyze_processes()
