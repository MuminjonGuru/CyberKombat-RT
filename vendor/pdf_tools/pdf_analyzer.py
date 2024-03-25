import os
import subprocess

def scan_pdf(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.pdf'):
                full_path = os.path.join(root, file)
                try:
                    # Call pdfid.py script here
                    result = subprocess.run(['python', 'pdfid.py', full_path], capture_output=True, text=True, timeout=30)
                    if 'JavaScript' in result.stdout or 'EmbeddedFile' in result.stdout:
                        print(f"WARNING: The file {full_path} contains JavaScript or an embedded file.")
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
