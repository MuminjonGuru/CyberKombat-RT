import csv
import pyclamd
import os
import time
import stat

def scan_directory(directory_path):
    try:
        cd = pyclamd.ClamdNetworkSocket('127.0.0.1', 3310)
        result = cd.multiscan_file(directory_path)
        if result:
            print(f"Malware Found in {directory_path}:")
            for infected_file, virus_name in result.items():
                print(f"{infected_file}: {virus_name}")
                if attempt_delete(infected_file):
                    print(f"Deleted {infected_file} as it was infected with {virus_name}.")
                else:
                    print(f"Failed to delete {infected_file}.")
        else:
            print(f"No malware detected in {directory_path}.")
    except Exception as e:
        print(f"An error occurred while scanning {directory_path}: {e}")

def attempt_delete(file_path):
    """Attempt to delete a file, changing permissions if necessary and retrying on failure."""
    try:
        os.remove(file_path)
        return True
    except PermissionError:
        # Change file permissions and try again
        os.chmod(file_path, stat.S_IWUSR)
        try:
            os.remove(file_path)
            return True
        except Exception as e:
            print(f"Retry failed: {e}")
            return False
    except Exception as e:
        print(f"Initial delete failed: {e}")
        return False

def read_directories_from_csv(file_path):
    directories = []
    with open(file_path, mode='r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row:
                directories.append(row[0])
    return directories

# Example usage
csv_file_path = 'D:\\CyberKombat RT\\config\\directories.csv'
directories_to_scan = read_directories_from_csv(csv_file_path)

for directory in directories_to_scan:
    scan_directory(directory)
