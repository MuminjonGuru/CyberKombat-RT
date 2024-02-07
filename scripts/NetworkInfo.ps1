# NetworkInfo.ps1

# Define the path for the CyberKombatData folder in the user's Documents directory
$folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "CyberKombatData")

# Check if the folder exists; if not, create it
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Define the file path for the CSV file within the CyberKombatData folder
$filePath = [System.IO.Path]::Combine($folderPath, "network_info.csv")

# Get active TCP connections and export them to the CSV file
Get-NetTCPConnection | Select-Object OwningProcess, LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Export-Csv -Path $filePath -NoTypeInformation

# This script retrieves active TCP connections using Get-NetTCPConnection and exports the data to a CSV file located in the CyberKombatData folder within the user's Documents directory.
