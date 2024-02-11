import csv

# Enhanced function to check if a process tree is suspicious
def is_suspicious(parent_id, child_processes, parent_name):
    # Example heuristic criteria for suspiciousness:
    
    # Known malicious process names
    malicious_names = ['badprocess.exe', 'malware.exe']
    if parent_name in malicious_names:
        return True
    
    # A suspiciously high number of child processes
    if len(child_processes) > 5:
        return True
    
    # Unusual child process names
    unusual_processes = ['cmd.exe', 'powershell.exe', 'wscript.exe']
    if any(child in unusual_processes for child in child_processes):
        return True
    
    # Add more heuristics as needed
    return False

# Read the process tree information from the CSV
with open('process_tree_info.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    
    process_tree = {}
    process_names = {}
    # Organize the child processes under their respective parents
    for entry in reader:
        parent_id = entry['ParentId']
        if parent_id not in process_tree:
            process_tree[parent_id] = []
        process_tree[parent_id].append(entry['ChildName'])
        process_names[parent_id] = entry['ParentName']  # Assuming the parent name is consistent

    # Check each process tree to see if it's suspicious
    for parent_id, child_processes in process_tree.items():
        if is_suspicious(parent_id, child_processes, process_names[parent_id]):
            print(f"Suspicious process tree: Parent ID {parent_id} ({process_names[parent_id]}) has the following child processes: {child_processes}")

# You might want to refine what constitutes a suspicious process tree based on further analysis or emerging threat intelligence.
