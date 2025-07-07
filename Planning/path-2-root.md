# Planning
## Scanning
First, run a quick nmap scan and found out that the domain name is planning.htb.
Looking at the machine description, credentials were already given but this is a Linux machine, so most likely not an AD credential, bloodhound-python is not executed.
The nmap scan results show that there is a website, with the /etc/hosts entry, I can now visit the website by just using `planning.htb` 
In the website, went through it and didn't find anything interesting, including in the client-side JavaScript files.

## Website Enumeration
Ran `dirsearch` and `ffuf`, `dirsearch` for directory busting and `ffuf` for vhost busting.
For the vhost busting, used the namelist.txt from seclist's DNS folder.
From the vhost busting, found that there is a vhost called "grafana". This vhost busting took a very long time.
Added `grafana.planning.htb` into my `/etc/hosts` file.
Visited `grafana.planning.htb` and was presented with a login page, used the provided credentials in the machine description and was able to login.

## Web Exploitation
Once inside, however, didn't find anything interesting. There were a few interesting file paths, such as `/var/lib/grafana`, kept this in mind.
Went to search for any possible grafana exploits in github and found CVE-2024-9264, got a PoC for this CVE and was able to successfully exploit it.
I was able to use the PoC to read file such as the `/etc/passwd` and `/var/lib/grafana/grafana.ini` but these files didn't present any interesting info.
Tried the command execution feature of the PoC and in the environment variables, found a username, `enzo` and password. Using this pair of creds, was able to login to the machine via SSH.

## SSH Enumeration
Ran linpeas.sh (after importing from the attacker machine using python3 http server), noticed an interesting file `crontab.db` in the `/opt/` folder. Inside it was a password for a zip file. Noted that down.
Linpeas also showed in the network section, that there are other ports open as well, such as 3306,33060,8000,3000. 3306 and 33060 are useless; 3000 points back to the grafana instance, 8000 asks for login credentials. For the 8000 login, tried common passwords like admin:admin, root:root, root:admin, didn't work, tried those usernames with the found password in `crontab.db` and username root with the password worked.

## Privilege Escalation
Once inside the website in port 8000, it allows us to add cron jobs. And since the earlier `crontab.db` listed jobs that are not owned by `enzo`, we can infer that these jobs are run by `root`. So I created a new cron job that establishes a reverse connection to my kali attacker machine and save it to run every 1 minute. And I get a shell fafter that and got the root flag. User flag is in `enzo`'s home directory.
