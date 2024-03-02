import winreg
import time

#  registry locations to monitor based on common malware persistence mechanisms
REGISTRY_LOCATIONS = {
    "Autostart": [
        (winreg.HKEY_LOCAL_MACHINE, r"Software\Microsoft\Windows\CurrentVersion\Run"),
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Run"),
        (winreg.HKEY_LOCAL_MACHINE, r"Software\Microsoft\Windows\CurrentVersion\RunOnce"),
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\RunOnce"),
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"),
        (winreg.HKEY_CURRENT_USER, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"),
    ],
    "Services": [
        (winreg.HKEY_LOCAL_MACHINE, r"System\CurrentControlSet\Services"),
    ],
    "DLL Hijacking": [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows", "AppInit_DLLs"),
    ],
    "Shell Extensions": [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved"),
    ],
    "Scheduled Tasks": [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree"),
    ],
    "Browser Hijacking": [
        # Assuming Internet Explorer examples; add paths for other browsers as needed
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Internet Explorer\Main", "Start Page"),
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Internet Explorer\SearchScopes"),
    ],
    "Office Security": [
        # Varies by Office version; this is an example for Office 2016
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Office\16.0\Word\Security"),
    ],
    "Security Software": [
        # Example path; adjust based on installed security solutions
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows Defender"),
    ],
}

# list of suspicious patterns 
SUSPICIOUS_PATTERNS = ["", ""]

# Function to check for suspicious registry entries
def check_suspicious_entries(hive, path, value_name=None):
    try:
        with winreg.OpenKey(hive, path, access=winreg.KEY_READ) as registry_key:
            if value_name:  # check given value
                try:
                    value, _ = winreg.QueryValueEx(registry_key, value_name)
                    data = str(value).lower()  # data to lowercase string for comparison
                    for pattern in SUSPICIOUS_PATTERNS:
                        if pattern in data:
                            print(f"Suspicious registry value: {path}\\{value_name} = {value}")
                except FileNotFoundError:
                    pass  # ignore
            else:  # check all values in the key
                i = 0
                while True:
                    try:
                        name, value, _ = winreg.EnumValue(registry_key, i)
                        data = str(value).lower()  #  data to lowercase string for comparison
                        for pattern in SUSPICIOUS_PATTERNS:
                            if pattern in data:
                                print(f"Suspicious registry entry: {path}\\{name} = {value}")
                        i += 1
                    except OSError:
                        break  # stop when no more values to enumerate
    except PermissionError:
        print(f"Permission denied accessing {path}")
    except FileNotFoundError:
        pass  # Path does not exist

#  continuously monitor the registry
def monitor_registry():
    while True:
        for category, locations in REGISTRY_LOCATIONS.items():
            print(f"Checking {category} registry entries...")
            for hive, path, *value in locations:
                check_suspicious_entries(hive, path, value[0] if value else None)``
        # print("Sleeping for 10 seconds...")
        time.sleep(10)

if __name__ == "__main__":
    monitor_registry()
