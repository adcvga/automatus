#!/usr/bin/env bash
cat subdomains.txt | httpx | waybackurls > urls.txt
gf sqli urls.txt >> sqli.txt
bash ./sqltamp.sh
