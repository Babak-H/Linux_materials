#!/bin/sh

# $# stores the number of arguments passed to the script
# If the user provides anything other than 1 arguments, the script will exit. | ne : Not Equal
if ["$#" -ne 1 ]; then
    echo "Usage: ${0} <label>" >&2;
    exit 1
fi

LABEL="${1}"
if [[ -z "${LABEL}" ]]; then
    echo "Label argument is empty" >&2;
    exit 1
fi

# cut is used to extract sections of text, -d ':' → Specifies the delimiter as a colon (:) , -f 1 → Extracts the first field (before the first :)
LABEL_KEY=$(echo ${LABEL} | cut -d ':' -f 1)
# sed (stream editor) is used for text manipulation , s/^ // → Substitutes (s) a leading space (^ ) with nothing ('')
LABEL_VALUE=$(echo ${LABEL} | cut -d ':' -f 2 | sed 's/^ //')

function label_resources() {
    # due to restriction for some of the statefulsets that are controlled by operator, we have to first patch the CRDs that control them
    RESOURCES=$(kubectl get prometheuses.monitoring.coreos.com -n ${NAMESPACE} -o json | jq -r '.items[].metadata.name')

    for RESOURCE in ${RESOURCES}
    do
        echo $LABEL_KEY
        # CRDs can't be patched via strategic-merge-patch+json, we have to patch them via merge-patch+json format
        kubectl patch prometheuses.monitoring.coreos.com ${RESOURCE} -n ${NAMESPACE} --type merge --patch '{"spec":{"podMetadata":{"labels":{"'${LABEL_KEY}'":"'${LABEL_VALUE}'"}}}}'
    done

    RESOURCE_TYPE=$1
    NAMESPACE=$2
    RESOURCES=$(kubectl get ${RESOURCE_TYPE} -n ${NAMESPACE} -o json | jq -r '.items[].metadata.name')

    for RESOURCE in ${RESOURCES}
    do
        echo "Adding label ${LABEL_KEY} to ${RESOURCE_TYPE} ${RESOURCE}"
        kubectl label ${RESOURCE_TYPE} ${RESOURCE} ${LABEL_KEY}=${LABEL_VALUE} -n ${NAMESPACE} --overwrite

        if [ "${RESOURCE_TYPE}" == "deployment" ] || [ "${RESOURCE_TYPE}" == "statefulset" ] || [ "${RESOURCE_TYPE}" == "daemonset" ]; then
            kubectl patch ${RESOURCE_TYPE} ${RESOURCE} --patch '{"spec":{"template":{"metadata":{"labels":{"'${LABEL_KEY}'":"'${LABEL_VALUE}'"}}}}}' -n ${NAMESPACE}
        else
            kubectl patch ${RESOURCE_TYPE} ${RESOURCE} --patch '{"spec":{"jobTemplate":{"spec":{"template":{"metadata":{"labels":{"'${LABEL_KEY}'":"'${LABEL_VALUE}'"}}}}}}}' -n ${NAMESPACE}
        fi
    done
}

# jobs are NOT added here as they are ephemeral resources and will finish after running
RESOURCE_TYPES=("daemonset" "deployment" "statefulset" "cronjob")
NAMESPACES=$(kubectl get ns -o json | jq -r '.items[].metadata.name')

for NAMESPACE in ${NAMESPACES}
do
    for RESOURCE_TYPE in ${RESOURCE_TYPES}
    do
        label_resources ${RESOURCE_TYPE} ${NAMESPACE}
    done
done

echo "Labeling finished"
