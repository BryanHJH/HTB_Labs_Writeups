# Finance directory trap file generator with fake passwords/login strings

# Define directories
$PayrollDir = "C:\Finance\Payrolls"
$ReportsDir = "C:\Finance\Reports"

# Create directories if not present
foreach ($dir in @($PayrollDir, $ReportsDir)) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# Fake password snippets to embed randomly
$fakeCredentials = @(
    "login_temp=clerk01`npassword1234",
    "userID=payadmin`npass=Summer2024!",
    "username=sysfinance`npassword=FinSecure!",
    "User: audit_team`nPass: Welcome2022!",
    "emp_login: payrollsys`npasswd: qwerty#2023",
    "login_attempt=analyst4`nfailed_password=FinanceRules99"
)

# Create fake payroll files
for ($i = 1; $i -le 30; $i++) {
    $filename = "payroll_$i.txt"
    $filepath = Join-Path $PayrollDir $filename

    $lines = @()
    $lines += "Employee ID,Name,Gross Pay,Net Pay,Date"

    for ($j = 1; $j -le (Get-Random -Minimum 5 -Maximum 30); $j++) {
        $empId = Get-Random -Minimum 1000 -Maximum 9999
        $name = "Emp$empId"
        $gross = [Math]::Round((Get-Random -Minimum 3000 -Maximum 8000) + (Get-Random), 2)
        $net = [Math]::Round($gross * 0.82, 2)
        $date = Get-Date -Year 2024 -Month (Get-Random -Minimum 1 -Maximum 12) -Day (Get-Random -Minimum 1 -Maximum 28)
        $lines += "$empId,$name,$gross,$net,$($date.ToString("yyyy-MM-dd"))"
    }

    # Randomly insert a fake credential (only in a few)
    if ((Get-Random -Minimum 0 -Maximum 10) -lt 2) {
        $lines += "`n# DEBUG INFO:`n$($fakeCredentials | Get-Random)"
    }

    $lines | Out-File -FilePath $filepath -Encoding UTF8
}

# Create fake report files
for ($i = 1; $i -le 20; $i++) {
    $filename = "report_Q$((($i - 1) % 4) + 1)_202$(([math]::Floor($i / 4)) + 1).txt"
    $filepath = Join-Path $ReportsDir $filename

    $content = @"
Quarterly Financial Report

Revenue: \$$(Get-Random -Minimum 1000000 -Maximum 5000000)
Expenses: \$$(Get-Random -Minimum 500000 -Maximum 4000000)
Profit:   \$$(Get-Random -Minimum 100000 -Maximum 1000000)

Notes:
- All figures in USD
- Internal use only
"@

    # Randomly inject decoy login/pass if lucky
    if ((Get-Random -Minimum 0 -Maximum 10) -lt 3) {
        $content += "`n[Internal Notes]`n$($fakeCredentials | Get-Random)"
    }

    $content | Out-File -FilePath $filepath -Encoding UTF8
}

Write-Host "`n✅ Finance files generated:"
Write-Host " - Payrolls: $PayrollDir"
Write-Host " - Reports: $ReportsDir"
Write-Host "🔍 Some files contain fake 'password' or 'login' strings for grep-based challenges."
