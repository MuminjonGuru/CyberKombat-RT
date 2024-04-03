import pyclamd

def scan_directory(directory_path):
    try:
        # Initialize the clamd connection
        cd = pyclamd.ClamdNetworkSocket('127.0.0.1', 3310)        

        # Scan the entire directory
        result = cd.multiscan_file(directory_path)

        # Print the scan results
        if result:
            print("Malware Found:")
            for infected_file, virus_name in result.items():
                print(f"{infected_file}: {virus_name}")
        else:
            print("No malware found in the directory.")
    except Exception as e:
        print(f"An error occurred: {e}")


scan_directory(r'C:\Users\user\Downloads\Documents')
