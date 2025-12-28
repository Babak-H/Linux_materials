#!/bin/bash

set -e

function usage() {
    echo "Usage ${0} [-n namespace] [-r listOfResourcesToBackup] [-b]"
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
    case
        r) RESOURCES=${OPTARG};; # The resource types
        n) NAMESPACE=${OPTARG};; # The namespace
        b) BACKUP=false;; # Indicate that you want to backup the original file
        h) usage;; # Show the help
    esac
done

if [ -z "${RESOURCE}" ]; then
    RESOURCE="jobs configmap services deployments statefulset horizontalpodautoscalers cronjob virtualservices ingresses crowns tmcomponents serviceaccounts"
fi

if [ -z "${NAMESPACE}" ]; then
    NAMESPACE="105640"
fi

CURRENTDATE=$(date '+%Y-%m-%d')

echo "Starting Backup process for ${NAMESPACE} with following resources in scope: ${RESOURCE}"
# egrep = grep -E
# Uses extended regular expressions (ERE), allowing more powerful pattern matching (e.g., |, +, ?, parentheses without escaping).  -i = case-insensitive search  , Matches patterns regardless of uppercase/lowercase letters
# awk '{print $1}' => Extracts the first column (which is typically the resource name)
for NS in $(kubectl get ns | egrep -i "${NAMESPACE}" | awk '{print $1}')
do
    # Since $RESOURCE contains a space-separated list, and you are expanding it as ${RESOURCE} (unquoted), the shell splits it into words automatically
    for TYPE in ${RESOURCE}
    do
        echo "Grabbing ${NS} ${TYPE}"
        mkdir -p "${CURRENTDATE}"/"${NS}"/"${TYPE}"
        # remove the first line (contains words such as NAME,...)
        for ENTITY in $(kubectl -n ${NS} get ${TYPE} | grep -v NAME | awk '{print $1}')
        do
            kubectl -n "${NS}" get "${$TYPE}" "${ENTITY}" -o yaml > ${CURRENTDATE}/${NS}/${TYPE}/${ENTITY}.yaml
        done
    done
done

# these resources are namespace-agnostic
COMMON="common"
echo ""
echo "START backup of COMMON Features in the Cluster : validatingwebhookconfigurations clusterrole clusterrolebinding namespaces mutatingwebhookconfiguration customresourcedefinitions priorityclasses"

for TYPE in validatingwebhookconfigurations clusterrole clusterrolebinding namespaces mutatingwebhookconfiguration customresourcedefinitions priorityclasses
do
  echo "Grabbing ${COMMON} ${TYPE}"
  mkdir -p ${CURRENTDATE}/${COMMON}/${TYPE}
  for ENTITY in $(kubectl get ${TYPE} | grep -v NAME | awk '{print $1}')
  do
    kubectl get ${TYPE} ${ENTITY} -o yaml > ${CURRENTDATE}/${COMMON}/${TYPE}/${ENTITY}.yaml
  done
done

echo "Completed Backup process..."

if [ -z "${BACKUP_S3_BUCKET}" ]; then
  backupBucket="s3://$(aws s3 ls | grep -i vault-backup | awk '{print $3}')"
else
  backupBucket=${BACKUP_S3_BUCKET}
fi

if [ "${BACKUP}" == "true" ]; then
  echo "Saving Backup on S3 bucket ${backupBucket} ..."
  # --recursive => Ensures that all files and subdirectories within $CURRENTDATE are moved, recursively
  aws s3 mv ${CURRENTDATE} "${backupBucket}/${CURRENTDATE}" --recursive
  echo "Save completed"
fi