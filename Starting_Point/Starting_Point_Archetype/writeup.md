# Archetype

Exploitation: Run nmap scan --> Use SMB to obtain file from public share --> Connect to mssql client using Impacket module --> Upload winPEAS to find priv escalation options --> Use Impacket psexec module to connect to target using Powershell with elevated credentials

## SMB
Commands used:

1. `smbmap -H IP_ADDRESS -L` --> To map out all available shares on the machine
2. `smbclient //IP_ADDRESS/SHARE` --> To connect to the share

## Impacket mssqlclient module
Run impacket mssqlclient with the prod.dtsConfig credentials with windows auth flag turned on. 
Tried using without the windows auth flag but failed

Command used: `impacket-mssqliclient DOMAIN/USERNAME:PASSWORD@IP_ADDRESS -windows-auth`

## Uploading winPEAS

Always try the easiest folders, like where you found the first flag (e.g. Desktop, Documents, Download).

## Impacket psexec module

When you have credentials, can always try this module to establish a PowerShell session with the target machine

