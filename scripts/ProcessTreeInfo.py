import csv

# Function to check if a process tree is suspicious
def is_suspicious(parent_id, child_processes):
    # Define your own logic here. For example:
    # A suspicious process might have more than a certain number of child processes
    return len(child_processes) > 5

# Read the process tree information from the CSV
with open('process_tree_info.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    
    process_tree = {}
    # Organize the child processes under their respective parents
    for entry in reader:
        parent_id = entry['ParentId']
        if parent_id not in process_tree:
            process_tree[parent_id] = []
        process_tree[parent_id].append(entry['ChildName'])

    # Check each process tree to see if it's suspicious
    for parent_id, child_processes in process_tree.items():
        if is_suspicious(parent_id, child_processes):
            print(f"Suspicious process tree: Parent ID {parent_id} has the following child processes: {child_processes}")

# You might want to refine what constitutes a suspicious process tree



# In this Python script, you define what you consider to be a suspicious process tree—such as a parent 
# process having an unusually high number of child processes. The script organizes processes into trees
# based on the parent-child relationships and then prints details of any process tree it flags as suspicious.