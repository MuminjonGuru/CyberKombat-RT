import os
import subprocess

def evaluate_threat_level(warnings):
    # High threat level if the PDF contains embedded files or certain dangerous combinations
    if 'contains an embedded file' in warnings:
        return 'HIGH THREAT', warnings
    # Moderate threat level if the PDF contains JavaScript but no embedded files
    elif 'contains JavaScript' in warnings:
        return 'MODERATE THREAT', warnings
    # Low threat level for other conditions
    else:
        return 'LOW THREAT', warnings

def check_pdf_for_warnings(result_stdout):
    warnings = []
    # Print output for debugging
    print("Debug - pdfid.py output:", result_stdout)
    criteria = {
        ' JavaScript ': 'contains JavaScript',  # Space around to prevent partial matches
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
    return warnings

processed_files = set()  # Set to store paths of processed files

def scan_pdf(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file).lower()  # Convert to lowercase to avoid case-sensitive duplicates
                if full_path in processed_files:
                    continue  # Skip this file since it's already been processed
                processed_files.add(full_path)  # Add the path to the set of processed files

                try:
                    result = subprocess.run(['python', 'pdfid.py', full_path], capture_output=True, text=True, timeout=30)
                    warnings = check_pdf_for_warnings(result.stdout)
                    if warnings:
                        threat_level, detailed_warnings = evaluate_threat_level(warnings)
                        warning_messages = ', '.join(detailed_warnings)
                        print(f"{threat_level}: The file {full_path} {warning_messages}.")
                except subprocess.TimeoutExpired:
                    print(f"ERROR: Scanning of {full_path} took too long and was terminated.")
                except subprocess.CalledProcessError as e:
                    print(f"ERROR: An error occurred while scanning {full_path}: {e}")
                except PermissionError:
                    print(f"ERROR: Permission denied for {full_path}.")
                except Exception as e:  # Handling other unforeseen errors
                    print(f"ERROR: An unexpected error occurred while scanning {full_path}: {str(e)}")

# Get the username from the environment variables
user_name = os.getenv('USERNAME')

# Main directories to scan
directories = [
    f'C:\\Users\\{user_name}\\Downloads',
    f'C:\\Users\\{user_name}\\Downloads\\Documents'
]

for directory in directories:
    scan_pdf(directory)
