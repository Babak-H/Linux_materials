#!/usr/bin/env sh

###
# Script location: svvr-mng08:/liveperson/code/big_data_scripts/elasticsearch
# Description: The script checks if number of nodes returning from zoom command is equal to number $
# from ES API (/_cat/nodes) and in case oot equal then will print which node/s out of cluster
###

# This script checks if the number of Elasticsearch nodes in a cluster matches the number of nodes found in 
# the Zoom inventory. It can be used to identify nodes that are out of the cluster.

# variables

# A flag indicating whether to check all clusters or a specific one
ALL_CLUSTERS=false
# data center
FARM=$1
# segment
SEGMENT=$2
#  elastic cluster
LP_CLUSTER=$3
# number of Zoom nodes
total_zoom_nodes=
# Elasticsearch master node
ES_NODE=
# number of Elasticsearch API nodes,
total_es_api_nodes=
# Temporary files to store the lists of Zoom nodes and Elasticsearch API nodes
zoom_nodes="/tmp/zoom_nodes"
es_api_nodes="/tmp/es_api_nodes"

# displays a message when the required arguments are missing
function usage(){
    echo "" && echo "Missing argument!" && echo ""
    echo "Usage: $0 <dc> <segment> <lpcluster>"
    echo ""
    exit 1
}

# retrieves the Zoom nodes and the Elasticsearch master node for the specified data center, segment, and Elasticsearch cluster
function get_zoom_nodes() {
  zoom -g -D $1 -L $2 --HF lpcluster=/^$3$/ -f hostname > ${zoom_nodes}
  # is set to the number of lines in the zoom_nodes file
  total_zoom_nodes=$(cat ${zoom_nodes} | wc -l)
  # The ES_NODE variable is set to the first hostname in the zoom_nodes file that has the "master" role. If no master node is found, it's set to the first "client" node.
  ES_NODE=$(zoom -g -D $1 -L $2 --HF lpcluster=/^$3$/ --HF lprole=/master/ -f hostname | head -n 1)
  if [[ -z ${ES_NODE} ]]; then
    ES_NODE=$(zoom -g -D $1 -L $2 --HF lpcluster=/^$3$/ --HF lprole=/client/ -f hostname | head -n $
  fi
}

# retrieves the Elasticsearch API nodes for the specified Elasticsearch cluster
function get_es_api_nodes() {
  if [[ $1 == "z1_elasticsearch_messaging_75_anthem" ]]; then
    curl -k -s -u elastic:HoldNoMore@2020 -XGET https://${ES_NODE}:9200/_cat/nodes?h=name > ${es_ap$}
  else
  # The curl command queries the Elasticsearch API for the list of nodes, and writes the node names to the es_api_nodes file.
    curl -s -XGET http://${ES_NODE}:9200/_cat/nodes?h=name > ${es_api_nodes}
  fi
  # set to the number of lines in the es_api_nodes file.
  total_es_api_nodes=$(cat ${es_api_nodes} | wc -l)
}

# compares the numbers of Zoom nodes and Elasticsearch API nodes, and prints the results
function check_if_equal() {
  echo "======================================================================"
  echo "Farm: $1, Segment=$2, ES_Cluster=$3"
  echo "Total zoom nodes: ${total_zoom_nodes}"
  echo "Total ES API nodes: ${total_es_api_nodes}"
  echo ""
  # If the numbers of Zoom nodes and Elasticsearch API nodes are not equal, the script iterates through the list
  # zoom_node and then api_nodes recursivly to find that matches both, then print name of that node.
  if [[ ${total_zoom_nodes} != ${total_es_api_nodes} ]]; then
    for i in `cat ${zoom_nodes}`; do
      found=false
      for j in `cat ${es_api_nodes}`; do
        j=$(echo $j | awk -F'.' '{print $1}')
        [[ $i == $j ]] && found=true && break
      done

      [[ $found == "false" ]] && echo "Node $i is out of cluster"
    done
  else
    echo "All nodes are in cluster"
  fi
}

# if we do not give any arguements then it will set all_clusters to true
if [[ -z ${FARM} ]] && [[ -z ${SEGMENT} ]] && [[ -z ${LP_CLUSTER} ]]; then
  ALL_CLUSTERS=true
# if we give only one or two arguments, it will throw an error
elif [[ -z ${FARM} ]] || [[ -z ${SEGMENT} ]] || [[ -z ${LP_CLUSTER} ]]; then
  usage
fi

# 
if [[ ${ALL_CLUSTERS} == "true" ]]; then
  zoom -g --HF lpcluster=/elastic.*mess\|elastic.*chat\|elastic.*interac/ --HF elasticsearch_versio$
  # read the "all_clusters" file line by line, get the 3 arguements from each line and call the 3 functions
  while IFS=, read -r f1 f2 f3
  do
    get_zoom_nodes ${f1} ${f2} ${f3}
    get_es_api_nodes ${f3}
    check_if_equal ${f1} ${f2} ${f3}
  done < /tmp/all_clusters
else
# if all_clusters is false, then call the 3 functions for the specific segement and cluster from the arguements
  get_zoom_nodes ${FARM} ${SEGMENT} ${LP_CLUSTER}
  get_es_api_nodes ${LP_CLUSTER}
  check_if_equal ${FARM} ${SEGMENT} ${LP_CLUSTER}
fi
