import os
import subprocess
from datetime import datetime

def evaluate_threat_level(warnings):
    if 'contains an embedded file' in warnings:
        return 'HIGH THREAT', warnings
    elif 'contains JavaScript' in warnings:
        return 'MODERATE THREAT', warnings
    else:
        return 'LOW THREAT', warnings

def check_pdf_for_warnings(result_stdout, full_path, log_file):
    warnings = []
    criteria = {
        ' JavaScript ': 'contains JavaScript',
        ' EmbeddedFile ': 'contains an embedded file',
        ' /AA ': 'contains additional actions',
        ' /OpenAction ': 'has an open action',
        ' /AcroForm ': 'contains AcroForms',
        ' /RichMedia ': 'contains RichMedia',
        ' /Launch ': 'contains launch actions',
        ' /Encrypt ': 'is encrypted'
    }
    for key, message in criteria.items():
        if key in result_stdout:
            warnings.append(message)

    if warnings:
        threat_level, detailed_warnings = evaluate_threat_level(warnings)
        warning_messages = ', '.join(detailed_warnings)
        final_message = f"{threat_level}: The file {full_path} {warning_messages}.\n"
        log_file.write(final_message)  # Write the final message to the file

def scan_pdf(directory, log_file):
    start_message = f"Scanning... {datetime.now()}\n"
    print(start_message.strip())  # Print to stdout for Python4Delphi to capture
    # log_file.write(start_message)  # Also write to the log file
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file).lower()
                if full_path in processed_files:
                    continue
                processed_files.add(full_path)

                try:
                    result = subprocess.run(['python', 'pdfid.py', full_path], capture_output=True, text=True, timeout=30, creationflags=subprocess.CREATE_NO_WINDOW)
                    check_pdf_for_warnings(result.stdout, full_path, log_file)
                except Exception as e:
                    error_message = f"ERROR: An unexpected error occurred while scanning {full_path}: {str(e)}\n"
                    print(error_message.strip())  # Print errors to stdout
                    # log_file.write(error_message)  # Also write errors to the file

    complete_message = f"Scan complete. {datetime.now()}\n"
    print(complete_message.strip())  # Print to stdout for Python4Delphi to capture
    # log_file.write(complete_message)  # Also write to the log file

processed_files = set()

# Get the username from the environment variables
user_name = os.getenv('USERNAME')

# Main directories to scan
directories = [f'C:\\Users\\{user_name}\\Downloads\\Documents']

if __name__ == '__main__':
    log_file_path = 'D:\CyberKombat RT\logs\pdf_logs.txt'  # Define the path to the log file
    with open(log_file_path, 'a') as log_file:  # Open the file in append mode
        for directory in directories:
            scan_pdf(directory, log_file)
