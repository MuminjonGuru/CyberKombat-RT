# ProcessTreeInfo.ps1 - Optimized Version

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

# Export the results to a CSV file
$results | Export-Csv -Path "process_tree_info.csv" -NoTypeInformation
