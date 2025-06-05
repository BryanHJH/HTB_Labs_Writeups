# Marketing file generator with one embedded credential, realistic extensions

$folders = @("C:\Marketing\Assets", "C:\Marketing\Campaigns")

# One decoy credential to embed
$credential = "login=ad_mgr`npassword=Brand2025!"
$allFiles = @()

# File extensions suitable for marketing content
$extensions = @(".jpg", ".png", ".pptx", ".pdf", ".txt")
$baseNames = @(
    "Brand_Guide", "Ad_Concept", "Logo_Design", "Campaign_Summary",
    "Q1_Presentation", "Social_Posts", "Client_Pitch", "Print_Mockup",
    "Event_Assets", "Product_Promo"
)

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

        # Create variable-sized dummy content
        $lines = @()
        $lineCount = Get-Random -Minimum 10 -Maximum 80

        for ($j = 1; $j -le $lineCount; $j++) {
            $lines += "Line $j : This is placeholder content for $name."
        }

        # Save dummy content (simulated file of ~a few KB)
        $lines | Out-File -FilePath $filepath -Encoding UTF8
    }

    Write-Host "✅ Created 100 files in $folder"
}

# Insert the credential in one random file
$targetFile = $allFiles | Get-Random
Add-Content -Path $targetFile -Value "`nNOTE:`n$credential"
Write-Host "`n🔐 Credential hidden in: $targetFile"
