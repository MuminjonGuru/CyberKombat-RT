import os
import subprocess

def scan_pdf(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file)
                # Call pdfid.py script here
                result = subprocess.run(['python', 'pdfid.py', full_path], capture_output=True, text=True)
                if 'JavaScript' in result.stdout or 'EmbeddedFile' in result.stdout:
                    print(f"WARNING: The file {full_path} contains JavaScript or an embedded file.")

# Get the username from the environment variables
user_name = os.getenv('USERNAME')

# Main directories to scan
directories = [
    f'C:\\Users\\{user_name}\\Downloads',
    f'C:\\Users\\{user_name}\\Downloads\\Documents'
]

for directory in directories:
    scan_pdf(directory)
