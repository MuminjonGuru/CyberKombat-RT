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

def check_pdf_for_warnings(result_stdout, full_path):
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
        # Directly print the final message
        final_message = f"{threat_level}: The file {full_path} {warning_messages}."
        print(final_message)
        return final_message  # This allows for potential future use beyond printing
    return None  # Indicates no warnings were found or printed

processed_files = set()  # Set to store paths of processed files

def scan_pdf(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file).lower()
                if full_path in processed_files:
                    continue
                processed_files.add(full_path)

                try:
                    result = subprocess.run(['python', 'pdfid.py', full_path], capture_output=True, text=True, timeout=30, creationflags=subprocess.CREATE_NO_WINDOW)
                    # Now, check_pdf_for_warnings handles everything
                    check_pdf_for_warnings(result.stdout, full_path)
                except Exception as e:
                    print(f"ERROR: An unexpected error occurred while scanning {full_path}: {str(e)}")

# Get the username from the environment variables
user_name = os.getenv('USERNAME')

# Main directories to scan
directories = [
    # f'C:\\Users\\{user_name}\\Downloads',
    f'C:\\Users\\{user_name}\\Downloads\\Documents'
]

for directory in directories:
    scan_pdf(directory)
