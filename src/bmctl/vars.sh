#!/bin/bash
# 20260614 - michael at obrienlabs dev - start bmctl script for gdc software only


CIDR_KCC_VPC=192.168.0.0/16
REGION=us-central1
# used for vpc, subnet, KCC cluster
PREFIX=olt
#export PROJECT_ID=$DEVSHELL_PROJECT_ID
PROJECT_ID=gdc-anthos-olt
export NETWORK=$REGION
export SUBNET=$NETWORK-sn

export ZONE=$REGION-a
export VPC=$NETWORK-vpc

export CIDR_VPC=192.168.0.0/16
export GKE_MONOLITH=cymbal-monolith-cluster
export CLUSTER=$GKE_MONOLITH


gcloud config set compute/zone ${ZONE}
