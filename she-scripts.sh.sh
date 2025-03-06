#!/bin/bash

# Directory to read files from
DIRECTORY="/Users/babak/platform-terraform-module-ebs-csi-driver"
# Output file
OUTPUT_FILE="ebs-csi-driver.txt"
# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Function to read files recursively
read_files() {
    local dir="$1"
    for file in "$dir"/*; do
        # If it's a directory, call the function recursively
        if [ -d "$file" ]; then
            read_files "$file"
        # If it's a file, append its contents to the output file
        elif [ -f "$file" ]; then
            cat "$file" >> "$OUTPUT_FILE"
            # Add four empty lines
            echo -e "\n\n\n\n" >> "$OUTPUT_FILE"
        fi
    done
}

# Start reading files from the specified directory
read_files "$DIRECTORY"
echo "All files have been added to $OUTPUT_FILE with four empty lines between each."


# ==================================================================================

# Cockroach DB backup for Hashicorp Vault

# restore the whole database:
RESTORE DATABASE database FROM LATEST IN 's3://1052-pcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2' WITH "+"kms='aws:///arn:aws:kms:eu-west-2:123412342:alias/1052-pcore-cockroach-cmk?AUTH=implicit&REGION=eu-west-2';

# save it as s3 bucket:
kubectl -n 1052-cockroach-eu-west-2 exec -it cockroach-0 -- bash
cd cockroach/data

ZIP_START_DATE=$(date -d '1 hour ago' "+%Y-%m-%d %H:%M:%S")
ZIP_START_DATE=$(date -d '1 hour ago' "2024-5-7 4:33:0")

TSDUMP_START_DATE=$(date -d '24 hour ago' "+%Y-%m-%d %H:%M:%S")
TSDUMP_START_DATE=$(date -d '24 hour ago' "2024-5-6 5:33:0")

END_DATE=$(date "2024-5-7 6:33:0")
FILE_NAME=$(date "2024-5-7 5:33:0")

cockroach debug zip debug-${FILE_NAME}.zip --certs-dir=../cockroach-certs-copy --files-from "${ZIP_START_DATE}" --files-until "${END_DATE}"
cockroach debug tsdump --cert-dir==../cockroach-certs-copy --format=raw --from "${TSDUMP_START_DATE}" --to "${END_DATE}" | gzip > tsdump-${FILE_NAME}.gob.gz

BUCKET_NAME="1052-pcore-ddb-backup"

aws s3 cp tsdump-${FILE_NAME}.gob.gz s3://${BUCKET_NAME}/tsdump-${FILE_NAME}.gob.gz
aws s3 cp debug-${FILE_NAME}.zip s3://${BUCKET_NAME}/debug-${FILE_NAME}.zip

aws s3 ls --human-readable s3://${BUCKET_NAME}/debug-${FILE_NAME}.zip
aws s3 ls --human-readable s3://${BUCKET_NAME}/tsdump-${FILE_NAME}.gob.gz

rm debug-${FILE_NAME}.zip
rm debug-${FILE_NAME}.zip

# go into the pod running the cockroach db:
kubectl exec -it cockroach-client-0 -n  105250-cockroach-sql-client -- ./cockroach sql --certs-dir=cockroach-certs-copy --user=cockroach_client --url=postgresql://cockroach-public

# restore a table:
RESTORE TABLE vault.vault_kv_store FROM LATEST IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2' with kms = 'aws:///arn:aws:kms:eu-west-2:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-west-2';

# restore a database:
RESTORE DATABASE vault FROM LATEST IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2' with kms = 'aws:///arn:aws:kms:eu-west-2:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-west-2';

# in case of restoring existing database:
RESTORE DATABASE vault FROM LATEST IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2' with new_db_name='vault_restore', kms = 'aws:///arn:aws:kms:eu-west-2:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-west-2';

# restore specific point in time DB:
SHOW BACKUPS in 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2'
RESTORE DATABASE vault FROM '/2024/05/13-023000.00' IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-west-2' with new_db_name='vault_restore_test', kms = 'aws:///arn:aws:kms:eu-west-2:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-west-2';

# compare records from the two cockroach databases:
use vault;
select * from vault_kv_store where path='auth/dfgdf6567cvh/role/vault-operator-role';
use vault_restore;
select * from vault_kv_store where path='auth/dfgdf6567cvh/role/vault-operator-role';

# ========================================================================================

#! /usr/bin/env bash

function usage_list() {
    echo "Usage: $0 [-r failureReason]"
    echo " -r: Filtering reason [optional]"
    echo " -h: help"
    exit 1    
}

while getopts r:f:h flag
do 
    case "${flag}" in
        r) FAILURE_REASON_LIST_ARG=${OPTARG};;
        h) usage_list;;
    esac
done

FAILURE_CONDITION=""

if [[ -n "${FAILURE_REASON_LIST_ARG}"]]; then
    # Uses select(...) to filter JSON objects where .failure_reason contains a specific substring
    # contains(...): Checks if .failure_reason contains the value of ${FAILURE_REASON_LIST_ARG}
    FAILURE_CONDITION="| select(.failure_reason | contains(\"${FAILURE_REASON_LIST_ARG}\"))"
fi

# SA TOKEN
                                                                                              # jq -r '.SecretString' extracts the SecretString value, which is itself a JSON-encoded
                                                                                                                      # Since SecretString is still JSON, we use another jq command to extract the specific field token1
TOKEN=$(aws secretmanager get-secret-value --secret-id 1052-${DYN_ENV}-reposting-tools-token | jq -r '.SecretString' | jq -r '.token1')
PAGE_SIZE=10
URL="https://****-${DYN_ENV}-****.eu-west-2.com/v1/posting-failure?page_size=${PAGE_SIZE}"

# date prints the current date and time and -u forces the format that comes after it
DATE=$(date -u +%Y%m%d_%H%M%S)
# mktemp creates a temporary file with a unique name in a safe manner.
# --suffix=.json  This ensures that the generated temporary file has a .json extension
TMP_PAGE=$(mktemp /tmp/tmp.${DATE}-*** --suffix=.json)
TMP_FAILURES=$(mktemp /tmp/tmp.failures.${DATE}-*** --suffix=.json)
RESULT_FAILURES=$(mktemp /tmp/failures.${DATE}-*** --suffix=.json)
PARAMS=""

echo TMP_PAGE file: ${TMP_PAGE}
echo TMP_FAILURES file: ${TMP_FAILURES}
echo RESULT_FAILURES file: ${RESULT_FAILURES}
echo Pages processing start
while : ; do
    let i++
    echo Page: ${i} $NEXT_PAGE
    # This flag suppresses progress and error messages.
    # -k (Insecure Mode), Ignores SSL/TLS certificate verification, Used when connecting to a server with self-signed or untrusted certificates
    # "$URL$PARAMS"  full address to connect to
    # -X GET (HTTP Method) Specifies the GET request method
    # -H "X-Auth-Token: $TOKEN" (Authorization Header) , Sets a custom HTTP header with the given token
    # -H 'Content-Type: Application/Json'  Specifies that the request expects JSON responses
    curl -s -k "$URL$PARAMS" -X GET -H "X-Auth-Token: $TOKEN" -H 'Content-Type: Application/Json' > ${TMP_PAGE}
    NEXT_PAGE=$(jq -r '.next_page_token' "${TMP_PAGE}")
    PARAMS="&page_token=$NEXT_PAGE"
    jq -r ".post_failures" "${TMP_PAGE}" >> ${TMP_FAILURES}
    [[ -n "$NEXT_PAGE" ]] || break
done

# jq -s  slurp mode, Reads multiple JSON objects from a file into an array, 'add': Adds (merges) all elements of the array into a single JSON object if possible
# jq length, The pipe (|) sends the output from the first jq command into another jq command, If the output is an array, length returns the number of elements in the array
echo Pages processing end with records count: $(jq -s 'add' ${TMP_FAILURES} | jq length)

echo "SUMMARY START ----"
# jq ". |= sort_by(.insertion_timestamp) | reverse"  => sort_by(.insertion_timestamp) Sorts the array by insertion_timestamp in ascending order.
                                                        # reverse Reverses the array so that it is now sorted in descending order (latest timestamps first)
# jq ".[] ${FAILURE_CONDITION}"  => .[]  Unpacks the array so each JSON object is processed individually,
                                    # ${FAILURE_CONDITION}  This is a predefined filter condition stored in a variable
jq -s 'add' ${TMP_FAILURES} | jq ". |= sort_by(.insertion_timestamp) | reverse" | jq ".[] ${FAILURE_CONDITION}" > ${RESULT_FAILURES}
export EXPORTED_RESULT_FAILURES=${RESULT_FAILURES}
cat ${EXPORTED_RESULT_FAILURES}
echo "SUMMARY END  ----"

# ===================================================================================

#!/bin/bash

# Function to scale deployments
function scale_deployments() {
    # local  Declares a local variable within a function.
    local namespace=$1  # Assigns the first argument ($1) passed to the function to the namespace variable.
    local scale_to=$2   # Assigns the second argument ($2) passed to the function to the scale_to variable.

    # {range .items[*]} → Loops through all deployments
    # {.metadata.name} → Extracts only the deployment name
    # {"\n"} → Adds a newline for readability
    # egrep -v → Excludes any lines matching "vault-tools" or "istio-annotation-tm-webhook"
    kubectl scale deployment --namespace=$namespace --replicas=$scale_to $(kubectl get deployments --namespace=$namespace -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | egrep -v "vault-tools|istio-annotation-tm-webhook")
}

function scale_jobs() {
    local namespace=$1
    local scale_to=$2
    kubectl scale job --namespace=$namespace --replicas=$scale_to $(kubectl get job --namespace=$namespace -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
}

function scale_statefulsets() {
    local namespace=$1
    local scale_to=$2
    kubectl scale statefulset --namespace=$namespace --replicas=$scale_to $(kubectl get statefulset --namespace=$namespace -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
}


# getopts is used for parsing command-line options. The ":" at the start means that missing arguments will trigger the :) error case. "n:s:" defines the accepted options
# n: → -n requires a value (e.g., -n production)
# s: → -s requires a value (e.g., -s 5)
# assign the value to "opt"
while getopts ":n:s:" opt; do
    case $opt in
        n) namespace=$OPTARG ;;  # Assigns the value passed with -n to the namespace variable
        s) scale_to=$OPTARG ;;   # Assigns the value passed with -s to the scale_to variable
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

# -z $namespace → Checks if namespace is empty or unset
# -z $scale_to → Checks if scale_to is empty or unset
if [[ -z $namespace || -z $scale_to ]]; then
    echo "Usage: $0 -n <namespace> -s <scale>"
    exit 1
fi

# Scale deployments, jobs, and statefulsets
echo "Running autoscaler for $namespace - setting replicas to: $scale_to"
scale_deployments $namespace $scale_to

# =================================================================================

# !/bin/sh

# $# stores the number of arguments passed to the script
# If the user provides anything other than 2 arguments, the script will exit. | ne : Not Equal
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <namespace> <label>"
  exit 1
fi

LABEL="$1"
# cut is used to extract sections of text, -d ':' → Specifies the delimiter as a colon (:) , -f 1 → Extracts the first field (before the first :)
LABEL_KEY=$(echo $LABEL | cut -d ':' -f 1)
# -f 2 selects the second field (after the first :)
# sed (stream editor) is used for text manipulation , s/^ // → Substitutes (s) a leading space (^ ) with nothing ('')
LABEL_VALUE=$(echo "$LABEL" | cut -d ':' -f 2 | sed 's/^ //')


label_resources() {
  # due to restriction for some of the statefulsets that are controlled by operator, we have to first patch the CRDs that control them
  RESOURCES=$(kubectl get prometheuses.monitoring.coreos.com -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')
  for RESOURCE in $RESOURCES; do
    echo $LABEL_KEY
    # CRDs can't be patched via strategic-merge-patch+json, we have to patch them via merge-patch+json format
    kubectl patch prometheuses.monitoring.coreos.com $RESOURCE --type merge --patch '{"spec":{"podMetadata":{"labels":{"'$LABEL_KEY'":"'$LABEL_VALUE'"}}}}' -n $NAMESPACE
  done

  RESOURCE_TYPE=$1
  NAMESPACE=$2
  RESOURCES=$(kubectl get $RESOURCE_TYPE -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

  for RESOURCE in $RESOURCES; do
    echo "Adding label $LABEL_KEY to $RESOURCE_TYPE $RESOURCE"
    kubectl label $RESOURCE_TYPE $RESOURCE $LABEL_KEY=$LABEL_VALUE -n $NAMESPACE --overwrite
    if [ "$RESOURCE_TYPE" == "deployment" ] || [ "$RESOURCE_TYPE" == "statefulset" ] || [ "$RESOURCE_TYPE" == "daemonset" ]; then
      kubectl patch $RESOURCE_TYPE $RESOURCE --patch '{"spec":{"template":{"metadata":{"labels":{"'$LABEL_KEY'":"'$LABEL_VALUE'"}}}}}' -n $NAMESPACE
    else
      kubectl patch $RESOURCE_TYPE $RESOURCE --patch '{"spec":{"jobTemplate":{"spec":{"template":{"metadata":{"labels":{"'$LABEL_KEY'":"'$LABEL_VALUE'"}}}}}}}' -n $NAMESPACE
    fi
  done
}

# jobs are NOT added here as they are ephemeral resources and will finish after running
RESOURCE_TYPES=("daemonset" "deployment" "statefulset" "cronjob")
NAMESPACES=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}')

for NAMESPACE in $NAMESPACES; do
  # @ symbol in "${RESOURCE_TYPES[@]}" is used to expand the array RESOURCE_TYPES into its individual elements while preserving word splitting
  # if we have "disk space" as element, it will stay one item in the array
  for RESOURCE_TYPE in "${RESOURCE_TYPES[@]}"; do
    label_resources $RESOURCE_TYPE $NAMESPACE
  done
done
echo "Labeling finished"

# ==================================================================================

#!/usr/bin/env bash

# The set -e command makes the script exit immediately if any command fails (returns a non-zero exit status)
set -e
releaseJsonPath=$1
targetPath=$2

function buildAclsForResourceType() {

  kafka_requirement=$1
  resourceType=$2  # topic or group
  principal=$3
  baseACLCreationCommand="kafka-acls --bootstrap-server \$BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties"

  if [[ $resourceType == "topic" ]]; then
    # Parses the JSON and extracts the resources.topics field
    # jq -c '.[]'  : jq -c '.[]' , '.[]' iterates over each element in the topics array
    resources_configurations=$(echo $kafka_requirement | jq '.resources.topics' | jq -c '.[]');
  elif [[ $resourceType == "group" ]]; then
    resources_configurations=$(echo $kafka_requirement | jq '.resources.groups' | jq -c '.[]');
  fi;

#{
#  "resources": {
#    "topics": [
#      {"name":"topic1","partitions":3},
#      {"name":"topic2","partitions":5}
#    ]
#  }
#}

  for resource_configuration in $resources_configurations; do
    # The -e flag in the echo command enables interpretation of escape sequences, allowing special characters like \n (newline), \t (tab), and \e (ANSI escape codes) to be processed.
    echo -e "\nConstructing $resourceType related ACLs"
                                                                             # The command tr -d '"' is used to delete all double quotes (") from input.
    permission_type=$(echo $resource_configuration | jq '.permission_type' | tr -d '"');
                                                                          # The command tr "[:upper:]" "[:lower:]" converts uppercase letters to lowercase.
    permission_type_attribute=$(echo -e "--$permission_type-principal" | tr "[:upper:]" "[:lower:]")

    permissions_command=""
    permissions=$(echo $resource_configuration | jq '.permissions' | jq .[]);

    for permission in $permissions; do
                                              # The command tr -d "\"" removes all double quotes (") from the input
      permission_updated=$(echo $permission | tr -d "\"")
      permissions_command+="--operation $permission_updated "
    done

    if [ $(echo $resource_configuration | jq 'has("prefixes")') == "true" ]
    then
      prefixes=$(echo $resource_configuration | jq '.prefixes' | jq .[]);
      echo "Commands to be executed:"
      for prefix in $prefixes; do
        prefix_updated=$(echo $prefix | tr -d "\"")
                                                # The tee command is used to write output to both the terminal and a file simultaneously. The -a (append) flag ensures that the output is added to the file without overwriting existing content
        echo -e "$baseACLCreationCommand --add --resource-pattern-type prefixed --allow-host '*' $permission_type_attribute User:$principal --$resourceType \"$prefix_updated\" $permissions_command" | tee -a $targetPath/acl_commands_full.txt
        echo -e "$baseACLCreationCommand --add --resource-pattern-type prefixed --allow-host '*' $permission_type_attribute User:vault-operator --$resourceType \"$prefix_updated\" $permissions_command" | tee -a $targetPath/acl_commands_vault_operator.txt
      done
    elif [ $(echo $resource_configuration | jq 'has("name")')  == "true" ]
    then
      topics=$(echo $resource_configuration | jq '.name' | jq .[]);
      echo "Commands to be executed:"
      for topic in $topics; do
        topic_updated=$(echo $topic | tr -d "\"")
        echo -e "$baseACLCreationCommand --add --resource-pattern-type literal --allow-host '*' $permission_type_attribute User:$principal --$resourceType \"$topic_updated\" $permissions_command" | tee -a $targetPath/acl_commands_full.txt
        echo -e "$baseACLCreationCommand --add --resource-pattern-type literal --allow-host '*' $permission_type_attribute User:vault-operator --$resourceType \"$topic_updated\" $permissions_command" | tee -a $targetPath/acl_commands_vault_operator.txt
      done
    fi

  done
}

kafka_requirements_list=$(cat $releaseJsonPath | jq '.metadata.kafka_principals | to_entries | .[] | select(.value.components[] | contains("observability") or contains("istio") or contains("vault-core") or contains("webhook-operator"))' | jq -c .value);
echo "Commands to be executed when creating full set of ACLs:" > $targetPath/acl_commands_full.txt
echo "" > $targetPath/acl_commands_vault_operator.txt
for kafka_requirement_json in $kafka_requirements_list; do

  principal=$(echo $kafka_requirement_json | jq '.principal' | tr -d "\"");
  echo "Discovered principal : $principal";

  component=$(echo $kafka_requirement_json | jq '.components');
  echo "Discovered components : $component";

  buildAclsForResourceType $kafka_requirement_json "topic" $principal
  buildAclsForResourceType $kafka_requirement_json "group" $principal

  echo -e "\n---------------------------------------------------------------------\n"

done

# | sort -u  => sort: Sorts the lines in alphabetical order. , -u (unique): Removes duplicate lines.
cat $targetPath/acl_commands_vault_operator.txt | sort -u | tee $targetPath/acl_commands_vault_operator_without_duplicates.txt


# ============================================================================

#!/usr/bin/env bash

# we run the python file from inside bash script and save what it returns inside a variable
export VAULT_TOKEN=$(python ic-banking-platform/utils/get_token.py)
cd contract
# clu import : Likely a command to import configuration or resources.
# manifest.yaml → A YAML file containing definitions to be imported
# --auth-token=$VAULT_SERVICE_ACCOUNT_TOKEN : Supplies an authentication token (stored in the environment variable VAULT_TOKEN )
clu import manifest.yaml --config=clu_config.yaml --auth-token=$VAULT_TOKEN

# ================================================================================


#!/usr/bin/env bash

# run another shell script from within this one
./install_contract.sh

# Ensures the process keeps running even if the terminal session is closed, Redirects output to nohup.out (unless explicitly redirected)
# Runs Locust, a Python-based load testing tool , -f specifies the Locust script (locustfile.py) to execute
# --config locust-master.conf  =>  Uses a custom configuration file (locust-master.conf)
# --web-host=0.0.0.0 => Starts the Locust web interface on all available network interfaces (0.0.0.0)
# > /tmp/outputlocust.log 2>&1  :  Redirects both standard output (stdout) and error (stderr) to /tmp/outputlocust.log , Ensures all logs are captured in the file
# &  :  Runs the process in the background, freeing the terminal
nohup locust -f ic-banking-platform/locust_files/locustfile.py --config icplatform/locust_files/locust-master.conf --web-host=0.0.0.0 > /tmp/outputlocust.log 2>&1 &
python ic-banking-platform/main.py

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

# ========================================================================

#!/bin/bash

# Start a background process (e.g., sleep)
sleep 60 &
# Capture the PID of the background process
pid="$!"
# Wait for the background process to finish
wait "${pid}"
# After the process finishes
echo "The background process with PID $pid has finished."

# =========================================================================

# create a loop in shell that writes a number in order of 1,2,3,4,.... every second until number 100

#!/bin/bash
for i in $(seq 1 100); do
  echo $i
  sleep 1
done

# ========================================================================

# To automate the creation of a service account in a specific Kubernetes namespace using a shell script, you can use the kubectl command-line tool. Below is a simple shell script that accomplishes this task. 

#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <namespace> <service-account-name>"
  exit 1
fi

# Assign command-line arguments to variables
NAMESPACE=$1
SERVICE_ACCOUNT=$2

# Create the namespace if it doesn't exist
kubectl get namespace $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Namespace '$NAMESPACE' does not exist. Creating it..."
  kubectl create namespace $NAMESPACE
fi

# Create the service account in the specified namespace
kubectl create serviceaccount $SERVICE_ACCOUNT --namespace $NAMESPACE

# Verify the creation of the service account
if [ $? -eq 0]; then
   echo "Service account '$SERVICE_ACCOUNT_NAME' created successfully in namespace '$NAMESPACE'."
else
  echo "Failed to create service account '$SERVICE_ACCOUNT_NAME' in namespace '$NAMESPACE'."
  exit 1
fi

# what does this mean? if [ $? -ne 0 ]; then
# the construct if [ $? -ne 0 ]; then is used to check the exit status of the last executed command.

# $? : This is a special variable in shell scripting that holds the exit status of the last executed command. The exit status is a numeric value returned by a command to indicate whether it succeeded or failed. By convention, an exit status of 0 means success, while any non-zero value indicates an error or failure.
# -ne: This is a comparison operator in shell scripting that stands for "not equal." It is used to compare two numbers.
# 0: This is the number being compared against, which represents a successful exit status.

# ==================================================================

# curl Delete

for id in $failed_ids; do
  echo ${id}
  curl -k "${REPOSTING_URL}/${id}" -X DELETE -H "X-Auth-Token: ${REPOSTING_TOKEN}"
  # A 5-second pause (sleep 5) is added between requests to avoid overwhelming the server.
  sleep 5
done

# ===================================================================

# Convert the lists to arrays
failed_id_array=($failed_ids)
account_ids_array=($account_ids)

# Use process substitution and comm to filter IDs
filtered_ids=$(comm -23 )

# ===================================================================
# Reposting Script

#!/usr/bin/env bash

REPOSTING_URL="https://core-api.d-${DYN_ENV}-vt.${DYN_ENV_TYPE}.eu-west-2.aws.mycorps.net/v1/posting-failures"
REPOSTING_TOKEN=$(aws secretsmanager get-secret-value --secret-id 1052-${DYN_ENV}-sa-reposting-tools-token | jq -r '.SecretString' | jq -r ".token1")

# the help fuction
function usage_reposting() {
  echo "Usage: $0 [-f failuresFile] [-r failureReason]"
  echo " -f: Failures file to reposting [optional]"
  echo " -r: Filtering reason [optional]"
  echo " -h: help"
  exit 1
}

while getopts r:f:h flag
do
  case "${flag}" in
    f) FAILURES_FILE_REPOSTING_ARG=${OPTARG};;
    r) FAILURES_REASON_REPOSTING_ARG=${OPTARG};;
    h) usage_reposting;; # Show the help
  esac
done

# get list of all failed post-postings that need to be re-posted
if [[ -e "${FAILURES_FILE_REPOSTING_ARG}" ]]; then
  if [[ -n "${FAILURES_REASON_REPOSTING_ARG}" ]]; then
    FAILURE_CONDITION="| select(.failure_reason | contains(\"${FAILURES_REASON_REPOSTING_ARG}\"))"
  fi
  EXPORTED_RESULT_FAILURES=${FAILURES_FILE_REPOSTING_ARG}
else
  source $(dirname "$0")/vault_list_post_postings_failures.sh -r "${FAILURES_REASON_REPOSTING_ARG}"
fi

STATUS="| select(.status | contains(\"POST_POSTING_FAILURE_STATUS_FAILURE\"))"
account_ids=$(cat "$EXPORTED_RESULT_FAILURES" | jq -sr ".[] ${STATUS} | .account_id" | uniq)

for account_id in $account_ids; do
  curl -k "${REPOSTING_URL}:republish" -X POST -H "X-Auth-Token: ${REPOSTING_TOKEN}" -H "Content-Type: Application/Json" \
    --data-binary "{\"account_id\": \"${account_id}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_BLOCKED_FAILURES\"}"
  sleep 300
done

# ===================================================================

#!/bin/bash

set -e

# Help function
function usage() {
  echo "Usage $0 [-n namespace] [-r listOfResourcesToBackup] [-b]"
  echo "  -n namespace: The namespace you want to backup [optional] if not informed 105250-core-v"
  echo "  -r resources: The resources ou want to backup [optional] if not informed: jobs configmap services deployments statefulset horizontalpodautoscalers cronjob virtualservices ingresses crowns tmcomponents serviceaccounts"
  echo "  -b: Save the backup on S3 [optional]"
  echo "  -h: help"
  exit 1
}

# Variable to indicate if you want to save the backup to S3
BACKUP=true

while getopts r:n:h:b flag
do
  case "${flag}" in
    r) RESOURCES=${OPTARG};;  # The resource types
    n) NAMESPACE=${OPTARG};;  # The namespace
    b) BACKUP=false;;  # # Indicate that you want to backup the original file
    h) usage;; # Show the help
  esac
done

if [ -z "$RESOURCE" ]; then
  RESOURCE="jobs configmap services deployments statefulset horizontalpodautoscalers cronjob virtualservices ingresses crowns tmcomponents serviceaccounts"
fi

if [ -z "$NAMESPACE" ]; then
 NAMESPACE="105640"
fi

CURRENTDATE=$(date '+%Y-%m-%d')

echo "Starting Backup process for $NAMESPACE with following resources in scope: $RESOURCE"
for NS in $(kubectl get ns | egrep -i $NAMESPACE | awk '{print $1}')
do
  for TYPE in $RESOURCE
  do
    echo "Grabbing $NS $TYPE"
    mkdir -p $CURRENTDATE/$NS/$TYPE
    # awk '{print $1}' => Extracts the first column (which is typically the resource name
    for ENTITY in $(kubectl -n $NS get $TYPE | grep -v NAME | awk '{print $1}' )
    do
     kubectl -n $NS get $TYPE $ENTITY -o yaml > $CURRENTDATE/$NS/$TYPE/$ENTITY.yaml
    done
  done
done

COMMON="common"
echo ""
echo "START backup of COMMON Features in the Cluster : validatingwebhookconfigurations clusterrole clusterrolebinding namespaces mutatingwebhookconfiguration customresourcedefinitions priorityclasses"

for TYPE in validatingwebhookconfigurations clusterrole clusterrolebinding namespaces mutatingwebhookconfiguration customresourcedefinitions priorityclasses
do
  echo "Grabbing $COMMON $TYPE"
  mkdir -p $CURRENTDATE/$COMMON/$TYPE
  for ENTITY in $(kubectl get $TYPE | grep -v NAME | awk '{print $1}')
  do
    kubectl get $TYPE $ENTITY -o yaml > $CURRENTDATE/$COMMON/$TYPE/$ENTITY.yaml
  done
done

echo "Completed Backup process..."

if [ -z "$BACKUP_S3_BUCKET" ]; then
  backupBucket="s3://$(aws s3 ls | grep -i vault-backup | awk '{print $3}' )"
else
  backupBucket=$BACKUP_S3_BUCKET
fi

if [ "$BACKUP" == "true" ]; then
  echo "Saving Backup on S3 bucket $backupBucket ..."
  # --recursive => Ensures that all files and subdirectories within $CURRENTDATE are moved, recursively
  aws s3 mv $CURRENTDATE "$backupBucket/$CURRENTDATE" --recursive
  echo "Save completed"
fi

# ===================================================================

#!/bin/bash

# we need 3 arguments for the labeling process
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <namespace> <service-account-name> <role>"
    exit 1
fi

NAMESPACE=$1
SERVICE_ACCOUNT_NAME=$2
ROLE=$3

# >/dev/null 2>&1 is used for handling the command's output
# >/dev/null → Redirects standard output (stdout) to /dev/null, which is a special file that discards anything written to it. This means any normal output from kubectl get namespace is suppressed.
# 2>&1 → Redirects standard error (stderr) (2) to the same location as standard output (stdout) (1). Since stdout was redirected to /dev/null, this ensures that both stdout and stderr are discarded.
# This ensures that the command runs silently, without displaying any output or errors and only returns the error code
kubectl get namespace $NAMESPACE >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Namespace '$NAMESPACE' does not exist. please type correct namespace"
    exit 1
fi

kubectl label serviceaccount $SERVICE_ACCOUNT_NAME -n $NAMESPACE icb.mycorps.com/squad=ICB_lts app.kubernetes.io/name=cp-vt
kubectl annotate serviceaccount $SERVICE_ACCOUNT_NAME -n $NAMESPACE eks.amazonaws.com/role-arn=arn:aws:iam::87979954645:role/568790-345681ie-core-vt

CAN_I=$(kubectl auth can-i list deployments --as system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT_NAME)

if [ "$CAN_I" == "yes" ]; then
    echo "Service account '$SERVICE_ACCOUNT_NAME' created successfully in namespace '$NAMESPACE'."
else
    echo "Failed to create service account '$SERVICE_ACCOUNT_NAME' in namespace '$NAMESPACE'."
    exit 1
fi

# ===================================================================

#!/bin/bash

# *** Advanced Logging ***

set -euxo pipefail
# e: Exit immediately when a non-zero exit status is encountered
# u: Undefined variables throws an error and exits the script
# x: Print every evaluation.
# o pipefail: Here we make sure that any error in a pipe of commands will fail the entire pipe instead just carrying on to the next command in the pipe.


# This defines a function named log::info
function log::info {  
  # This calls another function named log::_write_log
  # "INFO" is passed as the first argument, indicating that this is an informational log message
  # "$@" represents all arguments passed to log::info and forwards them to log::_write_log
  # This function logs a message at the "INFO" level by calling log::_write_log with the "INFO" tag and the provided message
  log::_write_log "INFO" "$@"
}


# Defines a function named log::level_is_active
# check if a given log level is actually active which is controlled by the global variable LOG_LEVEL.
function log::level_is_active {
  # Declares two local variables (check_level and current_level) that are used only within this function.
  local check_level current_level
  # Assigns the first argument passed to the function to the check_level variable.
  check_level=$1
  # Declares an associative array (log_levels), mapping log levels to numeric values.
  declare -A log_levels=(
    [DEBUG]=1
    [INFO]=2
    [WARN]=3
    [ERROR]=4
  )
  # Converts the input log level (e.g., "INFO") into its corresponding numeric value using the log_levels array
  check_level="${log_levels["$check_level"]}"
  # Converts the current log level (stored in $LOG_LEVEL) into its corresponding numeric value.
  current_level="${log_levels["$LOG_LEVEL"]}"
  # arithmetic comparison in Bash
  # It checks if the requested check_level is greater than or equal to current_level
  # If true, it means the requested log level is active, and the function returns success (0 in Bash),If false, it returns failure (1 in Bash) 
  (( check_level >= current_level ))
}


# This defines a function called log::_write_log, he log::_write_log function is a helper function for logging messages
function log::_write_log {
  # Declares four local variables, timestamp → Will store the current date and time, file → Will store the name of the script file where the log function was called,
  # function_name → Will store the function name from which the log was called, log_level → Will store the log level (INFO, DEBUG, etc.)  
  local timestamp file function_name log_level
  # Assigns the first argument ($1) passed to the function to the variable log_level
  log_level=$1
  # The shift command removes the first argument ($1) from the list of arguments
  # After this, $2 becomes $1, $3 becomes $2, and so on
  # This means that any remaining arguments ($@) now contain the actual log message
  shift
  # If log::level_is_active returns true (i.e., the log level is active), the logging proceeds
  if log::level_is_active "$log_level"; then
    timestamp=$(date +'%y.%m.%d %H:%M:%S')  # 24.03.05 12:30:15
    # BASH_SOURCE is an array that stores the script file paths in the call stack
    # BASH_SOURCE[2] refers to the script two levels up in the call stack, ##*/ extracts only the file name (removing the full path)
    # If BASH_SOURCE[2] is /home/user/script.sh, then file="script.sh"
    file="${BASH_SOURCE[2]##*/}"
    # FUNCNAME is an array storing the function call stack, FUNCNAME[2] refers to the function two levels up in the call stack
    # This retrieves the function that originally triggered the logging
    # If FUNCNAME[2] is my_function, then function_name="my_function"
    function_name="${FUNCNAME[2]}"
    # >&2 → Redirects output to stderr (standard error)
    # printf formats and prints the log message in this structure
    # The placeholders (%s) are replaced by variables below them
    >&2 printf '%s [%s] [%s - %s]: %s\n' \
      "$log_level" "$timestamp" "$file" "$function_name" "${*}"
  fi
}

# test
function my_function {
  log::_write_log "INFO" "Something happened"
}
my_function
# INFO [24.03.05 12:30:15] [script.sh - my_function]: Something happened

# ===================================================================

