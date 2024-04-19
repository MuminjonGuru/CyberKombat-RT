import pyclamd
import os


def check_clamd_running(host='127.0.0.1', port=3310):
    try:
        cd = pyclamd.ClamdNetworkSocket(host, port)
        # Attempt to get the version of clamd to check if it's running
        version = cd.version()
        print(f"ClamAV daemon is running. Version: {version}")
        return cd  # Return the ClamAV connection object
    except pyclamd.ConnectionError:
        print("Failed to connect to ClamAV daemon. It may not be running.")
        return None

def handle_infected_file(file_path):
    try:
        os.remove(file_path)
        print(f"Deleted infected file: {file_path}")
        return True
    except PermissionError:
        print(f"Permission denied: Could not delete {file_path}")
        return False
    except Exception as e:
        print(f"Failed to delete {file_path}: {e}")
        return False

def scan_directory(directory_path):
    cd = check_clamd_running()
    if cd:
        try:
            # Scan the specified directory
            result = cd.multiscan_file(directory_path)
            if result:
                print(f"Malware found in {directory_path}:")
                for infected_file, virus_name in result.items():
                    if virus_name[0] == 'FOUND':  # Check if the result indicates malware was found
                        print(f"{infected_file}: {virus_name[1]}")  # Log the virus name
                        if handle_infected_file(infected_file):  # Attempt to delete the infected file
                            print(f"Successfully deleted {infected_file}.")
                        else:
                            print(f"Failed to delete {infected_file}.")
            else:
                print(f"No malware detected in {directory_path}.")
        except Exception as e:
            print(f"Error scanning {directory_path}: {e}")

# Example usage
scan_directory(r'C:\Users\user\Downloads\Compressed')
