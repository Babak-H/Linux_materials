#!/bin/sh

# Function to scale deployments
function scale_deployments() {
    # local  Declares a local variable within a function.
    local namespace=$1 # Assigns the first argument ($1) passed to the function to the namespace variable.
    local scale_to=$2 # Assigns the second argument ($2) passed to the function to the scale_to variable.

    kubectl scale deployment --namespace="$namespace" --replicas="$scale_to" \
    $(kubectl get deployments --namespace="$namespace" -o json \
        | jq -r '.items[].metadata.name' \
        # egrep -v → Excludes any lines matching "vault-tools" or "istio-annotation-tm-webhook"
        | egrep -v "vault-tools|istio-annotation-tm-webhook")
}

function scale_jobs() {
    local namespace=$1
    local scale_to=$2

    kubectl scale jobs --namespace=$namespace --replicas=$scale_to \
    $(kubectl get jobs --namespace=$namespace -o json \
        | jq -r '.items[].metadata.name')
}

function scale_statefulsets() {
    local namespace=$1
    local scale_to=$2

    kubectl scale statefulset --namespace=$namespace --replicas=$scale_to \
    $(kubectl get statefulset --namespace=$namespace -o json \
        | jq -r '.items[].metadata.name')
}

# The ":" at the start means that missing arguments will trigger the :) error case
while getopts ":n:s:" opt; do
    case $opt in
        n) namespace=$OPTARGS ;;
        s) scale_to=$OPTARGS ;;
        ?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done
# make sure variables are not empty
if [[ -z $namespace || -z $scale_to ]]; then
    echo "Usage: $0 -n <namespace> -s <scale>"
fi

# Scale deployments, jobs, and statefulsets
echo "Running autoscaler for $namespace - setting replicas to: $scale_to"
scale_deployments $namespace $scale_to
scale_jobs $namespace $scale_to
scale_statefulsets $namespace $scale_to
