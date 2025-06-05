# Company folder file generator with fake embedded credentials

$folders = @(
    "C:\Company\Forms",
    "C:\Company\Policies",
    "C:\Company\Templates"
)

# Fake credentials to embed
$fakeCredentials = @(
    "username=corpUser1`npassword=Summer2023!",
    "login=templateadmin`npass=Templates#1",
    "user:policy_mgr`npassword: SecureDocs99",
    "account=hrform2022`npassword=Form@1234",
    "email=it_forms@company.local`npass=docAccess!@",
    "usr=doceditor`npasswd=Draft456!"
)

# Possible file extensions
$extensions = @(".docx", ".pdf", ".txt", ".xlsx")

# Generate files per folder
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }

    for ($i = 1; $i -le 100; $i++) {
        # Generate a realistic-looking filename
        $baseNames = @("Employee_Leave_Form", "Policy_Update", "Internal_Template", "Security_Notice", "HR_Form", "IT_Guideline", "Benefits_Overview", "Incident_Report", "Expense_Claim", "Code_of_Conduct")
        $name = ($baseNames | Get-Random) + "_" + (Get-Random -Minimum 1 -Maximum 100)
        $ext = $extensions | Get-Random
        $file = "$name$ext"
        $path = Join-Path $folder $file

        # Dummy content
        $content = @()
        $content += "This is an auto-generated file for training use only."
        $content += "Do not distribute externally. © Company Confidential"

        # Randomly add fake login/pass to ~8% of files
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 8) {
            $content += "`n--- INTERNAL USE ---`n$($fakeCredentials | Get-Random)"
        }

        # Write file
        $content | Out-File -FilePath $path -Encoding UTF8
    }

    Write-Host "✅ Created 100 files in $folder"
}