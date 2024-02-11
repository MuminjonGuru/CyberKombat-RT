import csv

# Define a list of malicious process names
malicious_names = [
    'badprocess.exe', 'malware.exe', 'svchost.exe', 'csrss.exe',
    'winlogon.exe', 'lsass.exe', 'smss.exe', 'rundll32.exe',
    'wmiprvse.exe', 'mshta.exe', 'powershell.exe', 'cmd.exe',
    'bitsadmin.exe', 'regsvr32.exe', 'certutil.exe',
]

# Define unusual child processes that might indicate suspicious activity
unusual_child_processes = ['cmd.exe', 'powershell.exe', 'mshta.exe', 'wscript.exe', 'cscript.exe', 'regsvr32.exe']

# Function to check if a process tree is suspicious
def is_suspicious(parent_id, child_processes, parent_name):
    # Check for known malicious process names
    if parent_name.lower() in malicious_names:
        return True

    # Check if a benign process has suspicious child processes
    if parent_name.lower() not in malicious_names and any(child.lower() in unusual_child_processes for child in child_processes):
        return True

    # Example behavioral checks:
    # A suspicious process might have more than a certain number of child processes
    if len(child_processes) > 5:
        return True

    # Add more behavioral and contextual checks as needed
    return False

# Read the process tree information from the CSV
with open('process_tree_info.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)

    process_tree = {}
    process_names = {}  # Keep track of parent process names
    for entry in reader:
        parent_id = entry['ParentId']
        parent_name = entry['ParentName']  # Assuming CSV has a ParentName column
        if parent_id not in process_tree:
            process_tree[parent_id] = []
        process_tree[parent_id].append(entry['ChildName'])
        process_names[parent_id] = parent_name

    # Check each process tree to see if it's suspicious
    for parent_id, child_processes in process_tree.items():
        if is_suspicious(parent_id, child_processes, process_names[parent_id]):
            print(f"Suspicious process tree: Parent ID {parent_id} ({process_names[parent_id]}) has the following child processes: {child_processes}")

# Note: This script assumes your CSV includes a ParentName column. If not, you'll need to adjust the data extraction logic accordingly.
