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
                if os.path.isfile(infected_file):  # Ensure it's a file, not a directory
                    print(f"{infected_file}: {virus_name}")
                    # Attempt to delete the infected file
                    if attempt_delete(infected_file):
                        print(f"Deleted {infected_file} as it was infected with {virus_name}.")
                    else:
                        print(f"Failed to delete {infected_file}. Permission denied or file is in use.")
                else:
                    print(f"Skipped {infected_file} because it's a directory.")
        else:
            print(f"No malware detected in {directory_path}.")
    except Exception as e:
        print(f"An error occurred while scanning {directory_path}: {e}")

def attempt_delete(file_path):
    """Attempt to delete a file, handling permissions if necessary."""
    try:
        os.remove(file_path)
        return True
    except PermissionError:
        # Try changing the file's permission to writable and then delete
        os.chmod(file_path, stat.S_IWUSR)
        try:
            os.remove(file_path)
            return True
        except Exception as e:
            print(f"Retry failed: {e}")
            return False
    except Exception as e:
        print(f"Failed to delete {file_path}: {e}")
        return False

def read_directories_from_csv(file_path):
    directories = []
    with open(file_path, mode='r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row:  # Check if the row is not empty
                directories.append(row[0])
    return directories

# Example usage
csv_file_path = 'D:\\CyberKombat RT\\config\\directories.csv'  # Update this path to your actual CSV file location
directories_to_scan = read_directories_from_csv(csv_file_path)

for directory in directories_to_scan:
    scan_directory(directory)
