# Expressway

## Scanning

Ran an nmap scan with the normal flags,`-sV -A` but no interesting results came out, only port 22 (SSH). So performed a UDP scan with `-sU -v`, `-v` is used to quickly see any open ports as it is being discovered. Based on the UDP scan, UDP port 500 is open, which is normally used by IKE.

## Enumeration

Based on the nmap results, ran the `ikescan` tool according to [HackTricks](https://book.hacktricks.wiki/en/network-services-pentesting/ipsec-ike-vpn-pentesting.html), specifically the script to brute the ID and to obtain the hash for any identified ID (`ike-scan -M -A -n <ID> --pskcrack=hash.txt <IP>`). This command will save the captured hash into `hash.txt`, which is then converted into a john-crackable version using `ikescan2john`. It is then cracked using john.

Using the ID and the cracked password, can login via SSH.

## Post-Exploit Enumeration 

Once logged in via SSH, used `linpeas` to find for privilege escalation opportunities. Browsing through didn't find anything interesting. The results did show that the current user is part of the `proxy` group, but looked into the logs that `proxy` group has access to, didn't find anything interesting. Going through `linpeas` results again, it did told me to check for `sudo` version and see if it is vulnerable or not, did just that and found an exploit for it. 

## Privilege Escalation

Found exploit is related to CVE-2025-32463. The exploit is found in this [ExploitDB entry](https://www.exploit-db.com/exploits/52352). Following the steps here, able to obtain root access and gain root flag.  

