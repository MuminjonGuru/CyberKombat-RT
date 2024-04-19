import csv
import pyclamd
import os

def scan_directory(directory_path):
    try:
        # Initialize the clamd connection
        cd = pyclamd.ClamdNetworkSocket('127.0.0.1', 3310)

        # Scan the entire directory
        result = cd.multiscan_file(directory_path)

        # Handle the scan results
        if result:
            print(f"Malware Found in {directory_path}:")
            for infected_file, virus_name in result.items():
                print(f"{infected_file}: {virus_name}")
                # Attempt to delete the infected file
                try:
                    os.remove(infected_file)
                    print(f"Deleted {infected_file} as it was infected with {virus_name}.")
                except PermissionError:
                    print(f"Failed to delete {infected_file}. Permission denied.")
                except Exception as e:
                    print(f"Failed to delete {infected_file}. Error: {e}")
        else:
            print(f"No malware detected in {directory_path}.")
    except Exception as e:
        print(f"An error occurred while scanning {directory_path}: {e}")

def read_directories_from_csv(file_path):
    directories = []
    with open(file_path, mode='r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row:
                directories.append(row[0])
    return directories

# Example usage
csv_file_path = 'D:\\CyberKombat RT\\config\\directories.csv'  # Update this path to your actual CSV file location
directories_to_scan = read_directories_from_csv(csv_file_path)

for directory in directories_to_scan:
    scan_directory(directory)
