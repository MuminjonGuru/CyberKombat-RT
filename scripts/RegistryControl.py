import winreg
import time

#  registry locations to monitor based on common malware persistence mechanisms
REGISTRY_LOCATIONS = {

}

# list of suspicious patterns 


# Function to check for suspicious registry entries
def check_suspicious_entries(hive, path, value_name=None):
    try:
        with winreg.OpenKey(hive, path, access=winreg.KEY_READ) as registry_key:
            pass
    except PermissionError:
        print(f"Permission denied accessing {path}")
    except FileNotFoundError:
        pass  # Path does not exist; ignore

#  continuously monitor the registry
def monitor_registry():
    while True:
        
        # print("Sleeping for 10 seconds...")
        time.sleep(10)

if __name__ == "__main__":
    monitor_registry()
