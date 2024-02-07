import csv

# Define a threshold for what you consider suspicious, e.g., high memory usage
memory_threshold = 100000000  # 100 MB

# Function to check if a process is suspicious
def is_suspicious(process):
    return (
        int(process['WS']) > memory_threshold
    )

# Read the process information from the CSV
with open('process_info.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for process in reader:
        if is_suspicious(process):
            print(f"Suspicious process found: {process['ProcessName']} with ID {process['Id']} using {process['WS']} bytes of memory")

# This is a simple rule, and you can expand it with more sophisticated checks

