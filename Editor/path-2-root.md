# Editor

## Enumeration 

### Nmap scan

Look into [nmap-scan-results](./nmap-scan-results). Based on the results, there's port 80 and 8080 open and the script scan reveals that the domain is `editor.htb`. So added `editor.htb` into `/etc/hosts`.

### Web enumeration

After adding the entry into `/etc/hosts`, visted `http://editor.htb` at port 80 but this page does not have any interesting. But at the page's footer, there's a link to the wiki, which has the subdomain `wiki.editor.htb`. Added this to my `/etc/hosts` file. 

Once that new domain is added in, visited it in the website and noticed that is running `XWiki`, it has 2 version numbers shown `XWiki 2.1` and `XWiki Debian 15.10.8`. Looked up online for both versions for any exploits and there are 2, either Directory Traversal or Remote Code Execution.

## Exploitation

### Directory Traversal on XWiki

Tried to find endpoints that has any directory traversal opportunities, there's this endpoint, http://editor.htb:8080/xwiki/bin/view/Main/?viewer=PAYLOAD, where it seemed to be vulnerable but it actually isn't, so moving on to the next possible exploit.

### Remote Code Execution on XWiki

There are several CVEs that says it is possible to perform RCE on XWiki, and CVE-2025-24893 seems to be more relevant to this scenario due to the version number being close to the one I detected. Using this [exploit](https://github.com/nopgadget/CVE-2025-24893/blob/main/CVE-2025-24893.py), I was able to gain a shell on the remote system, but it is not stable or interactive. So I started up `penelope` on another tab and ran a reverse shell back to my Kali machine to at least get an interactive shell.

Once I have the shell, I ran `grep -rn 'passw'` in the current directory and found a password 'theEd1t0rTeam99'. Tried logging into the website, did not work; tried `su` in the current reverse shell session to `oliver` (found this user from the `/home` directory), did not work; tried on `ssh` with `oliver` user, worked.

## Privilege Escalation

Once I SSHed into `oliver` on the target machine, I imported in `linpeas.sh` and ran it. From the results of `linpeas.sh`, found that there's a few interesting binaries at `/opt/netdata/usr/libexec/netdata/plugins.d`. Did a quick search about `netdata` and what local privilege escalation vectors for this tool and found one for `ndsudo` and luckily enough, `ndsudo` is found in the same directory.

Referred to this [website](https://sploitus.com/exploit?id=5077683C-F7E6-58BE-9375-B5A13A8782C5&utm_source=rss&utm_medium=rss) for the exploitation path and sucessfully obtained `root`.
