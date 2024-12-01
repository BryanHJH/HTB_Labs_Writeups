# Crocodile

Application exploited: FTP --> Website --> Directory busting --> Password spraying

## FTP

FTP is detected as "open" from the nmap scan and further scripts focused on ftp are executed to further understand the FTP configuration and apparently, FTP Anonymous login is allowed. So the command to connect is just `ftp IP_ADDRESS`.

## Website

Another point is that port 80 is open, so meaning a website is being served. Other ports that indicate a website is being served via the IP address are:

1. 443 --> HTTPS
2. 8080 --> HTTP
3. 8880 --> HTTP
4. 8443 --> HTTPS

## Directory busting

Since a website is being served, the next logical thing is to perform directory busting, so we can use different tools such as:

1. gobuster
2. feroxbuster
3. dirsearch* (My preferred tool)
4. dirbuster
5. dirb

## Password spraying

From the directory busting, a login page is found, and since from the FTP connection earlier, we were able to get some username-like names and passwords, we can test it here.

We can either do it manually (which was what I did since there was only a few), or we can use Burp Suite or Caido to automate it. When using Burp Suite, we will first send and intercept a dummy request and then send that request to Intruder. Once in Intruder, we will select the attack type as "Clusterbomb" and paste in the relevant details and start the attack. Caido should have a similar workflow in their Automate tab. 
