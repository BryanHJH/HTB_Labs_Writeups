# Configuration
$folderPath = "C:\Sales\Leads"
$numberOfFiles = 312

# Sample data pools
$firstNames = @("John", "Jane", "Alex", "Taylor", "Chris", "Morgan", "Jordan", "Sam", "Casey", "Robin")
$lastNames  = @("Smith", "Johnson", "Lee", "Brown", "Davis", "Garcia", "Martinez", "Clark", "Adams", "Walker")
$companies  = @("Contoso", "Fabrikam", "Globex", "Initech", "Stark Industries", "Wayne Enterprises", "Wonka Inc", "Umbrella Corp", "Cyberdyne", "Hooli")
$status     = @("Hot", "Warm", "Cold", "Qualified", "Contacted", "Unresponsive")

# Ensure directory exists
New-Item -ItemType Directory -Path $folderPath -Force | Out-Null

# Helper function to generate a random lead
function New-Lead {
    $first = Get-Random $firstNames
    $last  = Get-Random $lastNames
    $company = Get-Random $companies
    $leadStatus = Get-Random $status
    $date = (Get-Date).AddDays(-1 * (Get-Random -Minimum 0 -Maximum 730)) # Last 2 years
    return [PSCustomObject]@{
        FirstName = $first
        LastName = $last
        Company = $company
        Status = $leadStatus
        ContactDate = $date.ToShortDateString()
    }
}

# Generate lead files with random size
for ($i = 1; $i -le $numberOfFiles; $i++) {
    $lead = New-Lead
    $fileName = "{0}_{1}_{2}.txt" -f $lead.LastName, $lead.FirstName, $i
    $fullPath = Join-Path $folderPath $fileName

    # Create base content
    $content = @"
Lead Name: $($lead.FirstName) $($lead.LastName)
Company: $($lead.Company)
Status: $($lead.Status)
Contact Date: $($lead.ContactDate)

Notes:
- Followed up via email.
- Interested in a demo.
- Assigned to inside sales.
"@

    # Randomize file size by adding random padding
    $randomPadding = Get-Random -Minimum 500 -Maximum 1500
    $paddingText = ""

    for ($j = 1; $j -le $randomPadding; $j++) {
        $paddingText += "Random Padding Line $j`r`n"
    }

    # Combine base content with padding
    $finalContent = $content + $paddingText

    # Write the content to the file
    Set-Content -Path $fullPath -Value $finalContent

    # Optionally, you can simulate a random file size by adjusting padding
    $fileSize = (Get-Item $fullPath).Length
    Write-Host "Generated $fileName with size $($fileSize / 1KB) KB"
}

Write-Host "✅ Generated $numberOfFiles sample lead files with randomized sizes in $folderPath"
