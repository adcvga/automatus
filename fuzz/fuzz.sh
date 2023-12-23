#!/usr/bin/env bash
if [ $# -eq 0 ]
  then
    echo -e "No enough arguments! Using 'fuzz.sh https://example.com' without slashes \n"
    exit;
fi
R='\033[0;31m'   #'0;31' is Red's ANSI color code
G='\033[0;32m'   #'0;32' is Green's ANSI color code
Y='\033[1;32m'   #'1;32' is Yellow's ANSI color code
B='\033[0;34m'   #'0;34' is Blue's ANSI color code
N='\033[0m'

[ ! -d "./wordlists" ] && bash ./get_dict.sh

echo -e "${R}Start FUZZ...${N} \n"

URL=$1
THREADS=80
THREADS_SMALL=20
CLEANED_URL=$(echo "$URL" | sed -E 's/^\s*.*:\/\///g')
REPORT_DIR="./reports/$CLEANED_URL.dir"
WORDLISTS_DIR=./wordlists

echo "$REPORT_DIR"

mkdir -p "$REPORT_DIR"

fuzz_dir_rec_small(){
echo -e "\n ->  ${Y}fuzz directories${N} \n"
OUT="$REPORT_DIR/fuzz_dir_rec_small.json"
WORDLIST=$WORDLISTS_DIR/directory_only_one.small.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" -recursion -recursion-depth 6 -ac  -or -s
}

fuzz_dir_rec_full(){
echo -e "\n ->  ${Y}fuzz directories with big wordlist${N} \n"
OUT="$REPORT_DIR/fuzz_dir_rec_full.json"
WORDLIST=$WORDLISTS_DIR/top-10k-web-directories_from_10M_urlteam_links.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" -recursion -recursion-depth 4 -ac  -or -s
}

fuzz_env(){
echo -e "\n ->  ${Y}fuzz env${N} \n"
OUT="$REPORT_DIR/fuzz_env.json"
WORDLIST="$WORDLISTS_DIR/env.txt"
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_config(){
echo -e "\n ->  ${Y}fuzz config${N} \n"
OUT="$REPORT_DIR/fuzz_config.json"
WORDLIST="$WORDLISTS_DIR/config.txt"
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_htaccess(){
echo -e "\n ->  ${Y}fuzz htaccess${N} \n"
OUT="$REPORT_DIR/fuzz_htaccess.json"
WORDLIST=$WORDLISTS_DIR/htaccess
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_logs(){
echo -e "\n ->  ${Y}fuzz logs${N} \n"
OUT="$REPORT_DIR/fuzz_logs.json"
WORDLIST=$WORDLISTS_DIR/log.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_nginx(){
echo -e "\n ->  ${Y}fuzz nginx${N} \n"
OUT="$REPORT_DIR/nginx.json"
WORDLIST=$WORDLISTS_DIR/ngnix.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_npmrc(){
echo -e "\n ->  ${Y}fuzz npmrc${N} \n"
OUT="$REPORT_DIR/npmrc.json"
WORDLIST=$WORDLISTS_DIR/npmrc.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_yaml(){
echo -e "\n ->  ${Y}fuzz yaml${N} \n"
OUT="$REPORT_DIR/yaml.json"
WORDLIST=$WORDLISTS_DIR/yaml.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_backup_files(){
echo -e "\n ->  ${Y}fuzz backup files only${N} \n"
OUT="$REPORT_DIR/backup_files_only.json"
WORDLIST=$WORDLISTS_DIR/backup_files_only.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_backup_paths(){
echo -e "\n ->  ${Y}fuzz backup files with paths${N} \n"
OUT="$REPORT_DIR/backup_files_with_path.json"
WORDLIST=$WORDLISTS_DIR/backup_files_with_path.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_cgibin(){
echo -e "\n ->  ${Y}fuzz cgi-bin${N} \n"
OUT="$REPORT_DIR/cgi-bin.json"
WORDLIST=$WORDLISTS_DIR/cgi-bin.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_cgi_files(){
echo -e "\n ->  ${Y}fuzz cgi-bin files${N} \n"
OUT="$REPORT_DIR/cgi-files.json"
WORDLIST=$WORDLISTS_DIR/cgi-files.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_git_config(){
echo -e "\n ->  ${Y}fuzz git${N} \n"
OUT="$REPORT_DIR/git_config.json"
WORDLIST=$WORDLISTS_DIR/git_config.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_log4j(){
echo -e "\n ->  ${Y}fuzz log4j${N} \n"
OUT="$REPORT_DIR/log4j.json"
WORDLIST=$WORDLISTS_DIR/log4j_payloads.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_jwt(){
echo -e "\n ->  ${Y}fuzz jwt${N} \n"
OUT="$REPORT_DIR/jwt.json"
WORDLIST=$WORDLISTS_DIR/jwt-secrets.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_cve(){
echo -e "\n ->  ${Y}fuzz cve paths${N} \n"
OUT="$REPORT_DIR/cve.json"
WORDLIST=$WORDLISTS_DIR/cve-paths.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_ec2(){
echo -e "\n ->  ${Y}fuzz ec2${N} \n"
OUT="$REPORT_DIR/ec2.json"
WORDLIST=$WORDLISTS_DIR/ec2.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_admin(){
echo -e "\n ->  ${Y}fuzz admin areas${N} \n"
OUT="$REPORT_DIR/admin.json"
WORDLIST=$WORDLISTS_DIR/admin.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_k8s(){
echo -e "\n ->  ${Y}fuzz k8s${N} \n"
OUT="$REPORT_DIR/k8s.json"
WORDLIST=$WORDLISTS_DIR/k8s.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}


fuzz_properties(){
echo -e "\n ->  ${Y}fuzz properties${N} \n"
OUT="$REPORT_DIR/properties-files.json"
WORDLIST=$WORDLISTS_DIR/k8s.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_php_files(){
echo -e "\n ->  ${Y}fuzz php files${N} \n"
OUT="$REPORT_DIR/php_files.json"
WORDLIST=$WORDLISTS_DIR/php_files_only.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_php_paths(){
echo -e "\n ->  ${Y}fuzz php files with paths${N} \n"
OUT="$REPORT_DIR/php_paths.json"
WORDLIST=$WORDLISTS_DIR/php_files_with_path.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_phpmyadmin(){
echo -e "\n ->  ${Y}fuzz phpmyadmin${N} \n"
OUT="$REPORT_DIR/phpmyadmin.json"
WORDLIST=$WORDLISTS_DIR/phpmyadmin.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_phpunit(){
echo -e "\n ->  ${Y}fuzz phpunit${N} \n"
OUT="$REPORT_DIR/phpunit.json"
WORDLIST=$WORDLISTS_DIR/phpunit.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401,403
}

fuzz_asp_files(){
echo -e "\n ->  ${Y}fuzz asp files${N} \n"
OUT="$REPORT_DIR/asp_files.json"
WORDLIST=$WORDLISTS_DIR/asp_files_only.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401,403
}

fuzz_asp_files_path(){
echo -e "\n ->  ${Y}fuzz asp files with paths${N} \n"
OUT="$REPORT_DIR/asp_files_path.json"
WORDLIST=$WORDLISTS_DIR/asp_files_with_path.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401,403
}

fuzz_dotfiles(){
echo -e "\n ->  ${Y}fuzz asp dotfiles${N} \n"
OUT="$REPORT_DIR/dotfiles.json"
WORDLIST=$WORDLISTS_DIR/dotfiles.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_juicy(){
echo -e "\n ->  ${Y}fuzz juicy paths${N} \n"
OUT="$REPORT_DIR/juicy.json"
WORDLIST=$WORDLISTS_DIR/juicy-paths.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_miss_config(){
echo -e "\n ->  ${Y}fuzz miss config${N} \n"
OUT="$REPORT_DIR/misconfigs.json"
WORDLIST=$WORDLISTS_DIR/leaky-misconfigs.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_adminer(){
echo -e "\n ->  ${Y}fuzz adminer${N} \n"
OUT="$REPORT_DIR/adminer.json"
WORDLIST=$WORDLISTS_DIR/adminer.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_keys(){
echo -e "\n ->  ${Y}fuzz keys${N} \n"
OUT="$REPORT_DIR/keys.json"
WORDLIST=$WORDLISTS_DIR/keys.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_perl(){
echo -e "\n ->  ${Y}fuzz perl files${N} \n"
OUT="$REPORT_DIR/perl.json"
WORDLIST=$WORDLISTS_DIR/perl-files.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_tomcat(){
echo -e "\n ->  ${Y}fuzz tomcat${N} \n"
OUT="$REPORT_DIR/tomcat.json"
WORDLIST=$WORDLISTS_DIR/tomcat.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299,401
}

fuzz_jsp(){
echo -e "\n ->  ${Y}fuzz jsp files${N} \n"
OUT="$REPORT_DIR/jsp.json"
WORDLIST=$WORDLISTS_DIR/jsp_files_only.txt
ffuf -w "$WORDLIST" -t "$THREADS" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_api(){
echo -e "\n ->  ${Y}fuzz api${N} \n"
OUT="$REPORT_DIR/api.json"
WORDLIST=$WORDLISTS_DIR/api.txt
ffuf -w "$WORDLIST" -t "$THREADS_SMALL" -u "$URL/FUZZ" -o "$OUT" --ac  -or -s -mc 200-299
}

fuzz_dir_rec_small
fuzz_dir_rec_full

fuzz_env
fuzz_config
fuzz_htaccess
fuzz_logs
fuzz_nginx
fuzz_npmrc
fuzz_yaml
fuzz_backup_files
fuzz_backup_paths
fuzz_cgibin
fuzz_cgi_files
fuzz_git_config
fuzz_log4j
fuzz_jwt
fuzz_cve
fuzz_ec2
fuzz_admin
fuzz_k8s
fuzz_properties
fuzz_php_files
fuzz_php_paths
fuzz_phpmyadmin
fuzz_phpunit
fuzz_asp_files
fuzz_asp_files_path
fuzz_dotfiles
fuzz_juicy
fuzz_miss_config
fuzz_adminer
fuzz_keys
fuzz_perl
fuzz_tomcat
fuzz_jsp
fuzz_api

echo -e "\n ->  ${Y}FINISH${N}  see results in $REPORT_DIR \n"