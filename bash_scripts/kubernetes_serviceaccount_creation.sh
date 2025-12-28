# To automate the creation of a service account in a specific Kubernetes namespace using a shell script, 
# you can use the kubectl command-line tool. 


#!/bin/bash

# Check if the correct number of arguments is provided
if ["$#" -ne 2 ]; then
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
if [ $? -eq 0 ]; then
    echo "Service account '$SERVICE_ACCOUNT' created successfully in namespace '$NAMESPACE'."
else
    echo "Failed to create service account '$SERVICE_ACCOUNT' in namespace '$NAMESPACE'."
    exit 1
fi

# what does this mean? if [ $? -ne 0 ]; then
# the construct if [ $? -ne 0 ]; then is used to check the exit status of the last executed command.

# $? : This is a special variable in shell scripting that holds the exit status of the last executed command. The exit status is a numeric value returned by a command to indicate whether it succeeded or failed. By convention, an exit status of 0 means success, while any non-zero value indicates an error or failure.
