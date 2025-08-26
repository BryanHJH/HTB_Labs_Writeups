# CodeTwo

Box IP : 10.10.11.82
Attacker IP: 10.10.16.9

## Scanning 

Started with an [nmap scan](./nmap-scan-results), and based on the results, there are no domain names for this box and only ports 22 and 8000 are open. Port 22 is normally not the way to get the initial foothold, so port 8000 is the way to go.

## Enumeration

Visiting the website at port 8000, I am able to see a login button, donwload app and register. I quickly registered and then logged in to the account and is greeted with acode box. Tried running some code and is able to verify that the code that is executed is JavaScript. Went back to the homepage and downloaded the app, which is a zip file named `app.zip`. Unzipped the file and saw the source code, the app is built using Python and then the application is converting the JavaScript code that we provide in the codebox to Python bytecode using `js2py`. Doing a quick Google Search, there is a CVE attached to js2py that allows RCE, tried the module from `msfconsole` but that tidd not work. Then checked out the PoC from [GitHub](https://github.com/Marven11/CVE-2024-28397-js2py-Sandbox-Escape). Based on the PoC shown, needed to make some changes to make the exploit work, updated script is [poc.py](./poc.py). 

After running [poc.py], a reverse shell is established, I used penelope to start my listener.

## Exploitation

Once the reverse shell is established, the user in the session is `app`. However, the user flag is not in this user. So I went to the `/home` directory to see which other users are in this machine, and I saw that `marco` is a user. I then did a quick `grep -Rn` for passwords in the `app`'s directory but there isn't any interesting info. I then did another quick `grep` to find anything related to marco and the `users.db` is highlighted. So I accessed the db file using `sqlite3` and in the db file, there is a table named `user`. In this table, there's the password hash for marco, which I then cracked with `hashcat`. With `marco`'s password, I can now SSH into the machine. 

## Privilege escalation

Once I SSH'ed into the machine, I obtained the user flag in `marco`'s home directory. After that, I imported `linpeas.sh` and ran it. `linpeas.sh` is able to identify that I can run `npbackup-cli` without sudo password. So I quickly ran `sudo npbackup-cli -h` to know how to use this tool and what flags there are. I also quickly read the source code of `npbackup-cli` in `/usr/local/bin` and found that the `--external-backend-binary` is restricted. So with the knowledge of how to use this tool and knowing the restriction, I was able to create a malicious `mal.conf` file by first making a copy of the original `npbackup.conf` in `marco`'s home directory and adding `- /bin/sh -c "chmod u+s /bin/bash"` to `pre_exec_commands` entry in the new `mal.conf`. 

Once that is added, I ran `sudo npbackup-cli -c mal.conf -b` and I got a root shell.
