# Outbound

IP: 10.10.11.55 (arbitrary, not the real IP)
OS: Linux (Ubuntu)
Domain: outbound.htb

## Scanning

Ran an nmap scan and from the results found out that it has port 22 and 80 open (see nmap-scan-results).
At port 80, it is using the hostname of `mail.outbound.htb`, so I added this hostname in my `/etc/hosts`.
Once that entry is added, visited "http://mail.outbound.htb" in firefox and it placed me in a Roundcube Webmail login page.
Using tyler's credentials (provided on the challenge page), I was able to login to the website. In the website, tyler did not have any emails nor can I see any emails that tyler sent. But clicking on "About" at the bottom left corner, I can see that it is running Roundcube Webmail version 1.6.10.
Researching about this Roundcube Webmail version revealed that it is vulnerable to an authenticated RCE, which we have. 
So I started `msfconsole` and there is one module for this attack, put in the necessary options and started the attack and was able to successfully get a session. But this session did not have the user flag.

## Enumeration

So once inside the meterpreter shell, I am running as `www-data` in `mail`. Going to a few directories (e.g. `/home`, `/var/www/html`) did not give me any flags. So I imported `LinPEAS` and found credentials for MySQL. Connecting to the `roundcube` database with the credentials, I can see a few interesting tables, namely `session` and `users`. The `users` table did not yield anything useful, the hashes were not passwords.
In the `session` table, there was a 'var' column, asking ChatGPT, it seems that the values in 'var' are base64 encoded. So after decoding it, there's a bunch of settings-like information and a request_token field, which might give me a password. Taking this into mind, I continued to look for other stuff first. 
In the same config file where the MySQL file is found, there's another intersting line, which is the one with the 'des_key', it seems like something that can be used for decrypting secrets, so I saved it down as well. 
So going back to the var column, I dumped all the values in the 'var' column, saved it into a file and exported it to my Kali machine. 
In my Kali machine, I base64 decoded all the 'var' values and then went through the results. One of the results showed a username 'jacob' and a 'password' field. jacob is a directory that is found in the `/home` folder, meaning it is a user.
So, having this password that seems to be encrypted, and the 'des_key', I asked ChatGPT again and it provided me a script to decrypt it (decrypt_test.py) and it successfully decrypted the password for me.
With this password, I tried to use `su` to change into `jacob` and was successful. So I tried this password in the Roundcube Webmail website and I was able to login as well. Inside jacob's inbox, I saw an email from 'mel' saying that Jacob was given permission to view 'Below' logs, no idea what this is for now. And in another email, from 'tyler', saying that his password was reset into a default password.
Using that default password, I tried `ssh` since this is the only thing I haven't try up till now and all other places already can be logged in with existing found passwords. 
I was able to successfully login via ssh using jacob and the default password found.

## Exploitation

Once `ssh` is successful, I got the user flag in jacob's home directory. Note that I am now in `outbound` host instead of `mail` host. Apparently `mail` is a virtual machine in the `outbound` host. Again, I laoded up `LinPEAS` and found out that `jacob` can run `/usr/bin/below` without sudo password. Further digging allowed me to find out that `below` is actually a TUI-based performance monitoring tool. But running `/usr/bin/below` cannot drop me a shell, let me read or modify files owned by root. So, going back to what 'mel' said in her email, I went to dig in `/var/logs` to see what I can find as 'mel' said jacob was given permission to read some logs. In the `/var/logs` directory, there's a `below` directory, going in there, we can see that `error_root.log` has `rw` permissions for everyone. This may allow exploitation. But so far I had no idea on how to utilize this file with `/usr/bin/below` to escalate privileges. But reading this [article](https://seclists.org/oss-sec/2025/q1/201) and looking through discussions in forums, seems like we can replace the `error_root.log` file with a symlink pointing to any files and then we can get write permissions on the symlinked file. So, with this information, I created a temporary file that adds a user that has no password and has root privilges, rm the existing `error_root.log`, create a symlink from `/etc/passwd` to `error_root.log` and then run `sudo /usr/bin/below` to ensure that the `error_root.log` is created and symlinked properly. Once that is done, I copied my temporary file to the error_root.log (so that the symlinked file is edited as well) and then `su` into the new user, surprisingly it worked and I got the root flag.
