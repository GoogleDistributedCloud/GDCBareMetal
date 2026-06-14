#!/bin/bash
# 20260614 - michael at obrienlabs dev - start bmctl script for gdc software only


CIDR_KCC_VPC=192.168.0.0/16
REGION=northamerica-northeast2
# used for vpc, subnet, KCC cluster
PREFIX=olt
#export PROJECT_ID=$DEVSHELL_PROJECT_ID
#PROJECT_ID=gdc-anthos-olt
PROJECT_ID=gdc-anthos2-old
export NETWORK=$REGION
export SUBNET=$NETWORK-sn

export ZONE=$REGION-a
export VPC=$NETWORK-vpc

export CIDR_VPC=192.168.0.0/16

# https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/try/admin-user-gce-vms
#export PROJECT_ID=
export ADMIN_CLUSTER_NAME=gdc-admin
export ON_PREM_API_REGION=$REGION
export BMCTL_VERSION=1.35.0-gke.525
#export ZONE=

  gcloud config set project ${PROJECT_ID}
  gcloud config set compute/zone ${ZONE}

