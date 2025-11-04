#!/usr/bin/env bash

usage_list() {
    echo "Usage: ${0} [-r failureReason]"
    echo " -r: Filtering reason [optional]"
    echo " -h: help"
    exit 1    
}

while getopts r:h flag
do
  case "${flag}" in
    r) FAILURE_REASON_LIST_ARG=${OPTARG}  ;;
    h) usage_list ;;
    *) usage_list ;;
  esac
done

FAILURE_CONDITION=""

if [[ -n "${FAILURE_REASON_LIST_ARG}" ]]; then
   # his variable will layer be used inside a jq command
   # From a list of JSON objects, select only those where the field .failure_reason contains a certain string.
   FAILURE_CONDITION="| select(.failure_reason | contains(\"${FAILURE_REASON_LIST_ARG}\"))"
fi


# SA TOKEN
TOKEN=$(aws secretmanager get-secret-value --secret-id 1020-${ENV}-reposting-tools-token | jq -r '.SecretString' | jq -r '.token1')
PAGE_SIZE=10
URL="https://****-${ENV}-****.eu-west-2.com/v1/posting-failure?page_size=${PAGE_SIZE}"

# date prints the current date and time and -u forces the format that comes after it
DATE=$(date -u +%Y%m%d_%H%M%S)
# mktemp creates a temporary file with a unique name in a safe manner.
# --suffix=.json  This ensures that the generated temporary file has a .json extension
TMP_PAGE=$(mktemp /tmp/tmp.${DATE}-*** --suffix=.json)
TMP_FAILURES=$(mktemp /tmp/tmp.failures.${DATE}-*** --suffix=.json)
RESULT_FAILURES=$(mktemp /tmp/failures.${DATE}-*** --suffix=.json)
PARAMS=""

echo "TMP_PAGE file: ${TMP_PAGE}"
echo T"MP_FAILURES file: ${TMP_FAILURES}"
echo "RESULT_FAILURES file: ${RESULT_FAILURES}"
echo Pages processing start

# while : ;  => infinite loop
while : ; do
 let i++
 echo "Page ${i} ${NEXT_PAGE}"
 # -H 'Content-Type: Application/Json'  Specifies that the request expects JSON responses
 # -H "X-Auth-Token: $TOKEN" (Authorization Header) , Sets a custom HTTP header with the given token
 curl -s -k "${URL}${PARAMS}" -X GET -H "X-Auth-Token: ${TOKEN}" -H 'Content-Type: Application/Json' > "${TMP_PAGE}"
 NEXT_PAGE=$(jq -r '.next_page_token' "${TMP_PAGE}")
 PARAMS="&page_token=${NEXT_PAGE}"
 jq -r ".post_failures" "${TMP_PAGE}" >> ${TMP_FAILURES}
 # if NEXT_PAGE is empty at this point, exit the loop
 [[ -n ${NEXT_PAGE} ]] || break
done

# jq -s  slurp mode, Reads multiple JSON objects from a file into an array, 'add': Adds (merges) all elements of the array into a single JSON object if possible
# jq length, The pipe (|) sends the output from the first jq command into another jq command, If the output is an array, length returns the number of elements in the array
echo "Pages processing end with records count: $(jq -s 'add' ${TMP_FAILURES} | jq length)"

echo "SUMMARY START ----"

# jq ". |= sort_by(.insertion_timestamp) | reverse"  => sort_by(.insertion_timestamp) Sorts the array by insertion_timestamp in ascending order.
                                                        # reverse Reverses the array so that it is now sorted in descending order (latest timestamps first)
# jq ".[] ${FAILURE_CONDITION}"  => .[]  Unpacks the array so each JSON object is processed individually,
                                    # ${FAILURE_CONDITION}  This is a predefined filter condition stored in a variable                                                       
jq -s 'add' ${TMP_FAILURES} | jq ". |= sort_by(.insertion_timestamp) | reverse" | jq ".[] ${FAILURE_CONDITION}" > ${RESULT_FAILURES}

export EXPORTED_RESULT_FAILURES=${RESULT_FAILURES}
cat "${EXPORTED_RESULT_FAILURES}"
echo "SUMMARY END  ----"
