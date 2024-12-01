# Redeemer writeup

Application exploited: Redis

## How to exploit Redis

First connecting to Redis databases in a Linux machine requires `redis-cli`. 
Command: `redis-cli -h IP_ADDRESS -p PORT`

Once connected to the Redis database, these commands are useful:

1. `info` --> To obtain information and statistics about the Redis database, e.g. Redis version
2. `select NUMBER` --> To select a database to interact with
2. `keys *` --> To obtain all the keys in the selected database
4. `dump KEY` --> To show the contents of the specified key
