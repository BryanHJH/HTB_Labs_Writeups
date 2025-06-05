# Fake Sales Report Generator for CTF Labs
# Generates 100–500 CSV files with realistic-looking data

# Configurable Parameters
$OutputFolder = "C:\Sales\Reports"
$ReportCount = Get-Random -Minimum 300 -Maximum 500
$MinRows = 50
$MaxRows = 500

# Sample Data Pools
$Products = @("Laptop", "Monitor", "Keyboard", "Mouse", "Desk Chair", "Webcam", "Headset", "Docking Station", "Printer", "Scanner")
$Regions = @("North", "South", "East", "West", "Central")
$FirstNames = @("Alex", "Jamie", "Chris", "Taylor", "Jordan", "Morgan", "Riley", "Casey", "Skyler", "Quinn")
$LastNames = @("Smith", "Johnson", "Lee", "Brown", "Davis", "Garcia", "Miller", "Wilson", "Moore", "Taylor")

# Create output directory if it doesn't exist
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# Generate Reports
for ($i = 1; $i -le $ReportCount; $i++) {
    $RowCount = Get-Random -Minimum $MinRows -Maximum $MaxRows
    $ReportDate = Get-Date -Year (Get-Random -Minimum 2021 -Maximum 2024) -Month (Get-Random -Minimum 1 -Maximum 12) -Day (Get-Random -Minimum 1 -Maximum 28)
    $FileName = "SalesReport_$($i)_$($ReportDate.ToString('yyyyMMdd')).csv"
    $FilePath = Join-Path $OutputFolder $FileName

    # Header
    $csvContent = "Date,Customer,Region,Product,Quantity,UnitPrice,Total"

    for ($j = 1; $j -le $RowCount; $j++) {
        $Customer = "$($FirstNames | Get-Random) $($LastNames | Get-Random)"
        $Product = $Products | Get-Random
        $Region = $Regions | Get-Random
        $Quantity = Get-Random -Minimum 1 -Maximum 20
        $UnitPrice = [Math]::Round((Get-Random -Minimum 20 -Maximum 200) + (Get-Random), 2)
        $Total = [Math]::Round($Quantity * $UnitPrice, 2)
        $Date = $ReportDate.AddDays(-(Get-Random -Minimum 0 -Maximum 365)).ToString("yyyy-MM-dd")

        $csvContent += "`n$Date,$Customer,$Region,$Product,$Quantity,$UnitPrice,$Total"
    }

    # Write to file
    $csvContent | Out-File -FilePath $FilePath -Encoding UTF8
    Write-Host "Generated: $FilePath"
}

Write-Host "`nAll $ReportCount reports generated in '$OutputFolder'"
