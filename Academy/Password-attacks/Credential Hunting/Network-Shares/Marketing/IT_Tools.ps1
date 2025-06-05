$TargetDir = "C:\IT\Tools"

# Ensure directory exists
if (!(Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
}

# Base files (including hidden credential)
$files = @{
    "patchlog.txt" = @"
Patch applied successfully on 2024-11-03
System reboot scheduled for 2024-11-04
Issues detected in module AUTH_X32
Review logs under /var/log/sys_patch/
"@

    "deploy_instructions.txt" = @"
1. Extract package.zip to C:\ProgramData\Tools
2. Run setup.exe as Administrator
3. Accept all prompts, then restart machine
4. Validate installation with healthcheck.ps1
"@

    "checklist_2023.txt" = @"
- Antivirus updated
- Backup complete
- Logs rotated
- Temporary files cleared
"@

    "config.ini" = @"
[Settings]
AutoUpdate=True
RebootRequired=False
Timeout=45
"@

    "notes_config_old.txt" = @"
Old settings for legacy VPN deployment:
- Use split tunneling where possible
- DNS resolution priority = local > remote

# Auth backup: jbader:ILovePower333###

- Ports used: 443, 8443, 1194
"@

    "tools_list.csv" = @"
ToolName,Version,LastUpdated
NetDiag,1.4,2023-12-02
WinAudit,3.1,2024-03-11
FileHashTool,2.0,2022-11-15
"@

    "readme.txt" = @"
This directory contains essential tools and notes used by the IT department.
Do not modify files unless you're part of the system admin team.
"@
}

# Write base files
foreach ($file in $files.Keys) {
    $path = Join-Path $TargetDir $file
    $files[$file] | Out-File -FilePath $path -Encoding UTF8
    Write-Host "Created $file"
}

# Generate ~100 realistic log files
$logCount = Get-Random -Minimum 95 -Maximum 110
$logPhrases = @(
    "INFO Connection successful to remote host.",
    "WARNING CPU usage exceeded threshold: 87%",
    "ERROR Could not resolve DNS for internal resource.",
    "DEBUG Process exited with code 0",
    "INFO Backup completed at",
    "NOTICE Service restart triggered by user",
    "FAILURE Authentication failed for user admin",
    "INFO User logged out",
    "TRACE Packet dropped due to policy rule",
    "ALERT Unauthorized login attempt detected"
)

for ($i = 1; $i -le $logCount; $i++) {
    $logName = "log_$i.log"
    $logPath = Join-Path $TargetDir $logName
    $lines = Get-Random -Minimum 10 -Maximum 300

    $logContent = @()
    for ($j = 1; $j -le $lines; $j++) {
        $timestamp = Get-Date -Year (Get-Random -Minimum 2021 -Maximum 2024) `
                             -Month (Get-Random -Minimum 1 -Maximum 12) `
                             -Day (Get-Random -Minimum 1 -Maximum 28) `
                             -Hour (Get-Random -Minimum 0 -Maximum 23) `
                             -Minute (Get-Random -Minimum 0 -Maximum 59) `
                             -Second (Get-Random -Minimum 0 -Maximum 59) `
                             -Format "yyyy-MM-dd HH:mm:ss"
        $phrase = $logPhrases | Get-Random
        $logContent += "$timestamp $phrase"
    }

    $logContent | Out-File -FilePath $logPath -Encoding UTF8
    Write-Host "Generated log: $logName with $lines lines"
}

Write-Host "`n✅ All files and logs have been created in '$TargetDir'"
