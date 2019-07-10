#!/usr/bin/env bash

set -ex

#####
# Add nodegroups to the Azure Kubernetes Service resource group.
#####

# Get kubernetes credentials for AKS resource.
az aks get-credentials -g $CLUSTER_GROUP_NAME -n $RESOURCE_NAME --overwrite-existing

# Create nodes for the the AKS cluster in multiple availability zones.
# TODO make this not repeated!
AZ_MIN=1
AZ_MAX=3

# for AZ_NUM in `seq $AZ_MIN $AZ_MAX`; do
#     # Set up standard nodes in AZ1-3.
#     az aks nodepool add \
#       --resource-group $CLUSTER_GROUP_NAME \
#       --cluster-name $RESOURCE_NAME \
#       --name "${RESOURCE_NAME}n${AZ_NUM}" \
#       --node-zones $AZ_NUM \
#       --node-vm-size Standard_B8ms \
#       --enable-cluster-autoscaler \
#       --node-count 1 \
#       --min-count 1 \
#       --max-count 20
# done

# GPU nodes!
# Note that you can't set the count directly to 0.
# Instead, create it with a single node and then immediately scale to 0.
# az aks nodepool add \
#   --resource-group $CLUSTER_GROUP_NAME \
#   --cluster-name $RESOURCE_NAME \
#   --name "${RESOURCE_NAME}gpu" \
#   --node-vm-size Standard_NC6 \
#   --enable-cluster-autoscaler \
#   --node-count 1 \
#   --min-count 1 \
#   --max-count 3

# # Scale GPU nodepool count to 0. If we can't do this we'll have to come up with something else.
# az aks nodepool scale \
#   --resource-group $CLUSTER_GROUP_NAME \
#   --cluster-name $RESOURCE_NAME \
#   --name "${RESOURCE_NAME}gpu" \
#   --node-count 0


# Check our nodepools.
az aks nodepool list \
  -resource-group $CLUSTER_GROUP_NAME \
  --cluster-name $RESOURCE_NAME \
  -o table