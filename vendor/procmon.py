import subprocess
import os
import time

def run_powershell_script(script_name):
    # Define the full path to the PowerShell script
    script_path = os.path.join(os.getcwd(), script_name)
    
    # Run the PowerShell script silently
    subprocess.run(["powershell.exe", "-ExecutionPolicy", "Bypass", "-File", script_path], capture_output=True)

def analyze_output_file(file_path):
    # Placeholder function to analyze the output file
    # This function would be replaced by your actual analysis code
    print(f"Analyzing file: {file_path}")
    # Example: Open and read the file (assuming CSV format for simplicity)
    with open(file_path, 'r') as file:
        data = file.read()  # Assuming small file size for simplicity
        print(data)  # Placeholder for actual analysis

if __name__ == "__main__":
    # Name of the PowerShell script
    ps_script_name = "procmon.ps1"
    
    # Run the PowerShell script to start ProcMon and generate the output file
    print("Starting ProcMon capture...")
    run_powershell_script(ps_script_name)
    
    # Assuming the PowerShell script has a fixed output path or you adjust this path as needed
    output_file_path = os.path.join(os.path.expanduser('~'), 'Documents', 'CyberKombatData', 'ProcMonLog.pml')
    
    # Wait for a bit to ensure the PowerShell script has enough time to start ProcMon and generate the output
    # This delay may need to be adjusted based on how long your PowerShell script runs
    print("Waiting for the capture to complete...")
    
    # Now that the output file should exist, proceed to analyze it
    print("Capture complete. Analyzing output...")
    analyze_output_file(output_file_path)
