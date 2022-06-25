#!/usr/bin/python3
import getopt, sys
import time
import os
import requests
import configparser
from pathlib import Path

def update_duckdns(section):
    domain = config[section]['domain']
    token = config[section]['token']

    url = "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip="
    domain_status = requests.get(url)
    with open( home + "/.duckpy.log", "a" ) as logfile:
        logfile.write( hostname + ": " + time.strftime("%Y-%m-%d %H:%M:%S%z ") + domain + " is: " + domain_status.text + "\n" )

# begin...
home = os.environ["HOME"]
hostname = os.uname()[1]

# get all arguments except first (that is command itself)...
argument_list = sys.argv[1:]
# define short and long options...
short_options = "c:"
long_options = [ "config=" ]

# get options...
try:
    arguments, values = getopt.getopt(argument_list, short_options, long_options)
except getopt.error as err:
    print(str(err))
    sys.exit(2)

for current_argument, current_value in arguments:
    if current_argument in ("-c", "--config"):
        config_file = current_value

# define config_file variable...
if 'config_file' in globals():
    my_file = Path(config_file)
    if not my_file.is_file():
        print("config file doesn't exists: " + config_file)
        sys.exit(2)
else:
    config_file = home + "/.duckdns.ini"

# parse .ini config file
config = configparser.ConfigParser()
config.read(config_file)

for section in config:
    update_duckdns(section)
