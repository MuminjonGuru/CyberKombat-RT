# Automatically determine the script's directory
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Define the path for the CyberKombatData folder in the user's Documents directory
$folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "CyberKombatData")

# Check if the folder exists; if not, create it
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force
}

# Define the file path for the ProcMon log file within the CyberKombatData folder
$logFilePath = [System.IO.Path]::Combine($folderPath, "ProcMonLog.pml")

# Set the ProcMon executable path to be in the same directory as this script
$procMonExecutablePath = [System.IO.Path]::Combine($scriptPath, "procmon.exe")

# Check if ProcMon executable exists
if (-not (Test-Path -Path $procMonExecutablePath)) {
    Write-Error "ProcMon executable not found at path: $procMonExecutablePath"
    exit
}

# Start ProcMon with command-line arguments to begin capturing and minimize the window
& $procMonExecutablePath /Minimized /Quiet /BackingFile $logFilePath /LoadConfig $scriptPath\filter1.pmf

# Inform the user that capturing has started
Write-Host "ProcMon capturing has started. Log file will be saved to: $logFilePath"

# Wait for a specific duration for capturing (e.g., 60 seconds)
Start-Sleep -Seconds 60

# Stop ProcMon capturing
& $procMonExecutablePath /Terminate

# Inform the user that capturing has completed
Write-Host "ProcMon capturing has completed and the log file is saved at: $logFilePath"

# Note: Conversion to CSV/XML requires manual operation via ProcMon's GUI as of the current version.


<#

Exclude Commonly Accessed, Beginning Paths:

Operation: Path
Condition: excludes
Value: C:\Windows\, C:\Program Files\ (Adjust and add exclusions as necessary, but be cautious as malware can also operate within these directories.)
Monitor Specific File System Locations:

Operation: Path
Condition: begins with
Value: %APPDATA%, %TEMP%, %USERPROFILE% (Malware often drops files in these directories.)
Focus on Registry Operations:

Operation: Operation
Condition: is
Value: RegSetValue, RegCreateKey (Monitoring for creation or modification of registry keys can reveal persistence mechanisms.)
Network Activity:

Operation: Operation
Condition: is
Value: TCP Connect, TCP Send (To catch suspicious network connections or data exfiltration attempts.)
Look for Process and Thread Activity:

Operation: Operation
Condition: is
Value: Process Create, Thread Create (Monitoring process and thread creation can help identify malicious process injection or spawning.)
Exclude Known Good Processes:

Operation: Process Name
Condition: excludes
Value: explorer.exe, svchost.exe (Be cautious; while excluding common processes can reduce noise, malware can inject into these processes.)
Filter by Result to Identify Failed Operations:

Operation: Result
Condition: is
Value: NAME NOT FOUND, ACCESS DENIED (Failed operations can indicate scanning behavior or unauthorized access attempts.)

t #>