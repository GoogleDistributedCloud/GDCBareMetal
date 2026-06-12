
#!/bin/bash
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CIDR_KCC_VPC=192.168.0.0/16
REGION=us-central1
# used for vpc, subnet, KCC cluster
PREFIX=pdt
#KCC_PROJECT_NAME=

# increment/verify
export CSR_NAME=cymbal-bank-repo7
# after the fact - post service enablement - 2nd one
# not required
export CLOUD_BUILD_SA=880919021125@cloudbuild.gserviceaccount.com


export TEMP_REPO_DIR=temp0

export PROJECT_ID=$DEVSHELL_PROJECT_ID
export REGION=us-central1
export NETWORK=$REGION
export SUBNET=$NETWORK-sn
#export NETWORK=default
#export SUBNET=default

export ZONE=$REGION-a
export VPC=$NETWORK-vpc

export CIDR_VPC=192.168.0.0/16
export GKE_MONOLITH=cymbal-monolith-cluster
export CLUSTER=$GKE_MONOLITH
export GKE_DEV=cymbal-bank-dev
export GKE_PROD=cymbal-bank-prod
export GKE_PROCESSING=m4a-processing

export GATEWAY_NS=istio-gateway

export MONOLITH_SERVICE=ledgermonolith-service
export MONOLITH_MIGRATION=ledgermonolith-migration

export BRANCH_PROD=main
export BRANCH_DEV=cymbal-dev

export SERVICE_ACCOUNT_M4A_INSTALL=m4a-install
export SERVICE_ACCOUNT_M4A_CE_SRC=m4a-ce-src

export CLOUDBUILD_TRIGGER_DEV_CYMBAL_DEV=dev-cymbal-dev
export CLOUDBUILD_TRIGGER_DEV_MAIN=dev-main
export CLOUDBUILD_TRIGGER_PROD_MAIN=prod-main

gcloud config set compute/zone ${ZONE}
