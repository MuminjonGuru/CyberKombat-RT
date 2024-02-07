# ProcessTreeInfo.ps1
Get-WmiObject Win32_Process | 
ForEach-Object { 
    $process = $_
    $children = Get-WmiObject Win32_Process -Filter "ParentProcessId = $($process.ProcessId)"
    $children | ForEach-Object {
        [PSCustomObject]@{
            ParentId = $process.ProcessId
            ParentName = $process.Name
            ChildId = $_.ProcessId
            ChildName = $_.Name
        }
    }
} | Export-Csv -Path "process_tree_info.csv" -NoTypeInformation

# This script uses WMI (Windows Management Instrumentation) to fetch all running processes and their child processes,
#  outputting the results to a CSV file with process IDs and names for both parents and children.