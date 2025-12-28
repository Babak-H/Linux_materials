#!/bin/sh 

RL="https://core-api.d-${DYN_ENV}-vt.${DYN_ENV_TYPE}.eu-west-2.aws.mycorps.net/v1/posting-failures"
REPOSTING_TOKEN=$(aws secretmanager get-secret-value --secret-id 105-${DYN_ENV}-sa-reposting-tools-token | jq -r '.SecretString' | jq -r ".token1")

usage_reposting() {
    echo "Usage: $0 [-f failuresFile] [-r failureReason]"
    echo " -f: Failures file to reposting [optional]"
    echo " -r: Filtering reason [optional]"
    echo " -h: help"
    exit 1
}

while getopts r:f:h flag
do
    case "${flag}" in
        f) FAILURES_FILE_REPOSTING_ARG=${OPTARG} ;;
        r) FAILURES_REASON_REPOSTING_ARG=${OPTARG} ;;
        h) usage_reposting ;; # Show the help
        *) usage_reposting ;;
    esac
done

# get list of all failed post-postings that need to be re-posted
# This checks the file address (the path stored in the variable) exists
if [[ -e "${FAILURES_FILE_REPOSTING_ARG}" ]]; then
    # checks if the variable is Not empty
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