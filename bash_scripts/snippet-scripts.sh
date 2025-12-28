#!/bin/env bash

# we run the python file from inside bash script and save what it returns inside an environment variable
export VAULT_TOKEN=$(python ic-bank-platform/utils/get_token.py)

cd contracts

# clu - The main command/program being executed,  a command to import configuration or resources
# import - A subcommand telling clu to import something
# manifest.yaml - The file being imported (contains configurations, or resources)
# --config=clu_config.yaml - Points to a configuration file that tells clu how to behave during the import
# Supplies an authentication token (stored in the environment variable VAULT_TOKEN )
clu import manifest.yaml --config=clu_conflig.yaml --auth-token=$VAULT_TOKEN

# ========================================================================

#!/bin/bash

# Start a background process (sleep)
sleep 60 &

# Capture the PID of the background process
pid="$!"

# Wait for the background process to finish
wait "${pid}"

# After the process finishes
echo "the background process with PID "${pid}" has finished."

# =========================================================================

#!/usr/bin/env bash

# run another shell script from within this one
./install_contract.sh

# nohup : Ensures the process keeps running even if the terminal session is closed, Redirects output to nohup.out (unless explicitly redirected)
# Runs Locust, a Python-based load testing tool , -f specifies the Locust script (locustfile.py) to execute
# --config locust-master.conf  =>  Uses a custom configuration file (locust-master.conf)
# --web-host=0.0.0.0 => Starts the Locust web interface on all available network interfaces (0.0.0.0)
# > /tmp/outputlocust.log 2>&1  :  Redirects both standard output (stdout) and error (stderr) to /tmp/outputlocust.log , Ensures all logs are captured in the file
# &  :  Runs the process in the background, freeing the terminal
nohup locust -f ic-bank-platform/locust_files/locustfile.py --config icplatform/locust_files/locust-master.conf --web-host=0.0.0.0 > /tmp/outputlocust.log 2>&1 & 

python ic-bank-platform/main.py

# trap → Captures signals and executes a command when they occur
# 'kill "${pid}"' → Runs kill on the process stored in the variable ${pid}
# INT TERM → Specifies the signals to listen for : INT (Interrupt, e.g., pressing Ctrl+C) , TERM (Terminate, e.g., when stopping a process with kill or system shutdown)
# Set up a trap to kill the process on INT or TERM signal
trap 'kill "${pid}"' INT TERM

# This command is used to start a background process that sleeps indefinitely
sleep infinity &

# $! is a special variable in Bash that holds the PID of the last background process that was started with &
pid="$!"

# The wait command in Bash is used to pause the script until a specified process (identified by its PID) finishes executing
wait "${pid}"

# =========================================================================

#!/bin/bash

# create a loop in shell that writes a number in order of 1,2,3,4,.... every second until number 100

for i in $(seq 1 100); do
    echo ${i}
    sleep 1
done

# ==================================================================

#!/bin/bash

# curl Delete

for id in ${failed_ids}; do
    echo ${id}
    curl -k "${REPOSTING_URL}/${id}" -X DELETE -H "X-Auth-Token: ${REPOSTING_TOKEN}"
    # a 5-second pause (sleep 5) is added between requests to avoid overwhelming the server.
    sleep 5
done

# ==================================================================

#!/bin/bash

# Convert the lists to arrays
failed_id_array=(${failed_ids})
account_ids_array=(${account_ids})

# Use process substitution and comm to filter IDs
filtered_ids=$( comm -23 )

# ==================================================================
