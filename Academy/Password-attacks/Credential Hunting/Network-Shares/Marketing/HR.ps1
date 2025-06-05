# HR file generator - only one file contains a decoy credential, sizes vary slightly

$folders = @("C:\HR\Confidential", "C:\HR\Public")

# One random location will contain the credential
$credential = "user=hr_backup`npassword=HRrocks2025!"
$allFiles = @()

# Define extensions and dummy base names
$extensions = @(".docx", ".pdf", ".txt", ".rtf")
$baseNames = @("HR_Guide", "Policy_Summary", "Benefits_Overview", "Onboarding_Docs", "Leave_Request", "Performance_Form", "Training_Info", "FAQ", "Holiday_Schedule", "Staff_Update")

# Generate 100 files in each folder
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }

    for ($i = 1; $i -le 100; $i++) {
        $name = ($baseNames | Get-Random) + "_" + (Get-Random -Minimum 100 -Maximum 999)
        $ext = $extensions | Get-Random
        $filename = "$name$ext"
        $filepath = Join-Path $folder $filename
        $allFiles += $filepath

        # Generate content with variable size
        $lineCount = Get-Random -Minimum 15 -Maximum 120
        $lines = @()
        for ($j = 1; $j -le $lineCount; $j++) {
            $lines += "This is line $j of the $name document. HR Internal Use Only."
        }

        # Write content to file
        $lines | Out-File -FilePath $filepath -Encoding UTF8
    }

    Write-Host "✅ Created 100 files in $folder"
}

# Pick ONE random file and insert the credential
$targetFile = $allFiles | Get-Random
Add-Content -Path $targetFile -Value "`nNOTE:`n$credential"
Write-Host "`n🔐 Credential hidden in: $targetFile (shh!)"
Write-Host "🔍 Tip: Search using: `findstr /si password C:\HR\*.*` or use Select-String in PowerShell"
