import winreg
import re
import time

# Define suspicious patterns
SUSPICIOUS_PATTERNS = [
    re.compile(r'powershell\.exe', re.IGNORECASE),
    re.compile(r'cmd\.exe', re.IGNORECASE),
    re.compile(r'wscript\.exe', re.IGNORECASE),
    re.compile(r'http:', re.IGNORECASE),
    re.compile(r'https:', re.IGNORECASE),
    re.compile(r'ftp:', re.IGNORECASE),
    # Add more patterns as needed
]

# Define registry locations for monitoring
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
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Internet Explorer\Main", "Start Page"),
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Internet Explorer\SearchScopes"),
    ],
    "Office Security": [
        (winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Office\16.0\Word\Security"),
    ],
    "Security Software": [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows Defender"),
    ],
}

# Helper functions
def convert_data_to_string(value, type):
    if type in (winreg.REG_SZ, winreg.REG_EXPAND_SZ, winreg.REG_LINK):
        return value.lower()
    elif type == winreg.REG_MULTI_SZ:
        return ' '.join(value).lower()
    elif type == winreg.REG_DWORD:
        return str(value)
    elif type == winreg.REG_BINARY:
        return ''.join(format(b, '02x') for b in value)
    return str(value).lower()

def log_suspicious_entry(path, name, value, reason):
    print(f"Suspicious entry detected: {path}\\{name}")
    print(f"Value: {value}")
    print(f"Reason: {reason}\n")

def matches_pattern(value):
    for pattern in SUSPICIOUS_PATTERNS:
        if pattern.search(value):
            return True
    return False

# Main function for checking entries
def check_suspicious_entries(hive, path, value_name=None):
    try:
        with winreg.OpenKey(hive, path, access=winreg.KEY_READ) as regkey:
            i = 0
            while True:
                try:
                    name, value, type = winreg.EnumValue(regkey, i)
                    data_str = convert_data_to_string(value, type)
                    if matches_pattern(data_str):
                        log_suspicious_entry(path, name, value, "Matched suspicious pattern")
                    i += 1
                except EnvironmentError:  # Ends when there are no more values
                    break
    except FileNotFoundError:  # Catching file not found error specifically
        print(f"Registry path not found: {path}")
    except EnvironmentError as e:  # For handling other permissions and errors
        print(f"Error accessing {path}: {e}")

def check_registry_changes(previous_state, current_state):
    # Compare previous and current states of registry keys
    for key in current_state:
        if key not in previous_state or previous_state[key] != current_state[key]:
            print(f"Change detected in registry key: {key}")
            print(f"Old value: {previous_state.get(key, 'N/A')}")
            print(f"New value: {current_state[key]}")

def snapshot_registry(hive, path):
    # Take a snapshot of registry keys and values
    snapshot = {}
    try:
        with winreg.OpenKey(hive, path, access=winreg.KEY_READ) as regkey:
            i = 0
            while True:
                try:
                    name, value, _ = winreg.EnumValue(regkey, i)
                    snapshot[name] = value
                    i += 1
                except EnvironmentError:  # Ends when there are no more values
                    break
    except EnvironmentError as e:
        print(f"Error accessing {path}: {e}")
    return snapshot                    

# Function to monitor registry continuously
def monitor_registry():
    while True:
        for category, paths in REGISTRY_LOCATIONS.items():
            print(f"Checking {category}...")
            for entry in paths:
                hive, path = entry[:2]  # Ensure only two items are unpacked
                value_name = entry[2] if len(entry) > 2 else None  # Handles optional value name
                check_suspicious_entries(hive, path, value_name)
        print("Sleeping for 60 seconds...\n")
        time.sleep(60)  # Sleep time between scans, adjust as needed

if __name__ == "__main__":
    monitor_registry()
