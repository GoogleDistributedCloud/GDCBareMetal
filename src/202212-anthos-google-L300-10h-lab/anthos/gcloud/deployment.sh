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

set -e

# task 1 - 5
# task 6 - 5 9:08 left
# task 8 - 10 - 835 left - do not copy from assets deployment-*.yaml, also edit configmap.yaml and restart 3 pods contacts, frontend, loadgenerator, userservice (mot accounts-db or le*service)
# task 9 - 5 - 824 left - add manual git cred - first time run (or do before running lab)
# 5 min later 800 left jumped from 25 to 30
# task 10 - 5 (was the 30 at 0800) 0756
# task 11 - 10 0721 left (need kubernetes engine admin on CB SA)
# task 12 - 5  0710 dev cluster
# 45
# task 13 - 10 0655 cb dev
# 55
# task 14 - 5 1620:645 asm prod
# 60 
# should not have tried 15 - didnt run yet - still at 60
# task 15 - istio injection  - not getting picked up - bounced pods -2/2 already in for later
# revisit with kubectl label namespace default istio.io/rev=asm-1153-6 --overwrite
# task 16 - 5 1645:620 asm dev
# 
# 65 
# task 16b - istio labelling 
# task 17 skip
# task 18 skip
# hack: add istio injection directly on dev (Should have propagated from prod) - uncomment in istio_injection_dev
# task 19 - 10 1700:605 restart both clusters for 2/2
# 75
# 80 (15)
# 85 (16b)

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ ./deployment.sh  -u pdt3 -c true -d false


-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landging.gcp.zone lgz
-c [create] true/false       : create deployment
-d [delete] true/false       : delete deployment
EOF
}

# for ease of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

# directory structure
# 
# bank-of-anthos (CSR repo for task 11+)
# private (this github repo)

create_once_only() {
  # must be inside repo at private/anthos/gcloud dir
  # add a lien to prevent project deletion https://cloud.google.com/resource-manager/docs/project-liens
  #gcloud alpha resource-manager liens create --restrictions=resourcemanager.projects.delete --reason="keep project cpu/ssd quotas"

  ## backup dir
  echo "create backup dir in private/anthos/gcloud dir"
  mkdir backup
  cd ../../../
  mkdir $TEMP_REPO_DIR
  cd $TEMP_REPO_DIR
  # temporary migrate repo
  git clone https://github.com/cloud-quickstart/bank-of-anthos.git
  cd ../private/anthos/gcloud
  # see below
  #gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_INSTALL --project=$PROJECT_ID
  #gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_CE_SRC --project=$PROJECT_ID
  #create_csr
  create_monolith_vm

  #exit 1
}

create_service_accounts() {
  echo "Create service accounts"
  gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_INSTALL --project=$PROJECT_ID
  gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_CE_SRC --project=$PROJECT_ID
}

deploy_gke() {
  start=`date +%s`
  echo "6 min: ${GKE_CLUSTER} cluster create"
  echo "Start: ${start}" 
  echo "Create cluster ${GKE_CLUSTER} prefix: $GKE_prefix release-channel: $GKE_release_channel"
  gcloud beta container clusters create ${GKE_CLUSTER} \
    --machine-type=n1-standard-4 \
    --num-nodes=2 \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --network=$NETWORK \
    --subnetwork=$SUBNET \
    --release-channel=$GKE_release_channel \
    --labels mesh_id=$GKE_prefix${MESH_ID}
  end=`date +%s`
  echo "Finish: ${end}" 
  runtimeb=$((end-start))
  echo "Cluster create time: ${runtimeb} sec"
  echo "Date: $(date)"
}

install_asm() {
  # install asm on GKE
  curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli
  chmod +x asmcli
  echo "validate $GKE_CLUSTER"
  #exit 1
  # gcloud services enable mesh.googleapis.com
  # gcloud services enable anthos.googleapis.com
  # may need to run and then comment validate
  #./asmcli validate --project_id $PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $PROJECT_ID --output_dir ./asm_output
  
  echo "install $GKE_CLUSTER"
  ./asmcli install --project_id $PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $PROJECT_ID --output_dir ./asm_output --enable_all --option legacy-default-ingressgateway --ca mesh_ca --enable_gcp_components
  GATEWAY_NS=istio-gateway
 # gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
 # kubectl create namespace $GATEWAY_NS
 # kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'
 # REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')
 # echo "REVISION: $REVISION"
 # kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite
 # #kubectl apply -n $GATEWAY_NS -f samples/gateways/istio-ingressgateway
 # #kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite
 # kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/platform/kube/bookinfo.yaml
 # kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/networking/bookinfo-gateway.yaml
 # kubectl get gateway
 # # full json
 # #kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={}
 # kubectl get svc -n istio-system istio-ingressgateway 
 # # extract ip from "type":"LoadBalancer"},"status":{"loadBalancer":{"ingress":[{"ip":"34.133.99.17"} 
 # INGRESS_IP=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
 # echo "ingress IP: $INGRESS_IP"
 # echo "sleep 60s - wait for EXTERNAL-IP"
 # sleep 60
 # kubectl get svc -n istio-system istio-ingressgateway 
 # INGRESS_IP=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
 # echo "ingress IP: $INGRESS_IP"
 # curl -I http://${INGRESS_IP}/productpage
 # #sudo apt install siege siege http://${INGRESS_IP}/productpage
}

install_gateway() {
  # post install_asm
  echo "installing gateway on $GKE_CLUSTER in $GATEWAY_NS"
  gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
  kubectl create namespace $GATEWAY_NS
  ISTIO_NS=istio-system
  kubectl get deploy -n $ISTIO_NS -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'
  REVISION=$(kubectl get deploy -n $ISTIO_NS -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')
  echo "REVISION: $REVISION"
  # apply to default to pass task 15 and 16b
  kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite
  #kubectl apply -n $GATEWAY_NS -f samples/gateways/istio-ingressgateway
  
  kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/networking/bookinfo-gateway.yaml
  kubectl get gateway
  # full json
  #kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={}
  kubectl get svc -n $ISTIO_NS istio-ingressgateway 
  # extract ip from "type":"LoadBalancer"},"status":{"loadBalancer":{"ingress":[{"ip":"34.133.99.17"} 
  INGRESS_IP=$(kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  echo "sleep 60s - wait for EXTERNAL-IP"
  sleep 60
  kubectl get svc -n $ISTIO_NS istio-ingressgateway 
  INGRESS_IP=$(kubectl get svc -n $ISTIO_NS istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  curl -I http://${INGRESS_IP}/productpage
  #sudo apt install siege siege http://${INGRESS_IP}/productpage
  # from lab
  #export GATEWAY_URL=$(kubectl get svc istio-ingressgateway -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n $GATEWAY_NS)
  #echo "Istio Gateway Load Balancer: http://$GATEWAY_URL"
}

istio_injection() {
    # post install_gateway
    # switch kubectl context
    gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
    # display istio status
    kubectl get ns
    # no 2/2 pods running istio sidecars yet
    kubectl get pods
    # no istio labeling on namespaces yet
    kubectl get namespace -L istio-injection
    # label namespace default
    kubectl label namespace default istio-injection=enabled --overwrite
    # check namespace labeling
    kubectl get namespace -L istio-injection
    # bounce pods - to get them istio injected with sidecars
    # TODO expand to all pods
    kubectl delete pod -l app=productpage
    # display 2/2 sidecars
    echo "sleep 20s before checking for 2/2 injected sidecars"
    sleep 20
    kubectl get pods | grep 2/2
}

create_roles_services() {
# check expiry https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding

echo "Adding roles to project for user: ${USER_EMAIL}"
# owner for now
#gcloud projects add-iam-policy-binding $PROJECT_ID  --member=user:$USER_EMAIL --role=roles/owner --quiet > /dev/null 1>&1

#gcloud projects add-iam-policy-binding $PROJECT_ID  --member=user:$USER_EMAIL --role=roles/billing.projectManager --quiet > /dev/null 1>&1
# for SA impersonation
#gcloud projects add-iam-policy-binding $PROJECT_ID  --member=user:$USER_EMAIL --role=roles/iam.serviceAccountTokenCreator --quiet > /dev/null 1>&1

# https://gcp.permissions.cloud/predefinedroles

# Storage Admin
#gcloud projects add-iam-policy-binding $PROJECT_ID  --member=user:$USER_EMAIL --role=roles/storage.admin --quiet > /dev/null 1>&1

   # enable apis
   echo "Enabling APIs"
   # CSR (up from AR) (for cloud run) ok
   #gcloud services enable accesscontextmanager.googleapis.com 
   gcloud services enable anthos.googleapis.com
   gcloud services enable artifactregistry.googleapis.com
   gcloud services enable cloudapis.googleapis.com 
   gcloud services enable cloudbilling.googleapis.com
   # will auto create the service account - get it and save to vars.sh
   gcloud services enable cloudbuild.googleapis.com 
   gcloud services enable cloudfunctions.googleapis.com
   gcloud services enable cloudkms.googleapis.com
   gcloud services enable cloudresourcemanager.googleapis.com 
   gcloud services enable compute.googleapis.com
   gcloud services enable container.googleapis.com 
   gcloud services enable containeranalysis.googleapis.com
   gcloud services enable containerregistry.googleapis.com
   gcloud services enable krmapihosting.googleapis.com 
   gcloud services enable logging.googleapis.com 
   gcloud services enable mesh.googleapis.com
   #gcloud services enable monitoring.googleapis.com
   gcloud services enable run.googleapis.com
   gcloud services enable sourcerepo.googleapis.com
   gcloud services enable storage-component.googleapis.com 

   # add Kubernetes Cluster Admin to Cloud Build Service Agent

  # sas
  #Add	Artifact Registry Service Agent	 service-374013806670@gcp-sa-artifactregistry.iam.gserviceaccount.com		
  #Add	Cloud Run Service Agent	 service-374013806670@serverless-robot-prod.iam.gserviceaccount.com	
  #Kubernetes Engine Developer
}

istio_injection_dev() {
  echo "istio_injection_dev"
  gcloud config set compute/zone ${ZONE}
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_DEV
  export GKE_prefix=d
  # 20230101 switched from prod
  #istio_injection
}

istio_injection_prod() {
  echo "istio_injection_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  istio_injection
}

asm_cluster_dev() {
  echo "asm_cluster_dev"
  gcloud config set compute/zone ${ZONE}
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_DEV
  export GKE_prefix=d
  install_asm 
}

asm_cluster_prod() {
  echo "asm_cluster_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  install_asm 
}

install_gateway_prod() {
  echo "install_gateway_prod"
  gcloud config set compute/zone ${ZONE}
  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  install_gateway
}

create_cluster_mig() {
  start=`date +%s`
  echo "Date: $(date)"
  echo "7 min install $GKE_PROCESSING Start: ${start}"  
  gcloud config set compute/zone ${ZONE}
  gcloud container clusters create $GKE_PROCESSING --project=$PROJECT_ID --zone=$ZONE --machine-type e2-standard-4 --image-type ubuntu_containerd --num-nodes 1 --enable-stackdriver-kubernetes --network=$NETWORK --subnetwork=$SUBNET
  end=`date +%s`
  runtimeb=$((end-start))
  echo "Cluster create time: ${runtimeb} sec"
}

create_cluster_dev() {
  echo "32 min total: 6 min: dev cluster:"
  gcloud config set compute/zone ${ZONE}
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_DEV
  export GKE_prefix=d
  deploy_gke
}

create_cluster_prod() {
  echo "32 min total: 6 min: prod cluster:"
  gcloud config set compute/zone ${ZONE}

  #export GKE_release_channel=regular
  export GKE_release_channel=stable
  export GKE_CLUSTER=$GKE_PROD
  export GKE_prefix=p
  deploy_gke
}

create_cluster_monolith() {
  gcloud config set compute/zone ${ZONE}
  # standup monolith cluster 
  start=`date +%s`
  echo "Date: $(date)"
  echo "7 min install $GKE_MONOLITH Start: ${start}"  
  gcloud container clusters create-auto $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}
  #gcloud container clusters get-credentials $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}
  end=`date +%s`
  runtimeb=$((end-start))
  echo "Cluster create time: ${runtimeb} sec"

  # kubectl
  #gcloud container clusters get-credentials $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}
  #gcloud container clusters get-credentials $GKE_PROCESSING --zone $ZONE
  #gcloud container clusters get-credentials $GKE_DEV --zone $ZONE
  #gcloud container clusters get-credentials $GKE_PROD --zone $ZONE
}

delete_clusters() {
  gcloud config set compute/zone ${ZONE}
  echo "Date: $(date)"
  echo "19 min"
  echo "Delete ${GKE_MONOLITH} in region ${REGION}"
  gcloud container clusters delete $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION} --quiet
  echo "Delete $GKE_PROD cluster"
  gcloud beta container clusters delete $GKE_PROD --quiet
  echo "Delete $GKE_DEV cluster"
  gcloud beta container clusters delete $GKE_DEV --quiet
  echo "Delete $GKE_PROCESSING cluster"
  gcloud beta container clusters delete $GKE_PROCESSING --quiet
  echo "Delete $MONOLITH_SERVICE vm"
  # don't delete after initial run - in the lab only - as it is precreated
  gcloud compute instances delete $MONOLITH_SERVICE --quiet
}

create_vpc() {
# create VPC
  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_VPC --region $REGION
}

delete_vpc() {
  # delete VPC (routes and firewalls will be deleted as well)
  echo "deleting subnet ${SUBNET}"
  gcloud compute networks subnets delete ${SUBNET} --region=$REGION -q
  echo "deleting vpc ${NETWORK}"
  gcloud compute networks delete ${NETWORK} -q
}

create_monolith_vm () {
  # TODO: don't delete monolith after it is created
  cp assets/deploy-monolith.sh ../../../$TEMP_REPO_DIR/bank-of-anthos/src/ledgermonolith/scripts/
  ../../../$TEMP_REPO_DIR/bank-of-anthos/src/ledgermonolith/scripts/deploy-monolith.sh
}

create_migration() {
# in between ops to be moved to "create"
# prereq
#    --project $PROJECT_ID \
#    --zone $ZONE \
#    --network $NETWORK \
#    --subnet $SUBNET \

  # copy adjusted script for non-default network
  echo "Date: $(date)"
  echo "run deploy-monolith.sh from temporary local only bank repo - cloned in create_once_only"
  #cd ../../../

  # monolith must be created

  # step 2
  #gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_INSTALL --project=$PROJECT_ID - in create_once
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT_M4A_INSTALL@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin" --quiet > /dev/null 1>&1
  gcloud iam service-accounts keys create $SERVICE_ACCOUNT_M4A_INSTALL.json --iam-account=$SERVICE_ACCOUNT_M4A_INSTALL@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID
  # migctl 1.14 default
  gcloud container clusters get-credentials $GKE_PROCESSING --zone $ZONE
  migctl setup install --json-key=$SERVICE_ACCOUNT_M4A_INSTALL.json --gcp-project $PROJECT_ID --gcp-region $REGION
  migctl doctor
  echo "sleep 90 sec"
  sleep 90
  migctl doctor

  #gcloud iam service-accounts create $SERVICE_ACCOUNT_M4A_CE_SRC --project=$PROJECT_ID - in create_once
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT_M4A_CE_SRC@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.viewer" --quiet > /dev/null 1>&1
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT_M4A_CE_SRC@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.storageAdmin" --quiet > /dev/null 1>&1
  gcloud iam service-accounts keys create $SERVICE_ACCOUNT_M4A_CE_SRC.json --iam-account=$SERVICE_ACCOUNT_M4A_CE_SRC@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID
  migctl source create ce $MONOLITH_SERVICE --project $PROJECT_ID --json-key=$SERVICE_ACCOUNT_M4A_CE_SRC.json
  migctl source list
  migctl doctor
  echo "sleep 1 min"
  sleep 60
  migctl doctor

  # stop the monolith
  gcloud compute instances stop $MONOLITH_SERVICE
  migctl migration create $MONOLITH_MIGRATION --source $MONOLITH_SERVICE --vm-id $MONOLITH_SERVICE --type linux-system-container
  # 6 min for 4 core, 3 min for 8 core
  migctl migration status $MONOLITH_MIGRATION
  # ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateMigrationPlan                   GenerateMigrationPlan   Completed       2m3s
  echo "sleep 1 min of 6"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 2 min of 6"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 3 min of 6"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 4 min of 6"
  sleep 60
  #migctl migration status $MONOLITH_MIGRATION
  #echo "sleep 5 min of 6"
  #sleep 60
  #migctl migration status $MONOLITH_MIGRATION
  #echo "sleep 6 min of 6"
  #sleep 60
  migctl migration status $MONOLITH_MIGRATION

  ## get artifacts
  rm -rf ledgermonolith-migration*.yaml
  migctl migration get $MONOLITH_MIGRATION --overwrite
  ## get updated version with the volume
  cp ledgermonolith-migration.data.yaml backup/
  cp assets/ledgermonolith-migration.data.yaml .
  migctl migration update $MONOLITH_MIGRATION --file ledgermonolith-migration.yaml

  # 5-6 min
  migctl migration generate-artifacts $MONOLITH_MIGRATION
  # if migration hangs - check the logs for SSD quota issues
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 1 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 2 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 3 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 4 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 5 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION
  echo "sleep 6 min of 5"
  sleep 60
  migctl migration status $MONOLITH_MIGRATION

  migctl migration get-artifacts $MONOLITH_MIGRATION --overwrite
  # Note - the project name is hardcoded and needs to be fixed in the assets yaml
  # gcr.io/anthos-old/ledgermonolith-service:12-27-2022--4-12-5
  # save and use pre-edited version
  cp deployment_spec.yaml backup/
  # use orginal
  cp assets/deployment_spec.yaml .
}

# task 7
deploy_migration_yaml() {
    # TODO
    echo "Deploy deployment_spec to monolith cluster"
    # change for non-autopilot
    gcloud container clusters get-credentials $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}
    kubectl apply -f deployment_spec.yaml
    echo "sleep 30 sec"
    sleep 30
    kubectl get service
}

# task 8
update_migration_configmap() {
   # TODO
   echo "update migration configmap"
}

create_cloudbuild_prod() {
    # task 11
     # requires kubernetes engine admin on the cb sa
  echo "Create Cloud Build - prod"
  # Kubernetes Engine Developer
  #https://cloud.google.com/kubernetes-engine/docs/how-to/iam
#  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUD_BUILD_SA" --role="roles/container.developer" --quiet > /dev/null 1>&1
  # https://cloud.google.com/build/docs/deploying-builds/deploy-gke
  # working so far without a service account set
  # PROD MAIN create cloud build trigger (simultaneous dev/prod gke cluster builds - should do dev first)
  gcloud beta builds triggers create cloud-source-repositories --repo=$CSR_NAME --branch-pattern=main --name="${CLOUDBUILD_TRIGGER_PROD_MAIN}" --build-config=cloudbuild-prod-main.yaml
  
  #gcloud builds submit --region=$REGION --project=$PROJECT_ID --config build-config
  #gcloud alpha builds trigger create cloud-source-repositories --trigger-config=cloudbuild.yaml --project=$PROJECT_ID
}

create_cloudbuild_dev() {
   # requires kubernetes engine admin on the cb sa
   # task 13
  echo "Create Cloud Build - dev"
  # Kubernetes Engine Developer
  #https://cloud.google.com/kubernetes-engine/docs/how-to/iam
 # gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUD_BUILD_SA" --role="roles/container.developer" --quiet > /dev/null 1>&1
  # https://cloud.google.com/build/docs/deploying-builds/deploy-gke
  # working so far without a service account set
  # DEV MAIN create cloud build trigger
  #gcloud beta builds triggers create cloud-source-repositories --repo=$CSR_NAME --branch-pattern=main --name="${CLOUDBUILD_TRIGGER_DEV_MAIN}" --build-config=cloudbuild-dev-main.yaml
  # DEV cymbal-dev create cloud build trigger
  gcloud beta builds triggers create cloud-source-repositories --repo=$CSR_NAME --branch-pattern=cymbal-dev --name="${CLOUDBUILD_TRIGGER_DEV_CYMBAL_DEV}" --build-config=cloudbuild-dev-cymbal-dev.yaml
  
  #gcloud builds submit --region=$REGION --project=$PROJECT_ID --config build-config
  #gcloud alpha builds trigger create cloud-source-repositories --trigger-config=cloudbuild.yaml --project=$PROJECT_ID
}

trigger_prod_main_build() {
  echo "trigger_prod_main_build"
  # commit to main branch
  cd ../../../bank-of-anthos
  git checkout main
  cp ../private/anthos/gcloud/assets/empty_stub.sh empty1_stub.sh
  git add empty1_stub.sh
  git commit -m "trigger prod"
  git push google main
  git checkout main   
  cd ../private/anthos/gcloud
}

trigger_cymbal_dev_build() {
  echo "trigger_cymbal_dev_build"
  # commit to cymbal-dev branch
  cd ../../../bank-of-anthos
  git checkout $BRANCH_DEV
  cp ../private/anthos/gcloud/assets/empty_stub.sh empty0_stub.sh
  git add empty0_stub.sh
  git commit -m "trigger dev"
  git push google $BRANCH_DEV
  git checkout main   
  cd ../private/anthos/gcloud
}

delete_cloudbuild() {
  echo "delete 2 Cloud Build triggers"
  gcloud beta builds triggers delete $CLOUDBUILD_TRIGGER_DEV_CYMBAL_DEV
  #gcloud beta builds triggers delete $CLOUDBUILD_TRIGGER_DEV_MAIN
  gcloud beta builds triggers delete $CLOUDBUILD_TRIGGER_PROD_MAIN
}

create_csr() {
   echo "Creating CSR"
   # task 9
   cd ../../../
   # create csr, ar
   # https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes
   # validated
   git config --global credential.'https://source.developers.google.com'.helper gcloud.sh
   gcloud source repos create $CSR_NAME
   # unvalidated

   git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
   cd bank-of-anthos

   # manually
   #gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
   #git remote add google https://source.developers.google.com/p/anthos-old/r/cymbal-bank-repo
   git remote add google https://source.developers.google.com/p/$PROJECT_ID/r/$CSR_NAME
   #git push google master
   #git push google main   
   git push --all google
   # note - will stop on user/email credentials - the first time through here

   # Task 13
   # Create branch cymbal-dev
   git branch $BRANCH_DEV
   git push -u google $BRANCH_DEV

   git checkout main
      # copy artifacts (will be in both branches)
   cp ../private/anthos/gcloud/assets/main/cloudbuild-prod-main.yaml .
   cp ../private/anthos/gcloud/assets/main/cloudbuild-dev-main.yaml .
   cp ../private/anthos/gcloud/assets/cymbal-dev/cloudbuild-dev-cymbal-dev.yaml .
   git add .
   git commit -m "triple cloud build main"
   git push google main
      # copy artifacts (will be in both branches)
   git checkout $BRANCH_DEV
   cp ../private/anthos/gcloud/assets/main/cloudbuild-prod-main.yaml .
   cp ../private/anthos/gcloud/assets/main/cloudbuild-dev-main.yaml .
   cp ../private/anthos/gcloud/assets/cymbal-dev/cloudbuild-dev-cymbal-dev.yaml .

   git add .
   git commit -m "triple cloud build dev"
   git push google $BRANCH_DEV
   git checkout main   
   # enable csr role
   #gcloud source repos set-iam-policy $CSR_NAME POLICY_FILE
   cd ../private/anthos/gcloud

   # ar
 #  gcloud artifacts repositories create reference-code --location=northamerica-northeast1 --repository-format=docker

}

delete_csr() {
  # delete CSR - cannot reuse name for 7d
  # delete repo
  gcloud source repos delete $CSR_NAME --quiet
  echo "Delete CSR dir"
  rm -rf ../../../bank-of-anthos
  echo "Delete temp repo"
  rm -rf ../../../$TEMP_REPO_DIR
  # delete triggers done in delete_cloudbuild before

 
}

delete_all() {
  # delete service accounts
  gcloud iam service-accounts delete $SERVICE_ACCOUNT_M4A_CE_SRC@$PROJECT_ID.iam.gserviceaccount.com  --project=$PROJECT_ID --quiet
  gcloud iam service-accounts delete $SERVICE_ACCOUNT_M4A_INSTALL@$PROJECT_ID.iam.gserviceaccount.com  --project=$PROJECT_ID --quiet
  # cloud build service account was generated on service enablement
 
  delete_cloudbuild
  delete_csr

  # delete generated files in the repo
  rm -rf *.yaml
  rm -rf *.json
  rm -rf Dockerfile
  rm -rf asm_output
  rm -rf asmcli
  rm -rf backup/*
  rm -rf backup

  # disable billing before deletion - to preserve the project/billing quota
#  echo "disable billing on - and delete ${PROJECT_ID}"
#  gcloud alpha billing projects unlink ${PROJECT_ID} 
  # delete cc project
#  gcloud projects delete $PROJECT_ID --quiet
  echo "Date: $(date)"
}

deployment() {
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -u $UNIQUE -c $CREATE_KCC -d $DELETE_KCC -p $PROJECT_ID"

startd=`date +%s`
echo "Start: ${startd}"
# Set Vars for Permissions application
export MIDFIX=$UNIQUE
echo "unique string: $MIDFIX"
echo "REGION: $REGION" # defined in vars.sh
echo "NETWORK: $NETWORK"
echo "SUBNET: $SUBNET"
echo "ZONE: $ZONE"
echo "Reusing project: $PROJECT_ID"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"
# We pass in the project id so we can switch back from potentially another transient project
export BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo "BILLING_ID: ${BILLING_ID}"
ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
echo "ORG_ID: ${ORG_ID}"
export EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')
#echo "EMAIL: ${EMAIL}"


# switch back to/create kcc project - not in a folder
if [[ "$CREATE_KCC" != false ]]; then

  start=`date +%s`
  echo "50 min Start: ${start}"  
  echo "Date: $(date)"
  gcloud config set compute/zone ${ZONE}
# task 1
  create_roles_services
  create_vpc
  #including task 9

  create_once_only
  create_service_accounts  

  # task 1
  create_cluster_mig
  # CH 1 - proc cluster

  # task 1 - for task 7
  create_cluster_monolith
  # task 1-6 migration GKE
  create_monolith_vm # 1 time only
  create_migration
  # CH 6 - migrate ok

  # apply yamls to monolith cluster
  # task 7 - deploy temp repo to cluster monolith
  deploy_migration_yaml
  # task 8 - update config map, restart 3 pods - watch gcr.io image name based on project
  update_migration_configmap
  # CH 8 - ok

  # task 9
  # uncomment
  create_csr # - moved from task 0

  # task 10 - create prod gke, deploy v1 frontend
  create_cluster_prod
  # CH 10 - PROD GKE

  # task 11 - 2nd clone
  # task 11 - deploy v1 of frontend.yaml
  # task 11 - cb prod - needs kubernetes engine admin on the CB SA
  create_cloudbuild_prod
  # task 11 - trigger prod main build
  trigger_prod_main_build

  # task 12 - DEV GKE
  create_cluster_dev

  # task 13 TBD deploy v2 of frontend.yaml

  # task 13 - needs cb SA
  create_cloudbuild_dev
  # task 13 - cymbal-dev logo
  # trigger cymbal-dev build
  trigger_cymbal_dev_build


  # task 14 
  asm_cluster_prod

  # task 15
  istio_injection_prod

  # task 16
  asm_cluster_dev

  # task 17 - fwl rule between clusters

  # task 18 - remote secrets both clusters

  # task 19 - restart dev pods - trigger sidecar injection
  #istio_injection_dev - not required - key off prod

  # task 20 - Create and deploy an Istio Gateway and Virtual Service on the production cluster
  # create gateway-namespace
  # deploy an Istio ingress gateway called istio-ingressgateway on the production cluster
  install_gateway_prod
  # enable traffic management and load balancing across clusters using the sample Virtual Service manifest included in 
  # the Bank of Anthos repository file ./istio-manifests/frontend-ingress.yaml as your template

  # task 21
  # Create a Destination rule set that defines Istio subsets for v1 (production) and v2 (development) traffic. If you labelled your production frontend deployment manifest files with version=v1 and development frontend deployment manifest files with version=v2 labels as you were instructed in Part 2, you can use these labels to define two subsets for your destination rule.
  # Configure your VirtualService to distribute 75% of traffic to the production cluster (v1 frontend) and 25% of traffic to the development cluster (v2 frontend).  
 fi

#  deploy_migration_yaml
  # task 8 - update config map, restart 3 pods - watch gcr.io image name based on project
#  update_migration_configmap
  # CH 8 - ok

  # task 9
  # uncomment
  #create_csr # - moved from task 0

#create_cluster_prod
# create_cloudbuild_prod
  # task 11 - trigger prod main build
#  trigger_prod_main_build

  #create_cluster_dev

#    create_cloudbuild_dev
  # task 13 - cymbal-dev logo
  # trigger cymbal-dev build
#  trigger_cymbal_dev_build

  # task 14 
  #asm_cluster_prod
  # task 15
  #istio_injection_prod # - problematic - check lablelling - bounced pods to 2/2 on prod
    #asm_cluster_dev


    #install_gateway_prod
 # delete
 if [[ "$DELETE_KCC" != false ]]; then
   delete_clusters
   delete_vpc
   delete_all
 fi

  #gcloud config set project "${BOOT_PROJECT_ID}"
  #echo "Switched back to boot project ${BOOT_PROJECT_ID}" 
  # go back to the script dir
  ##cd pubsec-declarative-toolkit/solutions/document-processing 

  echo "Use the following command to switch to your new project"
  echo "gcloud config set project ${PROJECT_ID}"

  endd=`date +%s`
  echo "Finish: ${endd}" 
  runtimed=$((endd-startd))
  echo "Cluster create time: ${runtimed} sec"
  echo "Date: $(date)"
}


UNIQUE=
CREATE_KCC=false
DELETE_KCC=false


while getopts ":u:c:d:" PARAM; do
  case $PARAM in
    u)
      UNIQUE=${OPTARG}
      ;;
    c)
      CREATE_KCC=${OPTARG}
      ;;
    d)
      DELETE_KCC=${OPTARG}
      ;; 
    ?)
      usage
      exit
      ;;
  esac
done

#  echo "Options are: -c true/false (create kcc), -d true/false (delete kcc)"


if [[ -z $UNIQUE ]]; then
  usage
  exit 1
fi

deployment $UNIQUE $CREATE_KCC $DELETE_KCC
printf "**** Done ****\n"
