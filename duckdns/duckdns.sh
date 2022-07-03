#!/bin/bash

logfile="$HOME/.duckdns.log"
default_config_file="$HOME/.duckdns.ini"

config_file="${1:-$default_config_file}"
[[ -f $config_file ]] || { echo "ERR: Config file doesn't exist: $config_file" >&2 ; exit 1 ; }

mapfile -t sections < <(crudini --get "$config_file")

for section in "${sections[@]}" ; do
	domain="$(crudini --get "$config_file" "$section" domain)"
	token="$(crudini --get "$config_file" "$section" token)"
	echo -n "$(hostname): $(date "+%Y-%m-%d %H:%M:%S"): ${domain} is " >> "$logfile"
 	echo url="https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=" | curl -s -k -K - >> "$logfile"
 	echo "" >> "$logfile"
done
