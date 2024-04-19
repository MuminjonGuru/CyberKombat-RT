import csv
import pyclamd
import os
import stat

def scan_file(file_path):
    try:
        # Initialize the clamd connection
        cd = pyclamd.ClamdNetworkSocket('127.0.0.1', 3310)

        # Scan the individual file
        result = cd.scan_file(file_path)

        # Handle the scan result
        if result:
            virus_name = result[file_path][1]
            print(f"{file_path}: {virus_name}")
            if attempt_delete(file_path):
                print(f"Deleted {file_path} as it was infected with {virus_name}.")
            else:
                print(f"Failed to delete {file_path}. Permission denied or file is in use.")
        else:
            print(f"No malware detected in {file_path}.")
    except Exception as e:
        print(f"An error occurred while scanning {file_path}: {e}")

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

def scan_directory(directory_path):
    # Iterate through each file in the directory
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            scan_file(file_path)

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
