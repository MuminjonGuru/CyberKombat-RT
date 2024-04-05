import csv
import pyclamd

def scan_directory(directory_path):
    try:
        # Initialize the clamd connection
        cd = pyclamd.ClamdNetworkSocket('127.0.0.1', 3310)        

        # Scan the entire directory
        result = cd.multiscan_file(directory_path)

        # Print the scan results
        if result:
            print(f"Malware Found in {directory_path}:")
            for infected_file, virus_name in result.items():
                print(f"{infected_file}: {virus_name}")
        else:
            # Updated message for when no malware is found
            print(f"GREAT. Everything is fine in {directory_path}. No malware detected.")
    except Exception as e:
        print(f"An error occurred while scanning {directory_path}: {e}")

def read_directories_from_csv(file_path):
    directories = []
    with open(file_path, mode='r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row:  # Check if the row is not empty
                directories.append(row[0])
    return directories

# Example usage
csv_file_path = 'config/directories.csv'  # Update this path to your actual CSV file location
directories_to_scan = read_directories_from_csv(csv_file_path)

for directory in directories_to_scan:
    scan_directory(directory)