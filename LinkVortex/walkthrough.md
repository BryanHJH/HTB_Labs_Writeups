# LinkVortex

## Tools used

1. GitHack
2. [Ghost Arbitrary File Read vulnerability](https://github.com/0xDTC/Ghost-5.58-Arbitrary-File-Read-CVE-2023-40028)

## Scanning and Enumeration

### Nmap scan results

```bash
nmap --min-rate 3000 -p- -A 10.10.11.47
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-26 22:05 +08
Nmap scan report for linkvortex.htb (10.10.11.47)
Host is up (0.085s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   256 3e:f8:b9:68:c8:eb:57:0f:cb:0b:47:b9:86:50:83:eb (ECDSA)
|_  256 a2:ea:6e:e1:b6:d7:e7:c5:86:69:ce:ba:05:9e:38:13 (ED25519)
80/tcp open  http    Apache httpd
|_http-title: BitByBit Hardware
|_http-generator: Ghost 5.58
|_http-server-header: Apache
| http-robots.txt: 4 disallowed entries
|_/ghost/ /p/ /email/ /r/
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94SVN%E=4%D=12/26%OT=22%CT=1%CU=33226%PV=Y%DS=2%DC=T%G=Y%TM=676
OS:D62BA%P=x86_64-pc-linux-gnu)SEQ(SP=103%GCD=1%ISR=108%TI=Z%CI=Z%II=I%TS=A
OS:)SEQ(SP=104%GCD=1%ISR=108%TI=Z%CI=Z%TS=A)SEQ(SP=104%GCD=1%ISR=108%TI=Z%C
OS:I=Z%II=I%TS=A)SEQ(SP=104%GCD=1%ISR=109%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M542ST
OS:11NW7%O2=M542ST11NW7%O3=M542NNT11NW7%O4=M542ST11NW7%O5=M542ST11NW7%O6=M5
OS:42ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%
OS:T=40%W=FAF0%O=M542NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)
OS:T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=
OS:40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0
OS:%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=1
OS:64%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8888/tcp)
HOP RTT       ADDRESS
1   141.80 ms 10.10.16.1
2   37.95 ms  linkvortex.htb (10.10.11.47)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 39.23 seconds

```

Based on the Nmap scan results, there are only 2 ports open, which are port 22 (SSH) and port 80 (HTTP). Since SSH is less likely to have exploits available, the first thing to do is to investigate port 80.

### Visiting the website

To visit the website, we will first need to add the domain of the website into the `/etc/hosts` file. The domain of this website is `linkvortex.htb`.

After adding the domain into `/etc/hosts`, we can visit `http://linkvortex.htb` in our web browser to see what the website looks like. It is a blog and there doesn't seem to be any obvious vulnerabilities.

So, the other thing to do is to find any hidden directories or subdomains for this domain. This was done using ffuf. The commands used are as below:

1. `ffuf -u http://linkvortex.htb/FUZZ -w /usr/share/wordlists/dirb/big.txt -mc 200` -- For directory busting
2. `ffuf -u http://linkvortex.htb -H "Host: FUZZ.linkvortex.htb" -w /usr/share/wordlists/dirb/big.txt -mc 200` -- For subdomain busting

The results from the subdomain busting returned a dev subdomain. Visiting this subdomain reveals a directory which seems to be a git repository.

To download the git repository for further investigation, I used the tool, [`GitHack`](https://github.com/lijiejie/GitHack). This tool will download all the git folders, logs and commits from the provided URL.

### Exploring the Git repository

Once the git repository is downloaded, we can explore its contents. In the `authentication.test.js` file, we can see numerous credentials stored there, but the only useful one is ***OctopiFociPilfer45*** paired with the username/email of ***[admin@linkvortex.htb](admin@linkvortex.htb)***.

## Exploitation

Using the pair of credentials, we can use them to un the [Arbitrary File Read exploit](https://github.com/0xDTC/Ghost-5.58-Arbitrary-File-Read-CVE-2023-40028). Using this file, we can read the file listed in the Dockerfile in the downloaded git repository. 

After reading the file, we can a new set of credentials, this time for the user `bob`. So using these new pair of credentials, we can try to login to the SSH server. Once logged in, we will have the user flag.

## Privilege Escalation

In the same directory, there is also a text file called `abc.txt` which is a symbolic link to `/root/root.txt`, the root flag. However, we cannot read it with our current permissions. So we will need to perform privilege escalation. 

The first thing I did was run `sudo -l` and it seems that we can run a script, `/opt/ghost/clean_symlink.sh` using `sudo`. Looking into the script, it seems that this script allows us to view the contents of a file linked to a PNG, if the CHECK_CONTENT flag is set to true.

Using this script, we can first create a new png, and link it to abc.txt. Then execute this script, with CHECK_CONTENT set to True to read the root.txt file. 
