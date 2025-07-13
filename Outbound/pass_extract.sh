#!/bin/bash

input="/home/kali/Documents/HTB_Labs_Writeups/Outbound/vars_raw.txt"
output="/home/kali/Documents/HTB_Labs_Writeups/Outbound/vars_with_password.txt"

> "$output"  # clear output file

while IFS= read -r line; do
  decoded=$(echo "$line" | base64 -d 2>/dev/null)
  if echo "$decoded" | grep -qi "password"; then
    echo "[+] Matching session:" >> "$output"
    echo "$decoded" >> "$output"
    echo "---" >> "$output"
  fi
done < "$input"

echo "[*] Done. Saved matches to $output"

