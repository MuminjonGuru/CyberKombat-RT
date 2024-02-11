# ProcessTreeInfo.ps1 - Optimized Version with Dynamic Output Directory

# Define the path for the CyberKombatData folder in the user's Documents directory
$folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "CyberKombatData")

# Check if the folder exists; if not, create it
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Define the file path for the CSV file within the CyberKombatData folder
$filePath = [System.IO.Path]::Combine($folderPath, "process_tree_info.csv")

# Fetch all processes at once to avoid repeated WMI queries
$allProcesses = Get-CimInstance Win32_Process

# Initialize an array to hold the results
$results = @()

# Iterate over all processes to match parent and child processes
foreach ($process in $allProcesses) {
    # Filter child processes in memory
    $children = $allProcesses | Where-Object { $_.ParentProcessId -eq $process.ProcessId }

    # Construct the custom object for each child process and add it to the results array
    foreach ($child in $children) {
        $results += [PSCustomObject]@{
            ParentId = $process.ProcessId
            ParentName = $process.Name
            ChildId = $child.ProcessId
            ChildName = $child.Name
        }
    }
}

# Export the results to the CSV file at the determined file path
$results | Export-Csv -Path $filePath -NoTypeInformation
