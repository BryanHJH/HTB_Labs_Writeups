# Three

Exploitation: Visit website --> Add domain to /etc/hosts --> Perform directory busting and subdomain brute forcing --> Connect to aws s3 bucket --> Upload malicious files --> Establish reverse connection

## Directory busting and subdomain brute forcing

Tried using `ffuf` but it was unsuccessful but switching to gobuster (Specific command: `gobuster vhost --append-domain -r -u URL -w WORDLIST`). The reason why `ffuf` failed was because it was filtering out 404 responses. 

## Connecting to the aws s3 bucket

Must run `aws configure` initially, if the required parameters are not given by the challenge or client, just put arbitrary values into it  
Then to list out the contents of the s3 bucket run `aws --endpoint=URL s3 ls`, --endpoint is a must. 

## Uploading malicious files

Use the `aws s3 cp` command to copy local files to the s3 bucket. Shells are obtained through [swisskey's InternalAllTheThings repo](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/#bash-tcp) and [swisskey's PayloadAllTheThings repo](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files)

When trying to execute the payload, make sure to try encoding the commands as well when executing like replacing the spaces between the commands with %20

## Establishing the reverse connection

Using swisskey's repos above or [GTFObins](https://gtfobins.github.io/), just select the necessary payload and upload it and then execute it. Take not of the way of executing commands mentioned in [Uploading malicious files](## Uploading malicious files) 
