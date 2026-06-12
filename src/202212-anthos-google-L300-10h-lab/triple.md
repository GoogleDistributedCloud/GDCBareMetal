# devops
# 20221219-20230104
# fmichaelobrien@google.com
# L300 DevOps 10h certification lab
# original PRs in https://github.com/cloud-quickstart/private/commit/f54a9ce6f4f3a7b5349bcb71e7dafdfb951ed892


17 of 21 tasks
12 of 15 checks to 2nd 16 asm dev cluster
total: 10 + 3 in progress 2 missing = 15
## Task 1 Check that a processing cluster has been created
1
## Task 6 Check that a Migrate to Containers migration task has completed successfully
1
## Task 8 Check that the Cymbal Bank Monolith VM has been migrated and the application updated to use the migrated container.
0
## Task 9 Check that a Cloud source Repository called cymbal-bank-repo has been created in your project.
1
## Task 10 Check that a Kubernetes Engine cluster called cymbal-bank-prod has been created
1
## Task 11 Check that Bank of Anthos has been deployed to the production cluster with a Cloud Build pipeline.
0
## Task 12 Check that a Kubernetes Engine cluster called cymbal-bank-dev has been created
1 - copy frontend.yaml
## Task 13 Check that Cymbal Bank has been deployed to the development cluster with a Cloud Build pipeline.
0
## Task 14 Check that ASM has been deployed to cymbal-bank-prod.
1
## Task 15 Check that Kubernetes Namespaces are correctly labelled for ASM in the cymbal-bank-prod cluster.
1
## Task 16 Check that ASM has been deployed to cymbal-bank-dev.
1
## Task 16 Check that Kubernetes Namespaces are correctly labelled for ASM in the cymbal-bank-dev cluster.
1
## Task 19 Check that all pods have been restarted and sidecar injection has been triggered.
1
## Task 20 Check that the istio ingress has been created and is routing traffic to the applications.

## Task 21 Check that the istio ingress has been updated to route traffic 75% to production and 25% to development.





# quota

<img width="1589" alt="Screen Shot 2022-12-26 at 14 10 14" src="https://user-images.githubusercontent.com/24765473/209577444-c4a50b9a-58bb-48e1-89f1-80c5ea66e735.png">
for
<img width="1606" alt="Screen Shot 2022-12-26 at 14 10 35" src="https://user-images.githubusercontent.com/24765473/209577464-4edb2756-08b9-44b8-9156-e810b219b3c4.png">

<img width="1845" alt="Screen Shot 2022-12-27 at 11 16 07" src="https://user-images.githubusercontent.com/24765473/209692805-beac74f7-9a92-4c96-a9a6-5936b9952d04.png">
<img width="1551" alt="Screen Shot 2022-12-27 at 11 18 04" src="https://user-images.githubusercontent.com/24765473/209693043-eb5b91e1-2217-401f-b6f1-c77152f56e8e.png">

## Anthos Service Mesh
- ASM 1.15.3 requires at elast 8 vCPU's spread across 1+ nodes - https://cloud.google.com/service-mesh/docs/unified-install/anthos-service-mesh-prerequisites

This lab provides you with a scenario related to application modernization. You have to gain an understanding of the architecture of a partially modernized traditional application and then go through the different parts of modernizing the application. First by migrating stand alone components of the application that are initially deployed as a monolithic service running on a virtual machine and secondly by developing a CI/CD deployment pipeline to deploy a native microservices versions of the application to Google Kubernetes Engine clusters.



Cymbal Bank is in the middle of migrating their legacy application to a microservices architecture. The current version of their application is accessed by connecting to the external IP address of the frontend service workload that is running in the cymbal-monolith-cluster Kubernetes Engine cluster.

This version of the application uses Kubernetes for some of the component services, including the frontend user interface, but a number of the backend components are still deployed as a traditional monolithic application along with a Postgres database running on a Compute Engine instance named ledgermonolith-service.

The source code for the legacy application Bank of Anthos will be downloaded from the GoogleCloudPlatform/bank-of-anthos Github repository. This will be what you use to transform into Cymbal Bank. The deployment files for the Cymbal Bank application, including the configuration for the monolithic ledger application, are in the kubernetes-manifests folder. The Kubernetes microservices are already deployed to the cymbal-monolith-cluster Kubernetes Engine cluster using these deployment manifests.

You are working with the Cymbal Bank team and your first task is to use Google Migrate to Containers to migrate the monolithic virtual machine application running on the ledgermonolith-service to the cymbal-monolith-cluster Kubernetes Engine and then reconfigure the application to redirect the Kubernetes microservices to use the migrated Kubernetes engine service for those microservices API calls rather than the calls to the external ledgermonolith-service virtual machine.

The existing microservices components of the application use a config map called service-api-config to hold the internal API service names, including those that initially point to the external ledgermonolith-service compute instance. When you have migrated the application compute instance you must modify this config map by editing the contents of the config.yaml file in the kubernetes-manifests folder, then redeploy it and restart all of the application pods.

You can find details on the structure of the application in the /src/ledgermonolith/README.md file in the source repository.

Your tasks
Refactor the workload from VMs to Containers

Migrate to Containers

CI/CD Pipeline Creation

Deploy application updates via CI/CD pipeline

Utilize application lifecycle management with Athos Service Mesh

Manage traffic with Anthos Service Mesh

Prerequisites
To best complete this challenge lab, you should be familiar with deploying and managing microservices with Kubernetes.

Here are some labs you can explore before taking this challenge to get familiar with above topics.
## Part 1
Part 1: Use Migrate to Containers to containerize a VM and migrate the application to Anthos/GKE
The GitHub repository GoogleCloudPlatform/bank-of-anthos contains the base source files and Kubernetes manifests used throughout this lab.
https://github.com/GoogleCloudPlatform/bank-of-anthos.git

## Task 1
Task 1. Create a Migrate to Containers processing cluster
Start the migration process by creating a single node processing cluster called m4a-processing in us-central1-a zone.

### Check that a processing cluster has been created

https://cloud.google.com/migrate/containers/docs/migctl-reference

```
export PROJECT_ID=$DEVSHELL_PROJECT_ID
export REGION=us-central1
export NETWORK=$REGION
export ZONE=$NETWORK-a
export VPC=$NETWORK-vpc
export SUBNET=$NETWORK-sn
export CIDR_VPC=192.168.0.0/16
export GKE_MONOLITH=cymbal-monolith-cluster
export GKE_DEV=cymbal-bank-dev
export GKE_PROD=cymbal-bank-prod

  echo "Create VPC: ${NETWORK}"
  gcloud compute networks create $NETWORK --subnet-mode=custom
  echo "Create subnet ${SUBNET} off VPC: ${NETWORK}"
  gcloud compute networks subnets create $SUBNET --network $NETWORK --range $CIDR_VPC --region $REGION
```


## Task 1B install GKE cluster

git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git

https://github.com/GoogleCloudPlatform/bank-of-anthos/tree/main/src/ledgermonolith
```
create GKE cluster

gcloud services enable container.googleapis.com monitoring.googleapis.com --project ${PROJECT_ID}

gcloud container clusters create-auto $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}

gcloud container clusters get-credentials $GKE_MONOLITH --project=${PROJECT_ID} --region=${REGION}

kubectl apply -f ./extras/jwt/jwt-secret.yaml
kubectl apply -f ./kubernetes-manifests

Verify DB already containerized
kubectl get service frontend | awk '{print $4}'
HTTPS


later edit kubernetes-manifest/config.yaml
service-api-config
```
### 20221229: autoscale autopilot cluster to create nodes and apply manifests


```
michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl apply -f ./extras/jwt/jwt-secret.yaml
secret/jwt-key created
michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl apply -f kubernetes-manifests/
accounts-db.yaml          config.yaml               frontend.yaml             ledger-writer.yaml        transaction-history.yaml
balance-reader.yaml       contacts.yaml             ledger-db.yaml            loadgenerator.yaml        userservice.yaml
michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl apply -f kubernetes-manifests/
Warning: Autopilot increased resource requests for StatefulSet default/accounts-db to meet requirements. See http://g.co/gke/autopilot-resources
statefulset.apps/accounts-db created


michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                                       READY   STATUS    RESTARTS   AGE
default       accounts-db-0                                              0/1     Pending   0          39s
default       balancereader-65987fd4d7-d4g8j                             0/1     Pending   0          39s
default       contacts-68944bf9d9-j6k27                                  0/1     Pending   0          39s
default       frontend-567d8948bf-g8rwt                                  0/1     Pending   0          38s
default       ledger-db-0                                                0/1     Pending   0          39s
default       ledgerwriter-8459f95c87-z5hfg                              0/1     Pending   0          38s
default       loadgenerator-67b974d4d6-5vwvj                             0/1     Pending   0          39s
default       transactionhistory-786b95bc65-h28vp                        0/1     Pending   0          38s
default       userservice-79bb6dcb5c-6gpqg                               0/1     Pending   0          38s
kube-system   antrea-controller-horizontal-autoscaler-655c5484c6-94xmr   0/1     Pending   0          16h


kubectl describe pod accounts-db-0

Events:
  Type     Reason            Age   From                                   Message
  ----     ------            ----  ----                                   -------
  Warning  FailedScheduling  63s   gke.io/optimize-utilization-scheduler  no nodes available to schedule pods
  Normal   TriggeredScaleUp  11s   cluster-autoscaler                     pod triggered scale-up: [{https://www.googleapis.com/compute/v1/projects/anthos-old/zones/us-central1-c/instanceGroups/gk3-cymbal-monolith-clus-nap-vdsf5bbh-ad6292dc-grp 0->1 (max: 1000)} {https://www.googleapis.com/compute/v1/projects/anthos-old/zones/us-central1-a/instanceGroups/gk3-cymbal-monolith-clus-nap-vdsf5bbh-b8721c97-grp 0->1 (max: 1000)} {https://www.googleapis.com/compute/v1/projects/anthos-old/zones/us-central1-b/instanceGroups/gk3-cymbal-monolith-clus-nap-vdsf5bbh-b1c1df5a-grp 0->1 (max: 1000)}]
michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl get nodes
NAME                                                  STATUS     ROLES    AGE   VERSION
gk3-cymbal-monolith-clus-nap-vdsf5bbh-ad6292dc-lrqh   NotReady   <none>   16s   v1.24.7-gke.900
gk3-cymbal-monolith-clus-nap-vdsf5bbh-b8721c97-sxxh   NotReady   <none>   8s    v1.24.7-gke.900

michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl get nodes
NAME                                                  STATUS   ROLES    AGE     VERSION
gk3-cymbal-monolith-clus-nap-vdsf5bbh-ad6292dc-lrqh   Ready    <none>   3m36s   v1.24.7-gke.900
gk3-cymbal-monolith-clus-nap-vdsf5bbh-b1c1df5a-rgbw   Ready    <none>   3m20s   v1.24.7-gke.900
gk3-cymbal-monolith-clus-nap-vdsf5bbh-b8721c97-sxxh   Ready    <none>   3m28s   v1.24.7-gke.900
michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                                       READY   STATUS    RESTARTS   AGE
default       accounts-db-0                                              1/1     Running   0          5m2s
default       balancereader-65987fd4d7-d4g8j                             0/1     Running   0          5m2s
default       contacts-68944bf9d9-j6k27                                  1/1     Running   0          5m2s
default       frontend-567d8948bf-g8rwt                                  1/1     Running   0          5m1s
default       ledger-db-0                                                1/1     Running   0          5m2s
default       ledgerwriter-8459f95c87-z5hfg                              1/1     Running   0          5m1s
default       loadgenerator-67b974d4d6-5vwvj                             1/1     Running   0          5m2s
default       transactionhistory-786b95bc65-h28vp                        0/1     Running   0          5m1s
default       userservice-79bb6dcb5c-6gpqg                               1/1     Running   0          5m1s
kube-system   anetd-jblf5                                                1/1     Running   0          3m22s
kube-system   anetd-nxf6j                                                1/1     Running   0          3m31s
kube-system   anetd-txrfj                                                1/1     Running   0          3m38s
kube-system   antrea-controller-horizontal-autoscaler-655c5484c6-94xmr   1/1     Running   0          16h
kube-system   egress-nat-controller-76cbb95965-vn4lh                     1/1     Running   0          16h
kube-system   event-exporter-gke-857959888b-92fmm                        2/2     Running   0          16h
kube-system   filestore-node-hk8jj                                       3/3     Running   0          3m30s
kube-system   filestore-node-jwgk4                                       3/3     Running   0          3m22s
kube-system   filestore-node-wrd2c                                       3/3     Running   0          3m38s
kube-system   fluentbit-gke-big-784qm                                    2/2     Running   0          3m38s
kube-system   fluentbit-gke-big-fqxwm                                    2/2     Running   0          3m30s
kube-system   fluentbit-gke-big-sklq6                                    2/2     Running   0          3m22s
kube-system   gke-metadata-server-6rprq                                  1/1     Running   0          3m29s
kube-system   gke-metadata-server-vswmp                                  1/1     Running   0          3m20s
kube-system   gke-metadata-server-xjdlj                                  1/1     Running   0          3m38s
kube-system   gke-metrics-agent-22wp6                                    1/1     Running   0          3m22s
kube-system   gke-metrics-agent-cvxvs                                    1/1     Running   0          3m30s
kube-system   gke-metrics-agent-n5t8p                                    1/1     Running   0          3m39s
kube-system   ip-masq-agent-22xbj                                        1/1     Running   0          3m20s
kube-system   ip-masq-agent-5l2r9                                        1/1     Running   0          3m29s
kube-system   ip-masq-agent-rlxlg                                        1/1     Running   0          3m37s
kube-system   konnectivity-agent-5b7f5697f9-jhrm6                        1/1     Running   0          16h
kube-system   konnectivity-agent-5b7f5697f9-qw8w5                        1/1     Running   0          16h
kube-system   konnectivity-agent-5b7f5697f9-vtzmm                        1/1     Running   0          2m5s
kube-system   konnectivity-agent-autoscaler-566966775b-xdjt4             1/1     Running   0          16h
kube-system   kube-dns-7d5998784c-2nwrm                                  4/4     Running   0          16h
kube-system   kube-dns-7d5998784c-r4xxh                                  4/4     Running   0          16h
kube-system   kube-dns-autoscaler-9f89698b6-9bd7n                        1/1     Running   0          16h
kube-system   l7-default-backend-6dc845c45d-6s2qp                        1/1     Running   0          16h
kube-system   metrics-server-v0.5.2-6bf845b67f-g2gr7                     2/2     Running   0          16h
kube-system   netd-cnj6j                                                 1/1     Running   0          3m30s
kube-system   netd-lxhtb                                                 1/1     Running   0          3m20s
kube-system   netd-t659t                                                 1/1     Running   0          3m37s
kube-system   node-local-dns-fcrb9                                       1/1     Running   0          3m38s
kube-system   node-local-dns-rj26c                                       1/1     Running   0          3m20s
kube-system   node-local-dns-sff9v                                       1/1     Running   0          3m29s
kube-system   pdcsi-node-59w7d                                           2/2     Running   0          3m30s
kube-system   pdcsi-node-bdbjl                                           2/2     Running   0          3m39s
kube-system   pdcsi-node-jmz8m                                           2/2     Running   0          3m22s

michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl get services --all-namespaces
NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)         AGE
default       accounts-db            ClusterIP      10.21.131.192   <none>         5432/TCP        7m10s
default       balancereader          ClusterIP      10.21.130.86    <none>         8080/TCP        7m10s
default       contacts               ClusterIP      10.21.130.113   <none>         8080/TCP        7m9s
default       frontend               LoadBalancer   10.21.130.202   34.27.62.222   80:31920/TCP    7m9s
default       kubernetes             ClusterIP      10.21.128.1     <none>         443/TCP         19h
default       ledger-db              ClusterIP      10.21.131.68    <none>         5432/TCP        7m8s
default       ledgerwriter           ClusterIP      10.21.129.141   <none>         8080/TCP        7m8s
default       transactionhistory     ClusterIP      10.21.131.159   <none>         8080/TCP        7m8s
default       userservice            ClusterIP      10.21.128.249   <none>         8080/TCP        7m7s
kube-system   antrea                 ClusterIP      10.21.130.226   <none>         443/TCP         19h
kube-system   default-http-backend   NodePort       10.21.130.169   <none>         80:30863/TCP    19h
kube-system   kube-dns               ClusterIP      10.21.128.10    <none>         53/UDP,53/TCP   19h
kube-system   kube-dns-upstream      ClusterIP      10.21.130.180   <none>         53/UDP,53/TCP   19h
kube-system   metrics-server         ClusterIP      10.21.129.247   <none>         443/TCP         19h


kubectl get service frontend | awk '{print $4}'

```
<img width="1571" alt="Screen Shot 2022-12-29 at 15 00 33" src="https://user-images.githubusercontent.com/24765473/210005830-2b614583-0883-48b2-961f-528711d39ebe.png">


<img width="1820" alt="Screen Shot 2022-12-29 at 14 57 19" src="https://user-images.githubusercontent.com/24765473/210005573-e8c080ad-9a4c-42cf-b5e2-e8f41b7cf889.png">

## Task 1C VM for migration
```
echo $PROJECT_ID

#gcloud compute  instances create   ledgermonolith-service  --zone=$ZONE --machine-type=e2-standard-2   --subnet=$SUBNET --scopes="cloud-platform"   --tags=http-server,https-server --image=ubuntu-minimal-1604-xenial-v20210119a   --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard   --boot-disk-device-name=ledgermonolith-service \
  --metadata startup-script='#! /bin/bash
  # Installs apache and a custom homepage
  sudo su -
  apt-get update
  apt-get install -y apache2
  cat <<EOF > /var/www/html/index.html
  <html><body><h1>Hello World</h1>
  <p>This page was created from a simple start up script!</p>
  </body></html>
  EOF'
  
#gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=$NETWORK --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

#stop vm

On the project allow all for 

And turn off the following IAM organizational policies at the project level

constraints/compute.requireShieldedVm
constraints/compute.vmExternalIpAccess
constraints/iam.disableServiceAccountKeyCreation


gcloud container clusters create m4a-processing --project=$PROJECT_ID --zone=$ZONE --machine-type e2-standard-4 --image-type ubuntu_containerd --num-nodes 1 --enable-stackdriver-kubernetes --network=$NETWORK --subnetwork=$SUBNET
```
## Task 2
Task 2. Initialize Migrate to Containers on the processing cluster
Enable the required Google Cloud APIs, create service accounts for the migration and initialize Migrate to Containers on the m4a-processing cluster.

```
gcloud iam service-accounts create m4a-install --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:m4a-install@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"

gcloud iam service-accounts keys create m4a-install.json --iam-account=m4a-install@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID

gcloud container clusters get-credentials m4a-processing --zone $ZONE

migctl setup install --json-key=m4a-install.json --gcp-project $PROJECT_ID --gcp-region $REGION

1 min - 3 times until only source status is red

migctl doctor
```
## Task 2b - VM creation
Cymbal Bank is in the middle of migrating their legacy application to a microservices architecture. The current version of their application is accessed by connecting to the external IP address of the frontend service workload that is running in the cymbal-monolith-cluster Kubernetes Engine cluster.

This version of the application uses Kubernetes for some of the component services, including the frontend user interface, but a number of the backend components are still deployed as a traditional monolithic application along with a Postgres database running on a Compute Engine instance named ledgermonolith-service.

The source code for the legacy application Bank of Anthos will be downloaded from the GoogleCloudPlatform/bank-of-anthos Github repository. This will be what you use to transform into Cymbal Bank. The deployment files for the Cymbal Bank application, including the configuration for the monolithic ledger application, are in the kubernetes-manifests folder. The Kubernetes microservices are already deployed to the cymbal-monolith-cluster Kubernetes Engine cluster using these deployment manifests.

You are working with the Cymbal Bank team and your first task is to use Google Migrate to Containers to migrate the monolithic virtual machine application running on the ledgermonolith-service to the cymbal-monolith-cluster Kubernetes Engine and then reconfigure the application to redirect the Kubernetes microservices to use the migrated Kubernetes engine service for those microservices API calls rather than the calls to the external ledgermonolith-service virtual machine.

The existing microservices components of the application use a config map called service-api-config to hold the internal API service names, including those that initially point to the external ledgermonolith-service compute instance. When you have migrated the application compute instance you must modify this config map by editing the contents of the config.yaml file in the kubernetes-manifests folder, then redeploy it and restart all of the application pods.

You can find details on the structure of the application in the /src/ledgermonolith/README.md file in the source repository.


deploy vm ledgermonolith-service
https://github.com/GoogleCloudPlatform/bank-of-anthos/tree/main/src/ledgermonolith

edit line 65 of the script to allow for non-default VPCs

```
gcloud compute instances create ledgermonolith-service \
    --project $PROJECT_ID \
    --zone $ZONE \
    --network $NETWORK \
    --subnet $SUBNET \
```

```
root_@cloudshell:~/bank-of-anthos/src/ledgermonolith/scripts (anthos-sgz)$ ./deploy-monolith.sh
PROJECT_ID: anthos-sgz
ZONE: us-central1-a
GCS_BUCKET not specified, defaulting to canonical pre-built artifacts...
GCS_BUCKET: bank-of-anthos-ci
Cleaning up VM if it already exists...
Creating GCE instance...
Created [https://www.googleapis.com/compute/v1/projects/anthos-sgz/zones/us-central1-a/instances/ledgermonolith-service].
NAME: ledgermonolith-service
ZONE: us-central1-a
MACHINE_TYPE: n1-standard-1
PREEMPTIBLE:
INTERNAL_IP: 10.128.0.10
EXTERNAL_IP: 34.68.236.156
STATUS: RUNNING
```


## Task 3
Task 3. Configure Migrate to Containers for Compute Engine migrations
Create a service account for Compute Engine source migrations and create a source on the m4a-processing cluster using the credentials for that service account.

```
gcloud iam service-accounts create m4a-ce-src --project=$PROJECT_ID
  
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.viewer"
  
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.storageAdmin"
  
gcloud iam service-accounts keys create m4a-ce-src.json --iam-account=m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID
  
cat m4a-ce-src.json

gcloud services enable cloudresourcemanager.googleapis.com

source the m4a-processing cluster

migctl source create ce ledgermonolith-service --project $PROJECT_ID --json-key=m4a-ce-src.json

migctl source list

all green

migctl doctor

```
https://cloud.google.com/migrate/containers/docs/migctl-reference#migctl-source

 stop vm ledgermonolith-service

<img width="523" alt="Screen Shot 2022-12-24 at 12 44 37" src="https://user-images.githubusercontent.com/24765473/209446467-a2c75711-1550-45f3-a762-cc3c788d4332.png">

## Task 4
Create a new Migrate to Containers migration job named ledgermonolith-migration for the Ledger Monolith compute instance.

Make sure that you stop the Ledger Monolith compute instance before starting the migration job.

create migration

```
migctl migration create ledgermonolith-migration --source ledgermonolith-service --vm-id ledgermonolith-service --type linux-system-container

migctl migration status ledgermonolith-migration

wait 6 min

root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS                STEP                    STATUS  AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateMigrationPlan   snapshot (0/100)        CreateSourceSnapshots   Running 25s
root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS        STEP            STATUS AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateMigrationPlan                   Discovery       Running50s
root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS        STEP                   STATUS           AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateMigrationPlan                   GenerateMigrationPlan  Completed        3m22s


```
<img width="1208" alt="Screen Shot 2022-12-24 at 12 49 50" src="https://user-images.githubusercontent.com/24765473/209446589-8ecbacd9-11f8-4916-92bc-9faaa3180cbc.png">

Migration completed

<img width="1215" alt="Screen Shot 2022-12-24 at 12 53 28" src="https://user-images.githubusercontent.com/24765473/209446674-9a471dd5-1856-4118-8c4e-faf1e419c3ef.png">

Get migration plan yaml
```

migctl migration get ledgermonolith-migration

-rw-r-----  1 root_ root_    538 Dec 24 17:54 ledgermonolith-migration.data.yaml
-rw-r-----  1 root_ root_   3171 Dec 24 17:58 ledgermonolith-migration.yaml

```
# Task 5
Task 5. Update and finalize the Migration Plan
When the Migrate to Containers migration plan completes its initial analysis, we need to make a slight change for the application to work correctly. Update the migration plan to add a data volume block that includes the folder /var/lib/postgresql.

https://cloud.google.com/migrate/containers/docs/customizing-a-migration-plan


edit the yaml (try the end)

```
dataVolumes:
  - folders:
    - /var/lib/postgresql
```

update the yaml
```

migctl migration update ledgermonolith-migration --file ledgermonolith-migration.yaml
```


## Task 6
Task 6. Generate the Migration artifacts
With the plan updated, generate and download the migration artifacts.

### Check that a Migrate to Containers migration task has completed successfully

6 min

```

migctl migration generate-artifacts ledgermonolith-migration

migctl migration status ledgermonolith-migration

root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS        STEP                   STATUS   AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts       N/A             GenerateArtifacts      Running  17m7s

root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS                        STEP                    STATUS  AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts       Extracting files (32309)        GenerateArtifacts       Running 18m10s
root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS                STEP                    STATUS  AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts       Uploading image (Done)  GenerateArtifacts       Running 21m47s
root_@cloudshell:~ (anthos-sgz)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS        STEP                   STATUS           AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts                       GenerateArtifacts      Completed        22m34s
```
<img width="1224" alt="Screen Shot 2022-12-24 at 13 00 07" src="https://user-images.githubusercontent.com/24765473/209446848-bf4fbfda-ba08-4a73-96c6-03e351ff26a6.png">

```

migctl migration get-artifacts ledgermonolith-migration

-rw-------  1 root_ root_     55 Dec 24 18:05 blocklist.yaml
-rw-------  1 root_ root_   2051 Dec 24 18:05 deployment_spec.yaml
-rw-------  1 root_ root_    831 Dec 24 18:05 Dockerfile
-rw-------  1 root_ root_     49 Dec 24 18:05 logs.yaml
-rw-------  1 root_ root_   3171 Dec 24 18:05 migration.yaml
-rw-------  1 root_ root_   2011 Dec 24 18:05 services-config.yaml
-rw-------  1 root_ root_    417 Dec 24 18:05 skaffold.yaml
-rw-------  1 root_ root_   7780 Dec 24 18:05 tempfiles.yaml

```
## Task 7
Task 7. Deploy the generated container artifacts to the Cymbal Bank cluster
Now that you have a containerized version of the ledgermonolith-service compute instance, deploy that new container to the `cymbal-monolith-cluster Kubernetes Engine Cluster.

```
(refactor)
add at the end of deployment_spec.yaml

apiVersion: v1
kind: Service
metadata:
  name: ledgermonolith-service
spec:
  selector:
    app: ledgermonolith-service
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
  
```

<img width="1215" alt="Screen Shot 2022-12-24 at 13 10 21" src="https://user-images.githubusercontent.com/24765473/209447144-093d619c-8af6-41fd-b9fc-c816ff4b8f84.png">

```
  
root_@cloudshell:~ (anthos-sgz)$ kubectl apply -f deployment_spec.yaml
deployment.apps/ledgermonolith-service created
service/ledgermonolith-service created
The Service "ledgermonolith-service" is invalid: spec.clusterIPs[0]: Invalid value: "None": may not be set to 'None' for LoadBalancer services
kubectl get service
```
<img width="1208" alt="Screen Shot 2022-12-24 at 13 14 57" src="https://user-images.githubusercontent.com/24765473/209447264-471f592a-4109-4db1-972e-5f85cc80839c.png">

```
commented out generated service
root_@cloudshell:~ (anthos-sgz)$ kubectl delete -f deployment_spec.yaml
deployment.apps "ledgermonolith-service" deleted
service "ledgermonolith-service" deleted
root_@cloudshell:~ (anthos-sgz)$ kubectl apply -f deployment_spec.yaml
deployment.apps/ledgermonolith-service created
service/ledgermonolith-service created


root_@cloudshell:~ (anthos-sgz)$ kubectl get service
NAME                     TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
kubernetes               ClusterIP      10.20.0.1    <none>          443/TCP        105m
ledgermonolith-service   LoadBalancer   10.20.2.25   34.172.138.99   80:32003/TCP   91s


20221229
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl apply -f deployment_spec.yaml
Warning: Autopilot set default resource requests for Deployment default/ledgermonolith-service, as resource requests were not specified. See http://g.co/gke/autopilot-defaults
deployment.apps/ledgermonolith-service created
service/ledgermonolith-service created

michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl get service
NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
accounts-db              ClusterIP      10.21.131.192   <none>         5432/TCP       16m
balancereader            ClusterIP      10.21.130.86    <none>         8080/TCP       16m
contacts                 ClusterIP      10.21.130.113   <none>         8080/TCP       16m
frontend                 LoadBalancer   10.21.130.202   34.27.62.222   80:31920/TCP   16m
kubernetes               ClusterIP      10.21.128.1     <none>         443/TCP        19h
ledger-db                ClusterIP      10.21.131.68    <none>         5432/TCP       16m
ledgermonolith-service   LoadBalancer   10.21.128.136   35.238.58.99   80:30554/TCP   66s
ledgerwriter             ClusterIP      10.21.129.141   <none>         8080/TCP       16m
transactionhistory       ClusterIP      10.21.131.159   <none>         8080/TCP       16m
userservice              ClusterIP      10.21.128.249   <none>         8080/TCP       16m



>  gcloud container clusters get-credentials cymbal-monolith-cluster --region us-central1 --project anthos-old \
>  && kubectl get service ledgermonolith-service -o yaml
Fetching cluster endpoint and auth data.
kubeconfig entry generated for cymbal-monolith-cluster.
apiVersion: v1
kind: Service
metadata:
  annotations:
    cloud.google.com/neg: '{"ingress":true}'
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"ledgermonolith-service","namespace":"default"},"spec":{"ports":[{"port":80,"protocol":"TCP","targetPort":80}],"selector":{"app":"ledgermonolith-service"},"type":"LoadBalancer"}}
  creationTimestamp: "2022-12-29T20:05:24Z"
  finalizers:
  - service.kubernetes.io/load-balancer-cleanup
  name: ledgermonolith-service
  namespace: default
  resourceVersion: "785763"
  uid: d40d1a0d-666a-4fce-bc3c-0b2b41896eaa
spec:
  allocateLoadBalancerNodePorts: true
  clusterIP: 10.21.128.136
  clusterIPs:
  - 10.21.128.136
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30554
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: ledgermonolith-service
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - ip: 35.238.58.99
```

postgres running
<img width="1831" alt="Screen Shot 2022-12-29 at 15 31 09" src="https://user-images.githubusercontent.com/24765473/210008311-770c02f9-f833-4724-83fc-ddfdc0375072.png">


TODO: deploy k8s side first

## Task 8
Task 8. Update the existing Kubernetes components to point to the new containerized ledger service
Update the config map manifest file so that the config map entries for the transactions, balance, and history APIs point to the internal ledgermonolith-service Kubernetes service rather than the fully qualified domain name for the ledgermonolith-service compute instance.


```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: service-api-config
data:
  # Use Google Compute Engine Internal DNS addresses for ledgermonolith services
  # https://cloud.google.com/compute/docs/internal-dns#instance-fully-qualified-domain-names
  TRANSACTIONS_API_ADDR: "ledgermonolith-service:8080"
  BALANCES_API_ADDR: "ledgermonolith-service:8080"
  HISTORY_API_ADDR: "ledgermonolith-service:8080"
  CONTACTS_API_ADDR: "contacts:8080"
  USERSERVICE_API_ADDR: "userservice:8080"

```
Redeploy the config map and stop all pods. The pods will restart and configure themselves with the new config map values. If the migration has been successful the Cymbal Bank application will be fully functional using the migrated service.

### Check that the Cymbal Bank Monolith VM has been migrated and the application updated to use the migrated container.

## Part 2
Part 2: Create CI/CD Pipelines for Production and Development
Build a deployment pipeline for this application
The pipeline should re-deploy the kubernetes manifests for the application when changes are pushed to the source repository
Configure the necessary monitoring for uptime, response times, and resources utilization to manage this application on GCP
This part of the lab challenges you to create an automated CI/CD pipeline with two Cloud Build pipelines triggered when updates are pushed to the main branch, and a development branch of a Google Cloud Source Repository for Cymbal bank.

Create a Google Cloud Source Repository and push a copy of the below source code into your repo. Then create two continuous deployment pipelines using updates to your repository to trigger deployments to a production cluster for commits to the main branch, and deployments to a development cluster for commits to a development branch.

Deploy two clusters, cymbal-bank-prod and cymbal-bank-dev, both in the us-central1-a zone. Both clusters should be limited to two nodes in order to conserve resource utilization however you must also make sure that the clusters have sufficient resources to support the Anthos Service Mesh deployment required in Part 3.

The GitHub repository GoogleCloudPlatform/bank-of-anthos contains the base source files and Kubernetes manifests used throughout this lab.
https://github.com/GoogleCloudPlatform/bank-of-anthos.git

Note: Previous versions of this lab used different source repositories for the first and second parts of the lab. This is no longer the case.
## Task 9
Task 9. Create a Cloud Source Repository for Cymbal Bank
Create a Google Cloud source repository called cymbal-bank-repo. Clone the Bank of Anthos original repo from https://github.com/GoogleCloudPlatform/bank-of-anthos.git, and then add your repository as a remote and push your local repository into that remote.
### Check that a Cloud source Repository called cymbal-bank-repo has been created in your project.

https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes

## Task 10
Task 10. Deploy a Kubernetes Engine Cluster for Cymbal Bank production code
Deploy a two node Kubernetes Engine Cluster called cymbal-bank-prod in us-central1-a. This cluster will need to be compatible with Anthos Service Mesh so you must make sure the nodes have sufficient resources.
Before you deploy the application to production you must modify the /kubernetes-manifests/frontend.yaml manifest file to include the labels identifying this as version 1 as shown below:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    version: v1
spec:
  selector:
    matchLabels:
      app: frontend
      version: v1
  template:
    metadata:
      labels:
        app: frontend
        version: v1

```
After deploying the cluster, you should test that you can manually deploy the application using the Kubernetes manifest files in the /kubernetes-manifests directory of your repository. Note that the application also requires that a Kubernetes secret defined in the /extras/jwt/jwt-secret.yaml manifest file is deployed.

Note: If the secret is not available, most of the application containers will be unable to start.

### Check that a Kubernetes Engine cluster called cymbal-bank-prod has been created

### Deploy 2node GKE prod

```
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export CLUSTER_NAME=cymbal-bank-prod
export CLUSTER_ZONE=$ZONE
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"

gcloud config set compute/zone ${CLUSTER_ZONE}
gcloud beta container clusters create ${CLUSTER_NAME} \
    --machine-type=n1-standard-4 \
    --num-nodes=2 \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --network=$NETWORK \
    --subnetwork=$SUBNET \
    --release-channel=regular \
    --labels mesh_id=${MESH_ID}

5 min

kubectl create clusterrolebinding cluster-admin-binding  --clusterrole=cluster-admin  --user=root@staging.gcp.zone

curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli

chmod +x asmcli

./asmcli validate \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output
  
  ./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output \
  --enable_all \
  --option legacy-default-ingressgateway \
  --ca mesh_ca \
  --enable_gcp_components

2 min

GATEWAY_NS=istio-gateway

kubectl create namespace $GATEWAY_NS

REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')

kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite

```
git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git

https://github.com/GoogleCloudPlatform/bank-of-anthos#quickstart-gke


```
apply labels

+++ b/kubernetes-manifests/frontend.yaml
@@ -17,14 +17,18 @@ apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: frontend
+  labels:
+    version: v1
 spec:
   selector:
     matchLabels:
       app: frontend
+      version: v1
   template:
     metadata:
       labels:
         app: frontend
+        version: v1
     spec:
       serviceAccountName: default
       terminationGracePeriodSeconds: 5
       

on spec: selector: matchLabels:

michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl apply -f kubernetes-manifests/frontend.yaml
Warning: Autopilot increased resource requests for Deployment default/frontend to meet requirements. See http://g.co/gke/autopilot-resources
service/frontend unchanged
The Deployment "frontend" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app":"frontend", "version":"v1"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable


use instead
+++ b/kubernetes-manifests/frontend.yaml
@@ -17,6 +17,8 @@ apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: frontend
+  labels:
+    version: v1
 spec:
   selector:
     matchLabels:
@@ -25,6 +27,7 @@ spec:
     metadata:
       labels:
         app: frontend
+        version: v1
     spec:
       serviceAccountName: default

michael@cloudshell:~/anthos-old/bank-of-anthos (anthos-old)$ kubectl apply -f kubernetes-manifests/frontend.yaml
Warning: Autopilot increased resource requests for Deployment default/frontend to meet requirements. See http://g.co/gke/autopilot-resources
deployment.apps/frontend configured
service/frontend unchanged


manually deploy to test

root_@cloudshell:~/bank-of-anthos (anthos-sgz)$ cd extras/jwt/
root_@cloudshell:~/bank-of-anthos/extras/jwt (anthos-sgz)$ kubectl apply -f jwt-secret.yaml
secret/jwt-key created

cd ../../
kubectl apply -f ./kubernetes-manifests/

1 min

kubectl get service frontend | awk '{print $4}'
EXTERNAL-IP
35.184.5.165
```

<img width="1188" alt="Screen Shot 2022-12-24 at 09 42 32" src="https://user-images.githubusercontent.com/24765473/209441010-996080bb-5a31-4d66-af1c-668b7b0cdf5b.png">

```
delete the deployment
kubectl delete -f ./kubernetes-manifests/
kubectl delete -f ./extras/jwt/jwt-secret.yaml

```


## Task 11
Task 11. Create a Cloud Build template and trigger for deployment to the production cluster
You must ensure that the Cloud Build Service Account has been bound to the roles/container.admin role in your project.

Note: If you are facing any issues while adding IAM policy binding, please disable and re-enable the Cloud Build API.
Create a Cloud Build YAML template file that deploys all of the Kubernetes manifests to the cymbal-bank-prod Kubernetes Engine Cluster using a Cloud Build gcr.io/cloud-builders/kubectl step, and then use the same component to delete all pods to force the redeployment to reinitialize all of the component services.

When you have the Cloud Build template defined, create a global (non-regional) Cloud Build Trigger that is fired whenever there's a push to the main branch for your repository.

Trigger the production pipeline by making a git commit and git push to the main branch.

#### Cloud Build using deploy-gke

https://cloud.google.com/build/docs/deploying-builds/deploy-gke
https://github.com/GoogleCloudPlatform/cloud-builders/tree/master/gke-deploy

Add CB service account permissions

```
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUD_BUILD_SA" --role="roles/container.developer" --quiet > /dev/null 1>&1
```

<img width="601" alt="Screen Shot 2022-12-29 at 23 51 59" src="https://user-images.githubusercontent.com/24765473/210035750-2cbc2125-0c71-462e-84d4-5cd842cf6ac7.png">

<img width="1202" alt="Screen Shot 2022-12-29 at 23 52 15" src="https://user-images.githubusercontent.com/24765473/210035759-b0c14aa0-3b39-4b95-bc63-4c4876b65b02.png">

#### global build trigger
copy cloudbuild.yaml into the bank repository
```
  gcloud beta builds triggers create cloud-source-repositories --repo=$CSR_NAME --branch-pattern=main --build-config=cloudbuild.yaml
```
<img width="1329" alt="Screen Shot 2022-12-30 at 09 31 17" src="https://user-images.githubusercontent.com/24765473/210081249-024fddfc-a3f1-4814-841c-b47a3c383f95.png">

fix
<img width="1812" alt="Screen Shot 2022-12-30 at 10 53 07" src="https://user-images.githubusercontent.com/24765473/210088719-b64f5eb4-4309-4af0-b54b-eada2ae714c5.png">

```
Error: failed to prepare deployment: failed to save suggested configuration files to "output/suggested": output directory "output/suggested" exists and is not empty
```
with
https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/gke-deploy/doc/gke-deploy_run.md#options

```
        - --output=output1
```

cloudbuild.yaml
```
steps:
      # deploy container image to GKE
      # https://cloud.google.com/build/docs/deploying-builds/deploy-gke#yaml
  - name: "gcr.io/cloud-builders/gke-deploy"
    args:
        - run
        - --filename=extras/jwt/jwt-secret.yaml
        - --location=us-central1-a
        - --cluster=cymbal-bank-dev
        - --output=output1
  - name: "gcr.io/cloud-builders/gke-deploy"
    args:
      - run
      - --filename=kubernetes-manifests
      - --location=us-central1-a
      - --cluster=cymbal-bank-dev
      - --output=output2
```
<img width="1819" alt="Screen Shot 2022-12-30 at 10 56 45" src="https://user-images.githubusercontent.com/24765473/210089053-febf407f-12f0-4259-b300-97d5ed8a4746.png">

### Check that Bank of Anthos has been deployed to the production cluster with a Cloud Build pipeline.

## Task 12
Task 12. Deploy a Kubernetes Engine Cluster for Cymbal Bank development code
Now that you have a production instance deployed, proceed in deploying a development instance.

Deploy another two node Kubernetes Engine Cluster called cymbal-bank-dev in us-central1-a and manually deploy an initial version of the Bank of Anthos application to ensure it is working correctly. Use stable channel and set Control plane version to 1.23. This cluster will also need to be compatible with Anthos Service Mesh so you must make sure the nodes have sufficient resources.

Manually deploy version to dev


### Check that a Kubernetes Engine cluster called cymbal-bank-dev has been created

## Task 13
Task 13. Create a Cloud Build template and trigger for deployment to the development cluster
Create a Cloud Build YAML template file that deploys all of the Kubernetes manifests to the cymbal-bank-dev Kubernetes Engine Cluster. This pipeline should be triggered whenever there's a push to the new dev branch in your repository.

Cloud Build Trigger should be created in global (non-regional) region.
Create a new branch called cymbal-dev. In this branch, modify the Bank of Anthos application to display the new Cymbal Bank logo in the header. This is done by uncommenting the "CYMBAL_LOGO" env variable defined in /kubernetes-manifests/frontend.yaml and changing its value (on the next line) from "false" to "true".

Also, you must also modify the /kubernetes-manifests/frontend.yaml manifest file to include the labels identifying this as version 2 as shown below:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    version: v2
spec:
  selector:
    matchLabels:
      app: frontend
      version: v2
  template:
    metadata:
      labels:
        app: frontend
        version: v2
.

        - name: CYMBAL_LOGO
          value: "true"

```

Trigger the development pipeline by making a git commit with the updated frontend.yaml file and then push that commit to the cymbal-dev branch.

You should now have two versions of the application deployed on separate clusters:

The original production version of the application, that displays Bank of Anthos in the header when you connect to the frontend service IP address on the production cluster.
The development version, that displays Cymbal Bank in the header when you connect to the frontend service IP address on the development cluster.

work:
- note the issue with spec: selector: matchLabels (omit version: v2)
```
   Create branch cymbal-dev
   git branch $BRANCH_DEV
   git push -u google $BRANCH_DEV
```



### Check that Cymbal Bank has been deployed to the development cluster with a Cloud Build pipeline.

## Task 14
Part 3: Deploy and Configure Anthos Service Mesh
Deploy Anthos Service Mesh v1.14
Configure ASM virtual services to distribute traffic between prod and dev builds
In this part of the challenge you must install and configure Anthos Service Mesh on both clusters, enabling sidecar injection for the namespaces where your production and development versions of the application are deployed.

When ASM is installed you must configure an Istio Ingress Gateway called istio-ingressgateway and virtual services called frontend-ingress to distribute traffic between your production and development application instances running on two separate clusters. Your final task is then to enable fine-grained control of the traffic distribution by enabling weighted traffic distribution, sending 75% of traffic to the production frontend and 25% to the development cluster frontend to simulate a manual blue green deployment.

Note: Part 3 requires the work done in Part 2 to be completed as a precondition and uses the same source repository as Part 2.

Task 14. Install Anthos Service Mesh onto the production cluster
Install Anthos Service Mesh v1.14 onto the production cluster.

### Check that ASM has been deployed to cymbal-bank-prod.
20221224 - 1.15.3-asm.6 works

```
install_asm() {
  # install asm on GKE
  curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli
  chmod +x asmcli
  echo "validate $GKE_CLUSTER"
  # gcloud services enable mesh.googleapis.com
  # gcloud services enable anthos.googleapis.com
  # may need to run and then comment validate
  #./asmcli validate --project_id $PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $PROJECT_ID --output_dir ./asm_output
  
  echo "install $GKE_CLUSTER"
  ./asmcli install --project_id $PROJECT_ID --cluster_name $GKE_CLUSTER --cluster_location $ZONE --fleet_id $PROJECT_ID --output_dir ./asm_output --enable_all --option legacy-default-ingressgateway --ca mesh_ca --enable_gcp_components
  GATEWAY_NS=istio-gateway
  gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
  kubectl create namespace $GATEWAY_NS
  kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'
  REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')
  echo "REVISION: $REVISION"
  kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite
  #kubectl apply -n $GATEWAY_NS -f samples/gateways/istio-ingressgateway
  #kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f asm_output/istio-1.15.3-asm.6/samples/bookinfo/networking/bookinfo-gateway.yaml
  kubectl get gateway
  # full json
  #kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={}
  kubectl get svc -n istio-system istio-ingressgateway 
  # extract ip from "type":"LoadBalancer"},"status":{"loadBalancer":{"ingress":[{"ip":"34.133.99.17"} 
  INGRESS_IP=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  echo "sleep 60s - wait for EXTERNAL-IP"
  sleep 60
  kubectl get svc -n istio-system istio-ingressgateway 
  INGRESS_IP=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}'{"\n"}')
  echo "ingress IP: $INGRESS_IP"
  curl -I http://${INGRESS_IP}/productpage
  #sudo apt install siege siege http://${INGRESS_IP}/productpage
  
}
```

## Task 15
Task 15. Configure namespace labels for sidecar injection in the production cluster
Ensure that the namespace used for your deployments in Part 2 is correctly labelled for Istio sidecar injection. All namespaces that required sidecar injection must have an istio.io/rev label that matches the installed Anthos Service Mesh version.

### Check that Kubernetes Namespaces are correctly labelled for ASM in the cymbal-bank-prod cluster.


https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/

"When you set the istio-injection=enabled label on a namespace and the injection webhook is enabled, any new pods that are created in that namespace will automatically have a sidecar added to them."

```
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ gcloud container clusters get-credentials $GKE_DEV --zone $ZONE
Fetching cluster endpoint and auth data.
kubeconfig entry generated for cymbal-bank-dev.
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl get ns
NAME              STATUS   AGE
asm-system        Active   35m
default           Active   39m
istio-gateway     Active   35m
istio-system      Active   36m
kube-node-lease   Active   39m
kube-public       Active   39m
kube-system       Active   39m
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE
details-v1-698b5d8c98-xcvkd      1/1     Running   0          35m
productpage-v1-bf4b489d8-49k9w   1/1     Running   0          35m
ratings-v1-5967f59c58-tlg69      1/1     Running   0          35m
reviews-v1-9c6bb6658-4h5gz       1/1     Running   0          35m
reviews-v2-8454bb78d8-mnkqc      1/1     Running   0          35m
reviews-v3-6dc9897554-q46km      1/1     Running   0          35m
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl label namespace default istio-injection=enabled --overwrite
namespace/default labeled
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl get namespace -L istio-injection
NAME              STATUS   AGE   ISTIO-INJECTION
asm-system        Active   36m
default           Active   40m   enabled
istio-gateway     Active   36m
istio-system      Active   38m
kube-node-lease   Active   40m
kube-public       Active   41m
kube-system       Active   41m
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl delete pod -l app=productpage
pod "productpage-v1-bf4b489d8-49k9w" deleted
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE
details-v1-698b5d8c98-xcvkd      1/1     Running   0          37m
productpage-v1-bf4b489d8-89h2r   2/2     Running   0          7s
ratings-v1-5967f59c58-tlg69      1/1     Running   0          37m
reviews-v1-9c6bb6658-4h5gz       1/1     Running   0          37m
reviews-v2-8454bb78d8-mnkqc      1/1     Running   0          37m
reviews-v3-6dc9897554-q46km      1/1     Running   0          37m

into
istio_injection() {
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
    kubectl delete pod -l app=productpage
    # display 2/2 sidecars
    echo "sleep 20s before checking for 2/2 injected sidecars"
    sleep 20
    kubectl get pods | grep 2/2
}

```

## Task 16
Task 16. Install Anthos Service Mesh onto the development cluster
```
see task 14
```

Repeat the Anthos Service Mesh installation and namespace configuration steps for the development cluster.

### Check that ASM has been deployed to cymbal-bank-dev.
### Check that Kubernetes Namespaces are correctly labelled for ASM in the cymbal-bank-dev cluster.


## Task 17
Task 17. Ensure that you have a firewall rule that allows Istio traffic between clusters

Create a firewall rule called allow-istio that allows Istio service discovery and control plane traffic between your production and development clusters.

Note: If you do not create this rule, the Istio control plane will not be able to manage cross cluster service discovery and traffic routing.

### work

https://istio.io/latest/docs/setup/platform-setup/gke/#multi-cluster-communication

```
TBV
function join_by { local IFS="$1"; shift; echo "$*"; }
ALL_CLUSTER_CIDRS=$(gcloud --project $PROJECT_ID container clusters list --format='value(clusterIpv4Cidr)' | sort | uniq)
ALL_CLUSTER_CIDRS=$(join_by , $(echo "${ALL_CLUSTER_CIDRS}"))
ALL_CLUSTER_NETTAGS=$(gcloud --project $PROJECT_ID compute instances list --format='value(tags.items.[0])' | sort | uniq)
ALL_CLUSTER_NETTAGS=$(join_by , $(echo "${ALL_CLUSTER_NETTAGS}"))

gcloud compute firewall-rules create allow-istio --allow=tcp,udp,icmp,esp,ah,sctp --direction=INGRESS --priority=900 --source-ranges="${ALL_CLUSTER_CIDRS}" --target-tags="${ALL_CLUSTER_NETTAGS}" --quiet
```


4 optional
## Task 18
Task 18. Create and apply remote secrets for both clusters

Create Istio remote-secrets for each cluster and apply to the remote cluster. These mutual secrets allow the control plane on the production cluster to perform service discovery and other tasks on the development cluster and vice-versa.

### work
dev to prod
https://istio.io/latest/docs/setup/install/multicluster/primary-remote_multi-network/#attach-cluster2-as-a-remote-cluster-of-cluster1
```
TBV
istioctl x create-remote-secret --context="${DEV}" --name=dev | kubectl apply -f - --context="${PROD}"
```

## Task 19
Task 19. Restart all pods to trigger sidecar injection

### Check that all pods have been restarted and sidecar injection has been triggered.

see task 15
worst case - add sidecar injection directly on separate gke cluster
```
    # check namespace labeling
    kubectl get namespace -L istio-injection
    # bounce pods - to get them istio injected with sidecars
    kubectl delete pod -l app=productpage
    # display 2/2 sidecars
    echo "sleep 20s before checking for 2/2 injected sidecars"
    sleep 20
    kubectl get pods | grep 2/2
```


## Task 20
Task 20. Create and deploy an Istio Gateway and Virtual Service on the production cluster

ou must first create a dedicated namespace for the Istio Ingress gateway on the production cluster called gateway-namespace and then deploy an Istio ingress gateway called istio-ingressgateway on the production cluster.

You can use the sample Istio Ingress gateway configuration from the Istio output directory in the /samples directory if you specified an output directory when installing ASM. Alternatively you can also find these manifest files in the Anthos Service Mesh - Gateway Samples repository.

https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages/tree/main/samples/gateways

This sample manifest creates an Istio ingress load balancer called istio-ingressgateway.

Once you have the Istio Ingress gateway created enable traffic management and load balancing across clusters using the sample Virtual Service manifest included in the Bank of Anthos repository file ./istio-manifests/frontend-ingress.yaml as your template.

Once the ingress gateway and virtual service have been deployed to the production cluster you should be able to connect to the external IP-address of the gateway to see traffic being redirected between the production and development versions of the application as you refresh the page.

```
export GATEWAY_URL=$(kubectl get svc istio-ingressgateway \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n gateway-namespace)
echo Istio Gateway Load Balancer: http://$GATEWAY_URL
```
work

deploy virt service on prod
```
gcloud container clusters get-credentials $GKE_PROD --zone $ZONE
kubectl apply -f istio-manifests/frontend-ingress.yaml
```


### Check that the istio ingress has been created and is routing traffic to the applications.


## Task 21
Task 21. Update the Istio virtual service definition to rebalance frontend traffic between production and development

Create a Destination rule set that defines Istio subsets for v1 (production) and v2 (development) traffic. If you labelled your production frontend deployment manifest files with version=v1 and development frontend deployment manifest files with version=v2 labels as you were instructed in Part 2, you can use these labels to define two subsets for your destination rule.

Configure your VirtualService to distribute 75% of traffic to the production cluster (v1 frontend) and 25% of traffic to the development cluster (v2 frontend).

### Check that the istio ingress has been updated to route traffic 75% to production and 25% to development.


# migrate VM to containers
part of VM Migration quest 87
focuses 14780
https://www.cloudskillsboost.google/focuses/10268?catalog_rank=%7B%22rank%22%3A1%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=20701606

https://cloud.google.com/migrate/containers/docs


## 20221205:1120

```
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ export PROJECT_ID=$DEVSHELL_PROJECT_ID
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ echo $PROJECT_ID
qwiklabs-gcp-02-c401447d30f9
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ export PROJECT_ID=$DEVSHELL_PROJECT_ID
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ echo $PROJECT_ID
qwiklabs-gcp-02-c401447d30f9

gcloud compute  instances create   source-vm  --zone=us-east1-d --machine-type=e2-standard-2   --subnet=default --scopes="cloud-platform"   --tags=http-server,https-server --image=ubuntu-minimal-1604-xenial-v20210119a   --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard   --boot-disk-device-name=source-vm \
  --metadata startup-script='#! /bin/bash
  # Installs apache and a custom homepage
  sudo su -
  apt-get update
  apt-get install -y apache2
  cat <<EOF > /var/www/html/index.html
  <html><body><h1>Hello World</h1>
  <p>This page was created from a simple start up script!</p>
  </body></html>
  EOF'


gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW   --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server


34.148.134.148




stop vm
1125 - will take 20 min ~ 1145
gcloud container clusters create migration-processing   --project=$PROJECT_ID --zone=us-east1-d --machine-type e2-standard-4   --image-type ubuntu_containerd --num-nodes 3 --enable-stackdriver-kubernetes   --subnetwork "projects/$PROJECT_ID/regions/us-east1/subnetworks/default"

```
```
1131 - 7 min
Creating cluster migration-processing in us-east1-d... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1/projects/qwiklabs-gcp-02-c401447d30f9/zones/us-east1-d/clusters/migration-processing].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-east1-d/migration-processing?project=qwiklabs-gcp-02-c401447d30f9
kubeconfig entry generated for migration-processing.
NAME: migration-processing
LOCATION: us-east1-d
MASTER_VERSION: 1.23.12-gke.100
MASTER_IP: 35.237.104.251
MACHINE_TYPE: e2-standard-4
NODE_VERSION: 1.23.12-gke.100
NUM_NODES: 3
STATUS: RUNNING

```

```
gcloud iam service-accounts create m4a-install \
  --project=$PROJECT_ID
  
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:m4a-install@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud iam service-accounts keys create m4a-install.json \
  --iam-account=m4a-install@$PROJECT_ID.iam.gserviceaccount.com \
  --project=$PROJECT_ID

gcloud container clusters get-credentials migration-processing   --zone us-east1-d

migctl setup install --json-key=m4a-install.json --gcp-project $PROJECT_ID --gcp-region us-east1

1 min

migctl doctor

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl doctor
[✗] Deployment
    [✓] Version
    [✗] Components
        deployment.apps/controllers-controller-manager is InProgress: Available: 0/1
        statefulset.apps/csi-vlsdisk-controller is InProgress: Ready: 0/1
        statefulset.apps/v2k-generic-csi-controller is InProgress: Ready: 0/1
        daemonset.apps/csi-vlsdisk-node is InProgress: Available: 0/3
        daemonset.apps/runtime-deploy-node is InProgress: Available: 1/3
        daemonset.apps/v2k-generic-csi-node is InProgress: Available: 0/3
[✓] Docker Registry
[!] Artifacts Repository
    [!] gcs-qwiklabs-gcp-02-c401447d30f9-migration-artifacts [default]
        Health information is out of date
[✗] Source Status
    No source was configured. Use 'migctl source create' to define one.
[!] Default storage class
    Warning: the default storage class is: standard.
    - We recommend to use one of the following storage classes instead: premium-rwo, standard-rwo.
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$


wait 1 minute

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl doctor
[✓] Deployment
[✓] Docker Registry
[✓] Artifacts Repository
[✗] Source Status
    No source was configured. Use 'migctl source create' to define one.
[!] Default storage class
    Warning: the default storage class is: standard.
    - We recommend to use one of the following storage classes instead: premium-rwo, standard-rwo.
    
```


```
gcloud iam service-accounts create m4a-ce-src \
  --project=$PROJECT_ID
  
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.viewer"
  
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.storageAdmin"
  
gcloud iam service-accounts keys create m4a-ce-src.json \
  --iam-account=m4a-ce-src@$PROJECT_ID.iam.gserviceaccount.com \
  --project=$PROJECT_ID
  
reated key [67cf5701bd88b9a6f8c9e85d392c34c1cb2b81d5] of type [json] as [m4a-ce-src.json] for [m4a-ce-src@qwiklabs-gcp-02-c401447d30f9.iam.gserviceaccount.com]

tudent_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ cat m4a-ce-src.json
{
  "type": "service_account",
  "project_id": "qwiklabs-gcp-02-c401447d30f9",
  ,
  "client_email": "m4a-ce-src@qwiklabs-gcp-02-c401447d30f9.iam.gserviceaccount.com",
  "client_id": "104383216582339269047",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/m4a-ce-src%40qwiklabs-gcp-02-c401447d30f9.iam.gserviceaccount.com"
}
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$


migctl source create ce source-vm --project $PROJECT_ID --json-key=m4a-ce-src.json


Waiting for Source status  
Source source-vm was created successfully.


student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl doctor
[✓] Deployment
[✓] Docker Registry
[✓] Artifacts Repository
[✓] Source Status
[!] Default storage class
    Warning: the default storage class is: standard.
    - We recommend to use one of the following storage classes instead: premium-rwo, standard-rwo.
    
migctl migration create my-migration --source source-vm   --vm-id source-vm --type linux-system-container

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS        STEP            STATUS  AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateMigrationPlan   [3/3]           Discovery       Running 26s

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration get my-migration
Error: Migration plan is not ready yet. please use 'migctl migration status' to verify that Migration plan generation is done


1142
wait 1 min

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration get my-migration
Migration main configuration yaml 'my-migration.yaml' created
Migration data configuration yaml 'my-migration.data.yaml' created

1147
tudent_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration generate-artifacts my-migration
Generate Artifacts task started for Migration my-migration. Run `migctl migration status my-migration` to see its status.

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS        STEP                    STATUS  AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateArtifacts       N/A             GenerateArtifacts       Running 5m58s

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS                        STEP                    STATUS  AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateArtifacts       Extracting files (32972)        GenerateArtifacts       Running 6m35s

tudent_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS                        STEP                    STATUS  AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateArtifacts       Extracting files (73992)        GenerateArtifacts       Running 7m21s

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS                STEP                    STATUS  AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateArtifacts       Uploading image (Done)  GenerateArtifacts       Running 8m4s

tudent_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration status my-migration
NAME            TYPE                    SOURCE                  CURRENT-OPERATION       PROGRESS        STEP                    STATUS          AGE
my-migration    linux-system-container  gcp: "source-vm"        GenerateArtifacts                       GenerateArtifacts       Completed       8m20s


1152 (25 remaining)

student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ migctl migration get-artifacts my-migration
Downloaded artifacts for Migration my-migration. The artifacts are located in "/home/student_03_8a645e82ba43".


add at the end of deployment_spec.yaml

apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: source-vm
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
  
  
student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ kubectl apply -f deployment_spec.yaml
deployment.apps/source-vm created
service/source-vm created
service/my-service created


student_03_8a645e82ba43@cloudshell:~ (qwiklabs-gcp-02-c401447d30f9)$ kubectl get service
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
kubernetes   ClusterIP      10.32.0.1     <none>          443/TCP        27m
my-service   LoadBalancer   10.32.0.175   34.139.208.42   80:31163/TCP   37s
source-vm    ClusterIP      None          <none>          <none>         37s

ok
http://34.139.208.42/
```
# Working with Cloud Build
focuses 14659

## 20221217


```
nano quickstart.sh

#!/bin/sh
echo "Hello, world! The time is $(date)."

nano Dockerfile

FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]

chmod +x quickstart.sh

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Cloud_Build/a

cat cloudbuild.yaml

gcloud builds submit --config cloudbuild.yaml .

cd ~/ak8s/Cloud_Build/b

gcloud builds submit --config cloudbuild.yaml .


```


# Installing Anthos Service Mesh on GKE
focuses 

## 20221218

```
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-west1-c
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"


gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --filter="bindings.members:user:$(gcloud config get-value core/account 2>/dev/null)"
    
    
gcloud config set compute/zone ${CLUSTER_ZONE}
gcloud beta container clusters create ${CLUSTER_NAME} \
    --machine-type=n1-standard-4 \
    --num-nodes=4 \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --subnetwork=default \
    --release-channel=regular \
    --labels mesh_id=${MESH_ID}
    
    
    5-15 min :25-32

kubectl create clusterrolebinding cluster-admin-binding   --clusterrole=cluster-admin   --user=$(whoami)@qwiklabs.net

 - check version
curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > asmcli

chmod +x asmcli

./asmcli validate \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output
  
asmcli: [WARNING]: API not enabled - meshca.googleapis.com,stackdriver.googleapis.com,gkehub.googleapis.com,gkeconnect.googleapis.com,meshconfig.googleapis.com
asmcli: [ERROR]: One or more APIs are not enabled. Please enable them and retry, or run the
script with the '--enable_gcp_apis' flag to allow the script to enable them on
your behalf.

smcli: Checking for project qwiklabs-gcp-.....
asmcli: Reading labels for us-west1-c/central...
asmcli: [ERROR]: Current user must have the cluster-admin role on central.
Please add the cluster role binding and retry, or run the script with the
'--enable_cluster_roles' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.

asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: The istio-system namespace doesn't exist.
Please create the "istio-system" and retry, or run the script with the
'--enable_namespace_creation' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.

asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.

ignore all above - just install anthos

./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output \
  --enable_all \
  --option legacy-default-ingressgateway \
  --ca mesh_ca \
  --enable_gcp_components
  
  
  asmcli: Creating istio-system namespace...
namespace/istio-system created
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.

```

https://cloud.google.com/service-mesh/docs/managed/provision-managed-anthos-service-mesh-asmcli

GKE Autopilot is only supported with GKE version 1.21.3+. CNI will be installed and managed by Google.
A) we are running 1.24.5-gke.600

try 1.15

```
curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli

fetching package "/asm" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "asm"
fetching package "/samples" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "samples"
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to qwiklabs-gcp-03-78c27d976d1c
asmcli: Checking required APIs...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to qwiklabs-gcp-03-78c27d976d1c
asmcli: Checking for project qwiklabs-gcp-03-78c27d976d1c...
asmcli: Reading labels for us-west1-c/central...
asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.

asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.

```

installing anthos service mesh via console

enable $800 30d trial

use autopilot
enable service mesh

```
Changes needed
You have selected:
Enable Anthos Service Mesh 

Learn more about ASM pricing.
Impacts:
To enable Anthos Service Mesh, some changes are needed in the cluster configuration. Learn more
These changes will enable increased security (via Mesh CA and Workload Identity), better visibility (via Cloud Operations) and a Google-managed mesh control plane. Learn more about configuring Workload Identity.
These changes will also include registering the cluster to the project’s fleet. Fleets allow you to manage multiple clusters and apply conistent policies across your systems. Once registered, a cluster can only be unregistered by following a manual process. Learn more
This operation cannot be undone from the UI.

Changes:
 Created cluster will be added to the Fleet
 A cluster label mesh_id: proj-615800897334 will be added.
 The following Cloud APIs will be enabled
mesh.googleapis.com


no beta command

gcloud container --project "anthos-sgz" clusters create-auto "central" --region "us-east1" --release-channel "regular" --network "projects/anthos-sgz/global/networks/default" --subnetwork "projects/anthos-sgz/regions/us-east1/subnetworks/default" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --labels mesh_id=proj-615800897334
```
## Anthos Manually

```
gcloud compute networks create anthos --project=anthos-arg --description=anthos --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create default2 --project=anthos-arg --range=10.128.0.0/20 --stack-type=IPV4_ONLY --network=anthos --region=us-west1

gcloud container --project "anthos-arg" clusters create-auto "us-west1" --region "us-west1" --release-channel "regular" --network "projects/anthos-arg/global/networks/anthos" --subnetwork "projects/anthos-arg/regions/us-west1/subnetworks/default2" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --labels key2=label2,mesh_id=${MESH_ID}

admin_@cloudshell:~ (anthos-arg)$ gcloud container --project "anthos-arg" clusters create-auto "us-west1" --region "us-west1" --release-channel "regular" --network "projects/anthos-arg/global/networks/anthos" --subnetwork "projects/anthos-arg/regions/us-west1/subnetworks/default2" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --labels key2=label2,mesh_id=proj-968780459040
```
<img width="761" alt="Screen Shot 2022-12-19 at 1 36 58 PM" src="https://user-images.githubusercontent.com/94715080/208496109-199ba8cc-5f9d-448c-b860-917937acd4eb.png">
```
ERROR: (gcloud.container.clusters.create-auto) unrecognized arguments:
  --labels
  key2=label2,mesh_id=proj-968780459040
  To search the help text of gcloud commands, run:
  gcloud help -- SEARCH_TERMS
```

creating via console
<img width="997" alt="Screen Shot 2022-12-19 at 1 37 35 PM" src="https://user-images.githubusercontent.com/94715080/208496171-a2e6be2d-ac27-4dd8-8256-631a491ccf60.png">
<img width="1482" alt="Screen Shot 2022-12-19 at 1 38 42 PM" src="https://user-images.githubusercontent.com/94715080/208496359-7c125bbd-53f2-4b11-bbc7-2753e3428dae.png">


## Staging

```
root_@cloudshell:~ (anthos-sgz)$ gcloud container clusters get-credentials central --region us-east1 --project anthos-sgz
Fetching cluster endpoint and auth data.
kubeconfig entry generated for central.
root_@cloudshell:~ (anthos-sgz)$ kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$email

clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-binding created

```
### Install Anthos Service Mesh via console only


Istio Service mesh is up

<img width="1567" alt="Screen Shot 2022-12-19 at 15 24 17" src="https://user-images.githubusercontent.com/24765473/208514518-425c2e74-01e9-447d-8bf6-d708d41de5f1.png">

reconnect to kubectl
```
gcloud container clusters get-credentials central --region us-east1 --project anthos-sgz
```

```

GATEWAY_NS=istio-gateway

kubectl create namespace $GATEWAY_NS

kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'

no resources

try manual asmcli

curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > asmcli

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-east1-c
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"


root_@cloudshell:~ (anthos-sgz)$ export CLUSTER_ZONE=us-east1-b
root_@cloudshell:~ (anthos-sgz)$ ./asmcli validate   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = central from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: Failed, retrying...(1 of 2)
asmcli: [WARNING]: Failed, retrying...(2 of 2)
asmcli: [WARNING]: Command 'gcloud container clusters get-credentials central --project=anthos-sgz --zone=us-east1-b' failed.
root_@cloudshell:~ (anthos-sgz)$ export CLUSTER=us-east1
root_@cloudshell:~ (anthos-sgz)$ ./asmcli validate   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER   --fleet_id $PROJECT_ID   --output_dir ./asm_output
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = central from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Downloading kpt..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 11.8M  100 11.8M    0     0  16.1M      0 --:--:-- --:--:-- --:--:-- 16.1M
asmcli: Downloading ASM..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 24.3M  100 24.3M    0     0  24.3M      0 --:--:-- --:--:-- --:--:-- 24.3M
asmcli: Downloading ASM kpt package...
fetching package "/asm" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "asm"
fetching package "/samples" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "samples"
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking required APIs...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking for project anthos-sgz...
asmcli: Reading labels for us-east1/central...
asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.



skip....


REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')

kubectl label namespace $GATEWAY_NS istio.io/rev=$REVISION --overwrite

cd ~/asm_output

kubectl apply -n $GATEWAY_NS -f samples/gateways/istio-ingressgateway
  
  
kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite

cd istio-1.12.9-asm.3

cat samples/bookinfo/platform/kube/bookinfo.yaml

```

## 20221219: GKE standard

```
gcloud beta container --project "anthos-sgz" clusters create "central-s" --zone "us-east1-c" --no-enable-basic-auth --cluster-version "1.24.7-gke.900" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/anthos-sgz/global/networks/default" --subnetwork "projects/anthos-sgz/regions/us-east1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "us-east1-c"
```

Register Cluster

<img width="1059" alt="Screen Shot 2022-12-19 at 16 15 28" src="https://user-images.githubusercontent.com/24765473/208525445-83eff374-998b-4128-bc6c-387488d7368c.png">


<img width="1563" alt="Screen Shot 2022-12-19 at 16 15 58" src="https://user-images.githubusercontent.com/24765473/208525514-3819595e-ea16-4ca7-89eb-c10d4a79d37f.png">


```
root_@cloudshell:~ (anthos-sgz)$ gcloud container clusters get-credentials central-s --region us-east1-c --project anthos-sgz
Fetching cluster endpoint and auth data.
kubeconfig entry generated for central-s.

root_@cloudshell:~ (anthos-sgz)$ kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=root@staging.gcp.zone
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-binding created

root_@cloudshell:~ (anthos-sgz)$ export CLUSTER_NAME=central-s

root_@cloudshell:~ (anthos-sgz)$ ./asmcli validate   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = central-s from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Verifying cluster registration.
asmcli: [ERROR]: Cluster has memberships.hub.gke.io CRD but no identity provider specified.
Please ensure that the registered cluster has fleet workload identity enabled:
https://cloud.google.com/anthos/multicluster-management/fleets/workload-identity


try install anyway

./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output \
  --enable_all \
  --option legacy-default-ingressgateway \
  --ca mesh_ca \
  --enable_gcp_components
  
  
  asmcli: Verifying cluster registration.
asmcli: [ERROR]: Cluster has memberships.hub.gke.io CRD but no identity provider specified.
Please ensure that the registered cluster has fleet workload identity enabled:
```

### Fix Workload Identity

https://cloud.google.com/anthos/multicluster-management/fleets/workload-identity
https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#enable-existing-cluster

```
#gcloud container clusters update CLUSTER_NAME --region=COMPUTE_REGION --workload-pool=PROJECT_ID.svc.id.goog
gcloud container clusters update $CLUSTER_NAME --region=$CLUSTER_ZONE --workload-pool=$PROJECT_ID.svc.id.goog

efault change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Updating central-s...working   
Updating central-s...done.     
Updated [https://container.googleapis.com/v1/projects/anthos-sgz/zones/us-east1-c/clusters/central-s].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-east1-c/central-s?project=anthos-sgz
```

### Add Service Mesh
https://cloud.google.com/service-mesh/docs/install
"The GKE cluster must be Standard. Autopilot clusters are only supported with [managed Anthos Service Mesh](https://cloud.google.com/service-mesh/docs/managed/provision-managed-anthos-service-mesh)."


## 20221220-2: GKE cluster must be min 4 vCPU - add ASM option

```
gcloud beta container --project "anthos-sgz" clusters create "cluster-s2" --zone "us-east1-c" --no-enable-basic-auth --cluster-version "1.24.7-gke.900" --release-channel "regular" --machine-type "e2-standard-4" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/anthos-sgz/global/networks/default" --subnetwork "projects/anthos-sgz/regions/us-east1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --labels mesh_id=proj-615800897334 --workload-pool "anthos-sgz.svc.id.goog" --enable-shielded-nodes --node-locations "us-east1-c"

ERROR: (gcloud.beta.container.clusters.create) ResponseError: code=403, message=Insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '300.0' and is short '100.0'. project has a quota of '500.0' with '200.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=anthos-sgz.

delete first GKE cluster or increase quota

Creating cluster cluster-s2 in us-east1-c... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1beta1/projects/anthos-sgz/zones/us-east1-c/clusters/cluster-s2].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-east1-c/cluster-s2?project=anthos-sgz
kubeconfig entry generated for cluster-s2.
NAME: cluster-s2
LOCATION: us-east1-c
MASTER_VERSION: 1.24.7-gke.900
MASTER_IP: 35.196.13.88
MACHINE_TYPE: e2-standard-4
NODE_VERSION: 1.24.7-gke.900
NUM_NODES: 3
STATUS: RUNNING


gcloud container clusters get-credentials cluster-s2 --zone us-east1-c --project anthos-sgz

kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=root@staging.gcp.zone

export CLUSTER_ZONE=us-east1-c
export CLUSTER_NAME=cluster-s2

``` 
it is not an autopilot cluster

<img width="1566" alt="Screen Shot 2022-12-19 at 17 36 31" src="https://user-images.githubusercontent.com/24765473/208540152-17e6eae3-0fbd-40e3-a6ea-79170fb9f4a8.png">

Issue might be we are already in a fleet and with ASM installed
<img width="1557" alt="Screen Shot 2022-12-19 at 17 39 12" src="https://user-images.githubusercontent.com/24765473/208540452-54830a3c-c5e4-4998-8726-4759d00627ba.png">

<img width="1565" alt="Screen Shot 2022-12-19 at 17 39 53" src="https://user-images.githubusercontent.com/24765473/208540540-a2400fb2-56be-4229-b2a0-1df93c4d1d89.png">


```
root_@cloudshell:~ (anthos-sgz)$ ./asmcli validate   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = cluster-s2 from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking required APIs...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking for project anthos-sgz...
asmcli: Reading labels for us-east1-c/cluster-s2...
asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: The istio-system namespace doesn't exist.
Please create the "istio-system" and retry, or run the script with the
'--enable_namespace_creation' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.


root_@cloudshell:~ (anthos-sgz)$ ./asmcli install   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output   --enable_all   --option legacy-default-ingressgateway   --ca mesh_ca   --enable_gcp_components
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = cluster-s2 from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Enabling required APIs...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking for project anthos-sgz...
asmcli: Reading labels for us-east1-c/cluster-s2...
asmcli: Querying for core/account...
asmcli: Binding root@staging.gcp.zone to cluster admin role...
clusterrolebinding.rbac.authorization.k8s.io/root-cluster-admin-binding created
asmcli: Creating istio-system namespace...
namespace/istio-system created
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.


delete asm_output

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
export CLUSTER_NAME=cluster-s2
export CLUSTER_ZONE=us-east1-c
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"

root_@cloudshell:~ (anthos-sgz)$ ls
asmcli  asm_output  cloud-guardrails-gcp  cloudshell_open  README-cloudshell.txt
root_@cloudshell:~ (anthos-sgz)$ rm -rf asm_output/
root_@cloudshell:~ (anthos-sgz)$ ./asmcli install   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output   --enable_all  --ca mesh_ca   --enable_gcp_components
asmcli: Using PROJECT_ID = anthos-sgz from environment variable.
asmcli: Using CLUSTER_NAME = cluster-s2 from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/root_/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Downloading kpt..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 11.8M  100 11.8M    0     0  19.4M      0 --:--:-- --:--:-- --:--:-- 19.4M
asmcli: Downloading ASM..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 24.3M  100 24.3M    0     0  26.7M      0 --:--:-- --:--:-- --:--:-- 26.6M
asmcli: Downloading ASM kpt package...
fetching package "/asm" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "asm"
fetching package "/samples" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "samples"
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Enabling required APIs...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to anthos-sgz
asmcli: Checking for project anthos-sgz...
asmcli: Reading labels for us-east1-c/cluster-s2...
asmcli: Querying for core/account...
asmcli: Binding root@staging.gcp.zone to cluster admin role...
clusterrolebinding.rbac.authorization.k8s.io/root-cluster-admin-binding configured
asmcli: Creating istio-system namespace...
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.
root_@cloudshell:~ (anthos-sgz)$

```



### 20221222: Trying 1.15 again
```
student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  195k  100  195k    0     0  1238k      0 --:--:-- --:--:-- --:--:-- 1238k
student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ chmod +x asmcli
student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ ./asmcli validate   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_ZONE   --fleet_id $PROJECT_ID   --output_dir ./asm_output
asmcli: Using PROJECT_ID = qwiklabs-gcp-04-f6b61e94e047 from environment variable.
asmcli: Using CLUSTER_NAME = central from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/student_02_45b06ab2654b/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Downloading kpt..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 11.8M  100 11.8M    0     0  16.5M      0 --:--:-- --:--:-- --:--:-- 25.7M
asmcli: Downloading ASM..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 24.3M  100 24.3M    0     0  18.9M      0  0:00:01  0:00:01 --:--:-- 18.9M
asmcli: Downloading ASM kpt package...
fetching package "/asm" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "asm"
fetching package "/samples" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "samples"
asmcli: Verifying cluster registration.
asmcli: Checking required APIs...
asmcli: [WARNING]: API not enabled - mesh.googleapis.com
asmcli: [ERROR]: One or more APIs are not enabled. Please enable them and retry, or run the
script with the '--enable_gcp_apis' flag to allow the script to enable them on
your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: Checking for project qwiklabs-gcp-04-f6b61e94e047...
asmcli: Reading labels for us-west1-c/central...
asmcli: [ERROR]: Current user must have the cluster-admin role on central.
Please add the cluster role binding and retry, or run the script with the
'--enable_cluster_roles' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: The istio-system namespace doesn't exist.
Please create the "istio-system" and retry, or run the script with the
'--enable_namespace_creation' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: Confirming node pool requirements for qwiklabs-gcp-04-f6b61e94e047/us-west1-c/central...
asmcli: Checking Istio installations...
asmcli: [WARNING]: There is no way to validate that the meshconfig API has been initialized.
asmcli: [WARNING]: This needs to happen once per GCP project. If the API has not been initialized
asmcli: [WARNING]: for qwiklabs-gcp-04-f6b61e94e047, please re-run this tool with the --enable_gcp_components
asmcli: [WARNING]: flag. Otherwise, installation will succeed but Anthos Service Mesh
asmcli: [WARNING]: will not function correctly.
asmcli: [WARNING]: Please see the errors above.

student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ ./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output \
  --enable_all \
  --option legacy-default-ingressgateway \
  --ca mesh_ca \
  --enable_gcp_components
asmcli: Using PROJECT_ID = qwiklabs-gcp-04-f6b61e94e047 from environment variable.
asmcli: Using CLUSTER_NAME = central from environment variable.
asmcli: Use `unset $VAR` if configuring using environment is unexpected.
asmcli: Setting up necessary files...
asmcli: Using /home/student_02_45b06ab2654b/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Verifying cluster registration.
asmcli: Enabling required APIs...
asmcli: Verifying cluster registration.
asmcli: Binding user:student-02-45b06ab2654b@qwiklabs.net to required IAM roles...
asmcli: Registering the cluster as central...
asmcli: Verifying cluster registration.
asmcli: Verified cluster is registered to qwiklabs-gcp-04-f6b61e94e047
asmcli: Checking for project qwiklabs-gcp-04-f6b61e94e047...
asmcli: Reading labels for us-west1-c/central...
asmcli: Querying for core/account...
asmcli: Binding student-02-45b06ab2654b@qwiklabs.net to cluster admin role...
clusterrolebinding.rbac.authorization.k8s.io/student-02-45b06ab2654b-cluster-admin-binding created
asmcli: Creating istio-system namespace...
namespace/istio-system created
asmcli: Confirming node pool requirements for qwiklabs-gcp-04-f6b61e94e047/us-west1-c/central...
asmcli: Checking Istio installations...
asmcli: Initializing meshconfig API...
asmcli: Cluster has Membership ID central in the Hub of project qwiklabs-gcp-04-f6b61e94e047
asmcli: Binding user:student-02-45b06ab2654b@qwiklabs.net to required IAM roles...
asmcli: Configuring kpt package...
asm/
set 16 field(s) of setter "gcloud.container.cluster" to value "central"
asm/
set 20 field(s) of setter "gcloud.core.project" to value "qwiklabs-gcp-04-f6b61e94e047"
asm/
set 2 field(s) of setter "gcloud.project.projectNumber" to value "313788179583"
asm/
set 16 field(s) of setter "gcloud.compute.location" to value "us-west1-c"
asm/
set 1 field(s) of setter "gcloud.compute.network" to value "qwiklabs-gcp-04-f6b61e94e047-default"
asm/
set 3 field(s) of setter "gcloud.project.environProjectNumber" to value "313788179583"
asm/
set 2 field(s) of setter "anthos.servicemesh.rev" to value "asm-1153-6"
asm/
set 5 field(s) of setter "anthos.servicemesh.tag" to value "1.15.3-asm.6"
asm/
set 3 field(s) of setter "anthos.servicemesh.trustDomain" to value "qwiklabs-gcp-04-f6b61e94e047.svc.id.goog"
asm/
set 1 field(s) of setter "anthos.servicemesh.tokenAudiences" to value "istio-ca,qwiklabs-gcp-04-f6b61e94e047.svc.id.goog"
asm/
set 1 field(s) of setter "anthos.servicemesh.spiffeBundleEndpoints" to value "qwiklabs-gcp-04-f6b61e94e047.svc.id.goog|https://storage.googleapis.com/mesh-ca-resources/spiffe_bundle.json"
asm/
set 3 field(s) of setter "anthos.servicemesh.created-by" to value "asmcli-1.15.3-asm.6.config2"
asm/
set 2 field(s) of setter "anthos.servicemesh.idp-url" to value "https://container.googleapis.com/v1/projects/qwiklabs-gcp-04-f6b61e94e047/locations/us-west1-c/clusters/central"
asm/
set 2 field(s) of setter "anthos.servicemesh.trustDomainAliases" to value "qwiklabs-gcp-04-f6b61e94e047.svc.id.goog"
namespace/istio-system labeled
asmcli: Installing validation webhook fix...
service/istiod created
asmcli: Installing ASM control plane...

Thank you for installing Istio 1.15.  Please take a few minutes to tell us about your install/upgrade experience!  https://forms.gle/SWHFBmwJspusK1hv6
asmcli: ...done!
asmcli: Installing ASM CanonicalService controller in asm-system namespace...
namespace/asm-system created
customresourcedefinition.apiextensions.k8s.io/canonicalservices.anthos.cloud.google.com created
role.rbac.authorization.k8s.io/canonical-service-leader-election-role created
clusterrole.rbac.authorization.k8s.io/canonical-service-manager-role created
clusterrole.rbac.authorization.k8s.io/canonical-service-metrics-reader created
serviceaccount/canonical-service-account created
rolebinding.rbac.authorization.k8s.io/canonical-service-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/canonical-service-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/canonical-service-proxy-rolebinding created
service/canonical-service-controller-manager-metrics-service created
deployment.apps/canonical-service-controller-manager created
asmcli: Waiting for deployment...
deployment.apps/canonical-service-controller-manager condition met
asmcli: ...done!
asmcli:
asmcli: *****************************
client version: 1.15.3-asm.6
control plane version: 1.15.3
data plane version: 1.15.3-asm.6 (2 proxies)
asmcli: *****************************
asmcli: The ASM control plane installation is now complete.
asmcli: To enable automatic sidecar injection on a namespace, you can use the following command:
asmcli: kubectl label namespace <NAMESPACE> istio-injection- istio.io/rev=asm-1153-6 --overwrite
asmcli: If you use 'istioctl install' afterwards to modify this installation, you will need
asmcli: to specify the option '--set revision=asm-1153-6' to target this control plane
asmcli: instead of installing a new one.
asmcli: To finish the installation, enable Istio sidecar injection and restart your workloads.
asmcli: For more information, see:
asmcli: https://cloud.google.com/service-mesh/docs/proxy-injection
asmcli: The ASM package used for installation can be found at:
asmcli: /home/student_02_45b06ab2654b/asm_output/asm
asmcli: The version of istioctl that matches the installation can be found at:
asmcli: /home/student_02_45b06ab2654b/asm_output/istio-1.15.3-asm.6/bin/istioctl
asmcli: A symlink to the istioctl binary can be found at:
asmcli: /home/student_02_45b06ab2654b/asm_output/istioctl
asmcli: The combined configuration generated for installation can be found at:
asmcli: /home/student_02_45b06ab2654b/asm_output/asm-1153-6-manifest-raw.yaml
asmcli: The full, expanded set of kubernetes resources can be found at:
asmcli: /home/student_02_45b06ab2654b/asm_output/asm-1153-6-manifest-expanded.yaml
asmcli: *****************************
asmcli: Successfully installed ASM.



student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ GATEWAY_NS=istio-gateway
kubectl create namespace $GATEWAY_NS
namespace/istio-gateway created
student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ kubectl get deploy -n istio-system -l app=istiod -o \
jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}'
asm-1153-6
student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ REVISION=$(kubectl get deploy -n istio-system -l app=istiod -o \
jsonpath={.items[*].metadata.labels.'istio\.io\/rev'}'{"\n"}')

student_02_45b06ab2654b@cloudshell:~ (qwiklabs-gcp-04-f6b61e94e047)$ kubectl label namespace $GATEWAY_NS \
istio.io/rev=$REVISION --overwrite
namespace/istio-gateway labeled

cd ~/asm_output
kubectl apply -n $GATEWAY_NS \
  -f samples/gateways/istio-ingressgateway
  
student_02_45b06ab2654b@cloudshell:~/asm_output (qwiklabs-gcp-04-f6b61e94e047)$ kubectl label namespace default istio-injection- istio.io/rev=$REVISION --overwrite
label "istio-injection" not found.
namespace/default labeled

ignore above

switch dir from 12 to 15
cd istio-1.15.3-asm.6
cat samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

100%
```
<img width="1286" alt="Screen Shot 2022-12-22 at 08 50 12" src="https://user-images.githubusercontent.com/24765473/209148310-45dec8f7-e897-4893-ad94-ecaa2e0c1de7.png">


```
continue
cat samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml


tudent_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ kubectl get services
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
details       ClusterIP   10.36.10.134   <none>        9080/TCP   10m
kubernetes    ClusterIP   10.36.0.1      <none>        443/TCP    43m
productpage   ClusterIP   10.36.2.144    <none>        9080/TCP   10m
ratings       ClusterIP   10.36.11.41    <none>        9080/TCP   10m
reviews       ClusterIP   10.36.2.91     <none>        9080/TCP   10m
student_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-7d4d9d5fcb-bcdzl       2/2     Running   0          10m
productpage-v1-66756cddfd-fqcf8   2/2     Running   0          10m
ratings-v1-85cc46b6d4-bzbtm       2/2     Running   0          10m
reviews-v1-777df99c6d-hndqb       2/2     Running   0          10m
reviews-v2-cdd8fb88b-6n46x        2/2     Running   0          10m
reviews-v3-58b6479b-2gxgp         2/2     Running   0          10m

student_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ kubectl exec -it $(kubectl get pod -l app=ratings \
    -o jsonpath='{.items[0].metadata.name}') \
    -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>

kubectl get gateway
NAME               AGE
bookinfo-gateway   68s


kubectl get svc istio-ingressgateway -n istio-system
NAME                   TYPE           CLUSTER-IP   EXTERNAL-IP    PORT(S)                                                                      AGE
istio-ingressgateway   LoadBalancer   10.36.5.52   34.168.22.50   15021:31055/TCP,80:32035/TCP,443:30369/TCP,15012:32656/TCP,15443:31836/TCP   27m

tudent_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ export GATEWAY_URL=34.168.22.50

student_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ curl -I http://${GATEWAY_URL}/productpage
HTTP/1.1 200 OK
content-type: text/html; charset=utf-8
content-length: 5293
server: istio-envoy
date: Thu, 22 Dec 2022 13:54:46 GMT
x-envoy-upstream-service-time: 41

student_02_45b06ab2654b@cloudshell:~/asm_output/istio-1.15.3-asm.6 (qwiklabs-gcp-04-f6b61e94e047)$ curl -I http://${GATEWAY_URL}/productpage
HTTP/1.1 200 OK
content-type: text/html; charset=utf-8
content-length: 5293
server: istio-envoy
date: Thu, 22 Dec 2022 13:55:00 GMT
x-envoy-upstream-service-time: 36

http://34.168.22.50/productpage
```

<img width="1263" alt="Screen Shot 2022-12-22 at 08 57 35" src="https://user-images.githubusercontent.com/24765473/209149741-cd83dfd4-933c-45bc-8ab4-25e1cca81fae.png">

sudo apt install siege
siege http://${GATEWAY_URL}/productpage


wait a bit for traffic

<img width="641" alt="Screen Shot 2022-12-22 at 09 12 43" src="https://user-images.githubusercontent.com/24765473/209152734-69e3aade-6687-4bde-8b3c-48c4142a15fa.png">
services - productpage

<img width="1283" alt="Screen Shot 2022-12-22 at 09 16 54" src="https://user-images.githubusercontent.com/24765473/209153546-1e6f186a-85fb-488b-be7f-1827d769ef29.png">

<img width="1274" alt="Screen Shot 2022-12-22 at 09 17 12" src="https://user-images.githubusercontent.com/24765473/209153602-5806a3a9-1944-4413-bf8b-93112504ffd5.png">

<img width="1290" alt="Screen Shot 2022-12-22 at 09 21 18" src="https://user-images.githubusercontent.com/24765473/209154399-3fa6d114-3097-4d98-b394-c02587d52b14.png">


## 20221225: ENV Var for default VPC override

https://github.com/GoogleCloudPlatform/bank-of-anthos/issues/1178


## 20221219: labels needs equals sign - on generated Anthos service mesh CLI
https://cloud.google.com/sdk/gcloud/reference/container/clusters/create

```
gcloud container clusters create-auto "central" --region "us-west1" --release-channel "regular" --network "projects/anthos-arg/global/networks/default" --subnetwork "projects/anthos-arg/regions/us-east1/subnetworks/default" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --labels mesh_id=proj-${MESH_ID} --enable-stackdriver-kubernetes

gcloud container clusters create-auto "central" --region "us-west1" --release-channel "regular" --network "projects/anthos-arg/global/networks/default" --subnetwork "projects/anthos-arg/regions/us-east1/subnetworks/default" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --labels= mesh_id=proj-${MESH_ID} --enable-stackdriver-kubernetes
```
creating via console works
<img width="997" alt="Screen Shot 2022-12-19 at 1 37 35 PM" src="https://user-images.githubusercontent.com/94715080/208496171-a2e6be2d-ac27-4dd8-8256-631a491ccf60.png">

<img width="1482" alt="Screen Shot 2022-12-19 at 1 38 42 PM" src="https://user-images.githubusercontent.com/94715080/208496359-7c125bbd-53f2-4b11-bbc7-2753e3428dae.png">

<img width="1282" alt="Screen Shot 2022-12-19 at 1 52 06 PM" src="https://user-images.githubusercontent.com/94715080/208498588-0436972a-9dcb-4441-9a9f-90f59e1d0eb1.png">

<img width="1208" alt="Screen Shot 2022-12-19 at 3 18 17 PM" src="https://user-images.githubusercontent.com/94715080/208513554-47a0a173-72d1-4fcc-a874-ff8aad84d0a5.png">

# Bugs
## 20221225: Anthos on GKE lab - gke create defaults to default VPC
The following line must be modified to be able to use anything other than the default VPC

```
gcloud container clusters create migration-processing   --project=$PROJECT_ID --zone=us-east1-d --machine-type e2-standard-4   --image-type ubuntu_containerd --num-nodes 3 --enable-stackdriver-kubernetes   --subnetwork "projects/$PROJECT_ID/regions/us-east1/subnetworks/default"

to

gcloud container clusters create m4a-processing --project=$PROJECT_ID --zone=$ZONE --machine-type e2-standard-4 --image-type ubuntu_containerd --num-nodes 1 --enable-stackdriver-kubernetes -network=$NETWORK --subnetwork=$SUBNET
```


## 20221225: cymbal-monolith-cluster GKE cluster creation steps - part 1

missing

## 20221218: Anthos on GKE lab - asmcli 1.12 flags all GKE clusters as autopilot - use 1.15

```
./asmcli validate \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output

in

Welcome to Cloud Shell! Type "help" to get started.
Your Cloud Platform project in this session is set to qwiklabs-gcp-00-2685feeb9183.
Use “gcloud config set project [PROJECT_ID]” to change to a different project.
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-west1-c
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"
Your active configuration is: [cloudshell-31949]
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ gcloud config set compute/zone ${CLUSTER_ZONE}
gcloud beta container clusters create ${CLUSTER_NAME} \
    --machine-type=n1-standard-4 \
    --num-nodes=4 \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --subnetwork=default \
    --release-channel=regular \
    --labels mesh_id=${MESH_ID}
Updated property [compute/zone].
WARNING: The `--enable-stackdriver-kubernetes` flag is deprecated and will be removed in an upcoming release. Please use `--logging` and `--monitoring` instead. For more information, please read: https://cloud.google.com/stackdriver/docs/solutions/gke/installing.
Default change: VPC-native is the default mode during cluster creation for versions greater than 1.21.0-gke.1500. To create advanced routes based clusters, please pass the `--no-enable-ip-alias` flag
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster central in us-west1-c... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1beta1/projects/qwiklabs-gcp-00-2685feeb9183/zones/us-west1-c/clusters/central].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-west1-c/central?project=qwiklabs-gcp-00-2685feeb9183
kubeconfig entry generated for central.
NAME: central
LOCATION: us-west1-c
MASTER_VERSION: 1.24.7-gke.900
MASTER_IP: 35.247.40.172
MACHINE_TYPE: n1-standard-4
NODE_VERSION: 1.24.7-gke.900
NUM_NODES: 4
STATUS: RUNNING
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ kubectl create clusterrolebinding cluster-admin-binding   --clusterrole=cluster-admin   --user=$(whoami)@qwiklabs.net
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-binding created
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > asmcli
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  188k  100  188k    0     0  1749k      0 --:--:-- --:--:-- --:--:-- 1749k
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > asmcli
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  188k  100  188k    0     0  10.2M      0 --:--:-- --:--:-- --:--:-- 10.8M
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > asmcli
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  188k  100  188k    0     0  10.2M      0 --:--:-- --:--:-- --:--:-- 10.2M
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ ls
asmcli  README-cloudshell.txt
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ chmod +x asmcli
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$ ./asmcli validate \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output
asmcli: Using PROJECT_ID = qwiklabs-gcp-00-2685feeb9183 from environment.
asmcli: Using CLUSTER_NAME = central from environment.
asmcli: Setting up necessary files...
asmcli: Using /home/student_02_95ca66fb1460/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Downloading kpt..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 11.8M  100 11.8M    0     0  21.0M      0 --:--:-- --:--:-- --:--:-- 29.8M
asmcli: Downloading ASM..
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 40.7M  100 40.7M    0     0  25.1M      0  0:00:01  0:00:01 --:--:-- 25.1M
asmcli: Downloading ASM kpt package...
fetching package "/asm" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "asm"
fetching package "/samples" from "https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages" to "samples"
asmcli: Verifying cluster registration.
asmcli: Checking required APIs...
asmcli: [WARNING]: API not enabled - meshca.googleapis.com,stackdriver.googleapis.com,gkehub.googleapis.com,gkeconnect.googleapis.com,meshconfig.googleapis.com
asmcli: [ERROR]: One or more APIs are not enabled. Please enable them and retry, or run the
script with the '--enable_gcp_apis' flag to allow the script to enable them on
your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: Checking for project qwiklabs-gcp-00-2685feeb9183...
asmcli: Reading labels for us-west1-c/central...
asmcli: [ERROR]: Current user must have the cluster-admin role on central.
Please add the cluster role binding and retry, or run the script with the
'--enable_cluster_roles' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: Checking for istio-system namespace...
asmcli: [ERROR]: The istio-system namespace doesn't exist.
Please create the "istio-system" and retry, or run the script with the
'--enable_namespace_creation' flag to allow the script to enable it on your behalf.
Alternatively, use --enable_all|-e to allow this tool to handle all dependencies.
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$****
```
following will fail

```
./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $CLUSTER_NAME \
  --cluster_location $CLUSTER_ZONE \
  --fleet_id $PROJECT_ID \
  --output_dir ./asm_output \
  --enable_all \
  --option legacy-default-ingressgateway \
  --ca mesh_ca \
  --enable_gcp_components
```

with

```
asmcli: Using PROJECT_ID = qwiklabs-gcp-00-2685feeb9183 from environment.
asmcli: Using CLUSTER_NAME = central from environment.
asmcli: Setting up necessary files...
asmcli: Using /home/student_02_95ca66fb1460/asm_output/asm_kubeconfig as the kubeconfig...
asmcli: Checking installation tool dependencies...
asmcli: Fetching/writing GCP credentials to kubeconfig file...
asmcli: [WARNING]: nc not found, skipping k8s connection verification
asmcli: [WARNING]: (Installation will continue normally.)
asmcli: Getting account information...
asmcli: Verifying cluster registration.
asmcli: Enabling required APIs...
asmcli: Verifying cluster registration.
asmcli: Registering the cluster as central...
asmcli: Checking for project qwiklabs-gcp-00-2685feeb9183...
asmcli: Reading labels for us-west1-c/central...
asmcli: Querying for core/account...
asmcli: Binding student-02-95ca66fb1460@qwiklabs.net to cluster admin role...
clusterrolebinding.rbac.authorization.k8s.io/student-02-95ca66fb1460-cluster-admin-binding created
asmcli: Creating istio-system namespace...
namespace/istio-system created
asmcli: [ERROR]: Autopilot clusters are only supported with managed control plane.
student_02_95ca66fb1460@cloudshell:~ (qwiklabs-gcp-00-2685feeb9183)$
```
Lab suggestion - switch region - a potential violation of the terms of use of qwiklabs (2 clusters up)
```
Please install Anthos Service Mesh on Kubernetes cluster in us-east1-c zone. If you have already installed it, you may need to wait to get all pods in running state.
```




## 20221221: ASM Traffic Management lab - broken

The GKE cluster does not come up as stated in the lab
https://www.cloudskillsboost.google/focuses/8462?parent=catalog

```
Welcome to Cloud Shell! Type "help" to get started.
Your Cloud Platform project in this session is set to qwiklabs-gcp-04-20a9ab44537e.
Use “gcloud config set project [PROJECT_ID]” to change to a different project.
student_00_676ebece4a68@cloudshell:~ (qwiklabs-gcp-04-20a9ab44537e)$ export CLUSTER_NAME=gke
export CLUSTER_ZONE=us-east5-b
student_00_676ebece4a68@cloudshell:~ (qwiklabs-gcp-04-20a9ab44537e)$ export GCLOUD_PROJECT=$(gcloud config get-value project)
Your active configuration is: [cloudshell-23373]
student_00_676ebece4a68@cloudshell:~ (qwiklabs-gcp-04-20a9ab44537e)$ gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --project $GCLOUD_PROJECT
Fetching cluster endpoint and auth data.
ERROR: (gcloud.container.clusters.get-credentials) ResponseError: code=404, message=Not found: projects/qwiklabs-gcp-04-20a9ab44537e/zones/us-east5-b/clusters/gke.
No cluster named 'gke' in qwiklabs-gcp-04-20a9ab44537e.
student_00_676ebece4a68@cloudshell:~ (qwiklabs-gcp-04-20a9ab44537e)
```

Rerun lab a couple times - first time 8 min = no cluster, 1 min = cluster.
However there is no service mesh or application pods up - just the k8s system

```
Welcome to Cloud Shell! Type "help" to get started.
Your Cloud Platform project in this session is set to qwiklabs-gcp-00-2d07ac20d86e.
Use “gcloud config set project [PROJECT_ID]” to change to a different project.
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ export CLUSTER_NAME=gke
export CLUSTER_ZONE=us-central1-c
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ export GCLOUD_PROJECT=$(gcloud config get-value project)
Your active configuration is: [cloudshell-21382]
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --project $GCLOUD_PROJECT
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke.
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ gcloud container clusters list
NAME: gke
LOCATION: us-central1-c
MASTER_VERSION: 1.24.7-gke.900
MASTER_IP: 34.132.131.144
MACHINE_TYPE: n1-standard-4
NODE_VERSION: 1.24.7-gke.900
NUM_NODES: 2
STATUS: RUNNING
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ kubectl get pods -n istio-system
No resources found in istio-system namespace.
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ kubectl get service -n istio-system
No resources found in istio-system namespace.
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ kubectl get pods -n asm-system
No resources found in asm-system namespace.
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e)$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                             READY   STATUS    RESTARTS   AGE
kube-system   event-exporter-gke-857959888b-wxs2t              2/2     Running   0          6m54s
kube-system   fluentbit-gke-4dlj9                              2/2     Running   0          5m56s
kube-system   fluentbit-gke-j9j5h                              2/2     Running   0          5m56s
kube-system   gke-metadata-server-fqw6c                        1/1     Running   0          5m54s
kube-system   gke-metadata-server-hgl8k                        1/1     Running   0          5m54s
kube-system   gke-metrics-agent-l7pfv                          1/1     Running   0          5m55s
kube-system   gke-metrics-agent-vkx5h                          1/1     Running   0          5m56s
kube-system   konnectivity-agent-7cdffc86bb-9lxhx              1/1     Running   0          5m42s
kube-system   konnectivity-agent-7cdffc86bb-wqvhz              1/1     Running   0          6m45s
kube-system   konnectivity-agent-autoscaler-566966775b-t8dfg   1/1     Running   0          6m43s
kube-system   kube-dns-7d5998784c-j2j6d                        4/4     Running   0          5m42s
kube-system   kube-dns-7d5998784c-twl6b                        4/4     Running   0          7m
kube-system   kube-dns-autoscaler-9f89698b6-scpj6              1/1     Running   0          6m59s
kube-system   kube-proxy-gke-gke-default-pool-3ae8e592-czv9    1/1     Running   0          4m45s
kube-system   kube-proxy-gke-gke-default-pool-3ae8e592-s8c0    1/1     Running   0          5m14s
kube-system   l7-default-backend-6dc845c45d-hrqrb              1/1     Running   0          6m41s
kube-system   metrics-server-v0.5.2-6bf845b67f-hcv4m           2/2     Running   0          5m29s
kube-system   netd-4v4sf                                       1/1     Running   0          5m54s
kube-system   netd-ldghj                                       1/1     Running   0          5m54s
kube-system   pdcsi-node-ffccb                                 2/2     Running   0          5m56s
kube-system   pdcsi-node-z9zpc                                 2/2     Running   0          5m55s
student_01_f8f6cf4b1043@cloudshell:~ (qwiklabs-gcp-00-2d07ac20d86e
```

# Quotas
```
old - 750 ssd from 500 and 32 vCore from 24 on anthos-old
Compute Engine API
Thank you for submitting Case # (ID:6a157212b2304c3fab) to Google Cloud Platform support for the following quotas:
Change CPUs - us-central1 from 24 to 32
Change Persistent Disk SSD (GB) - us-central1 from 500 GB to 750 GB
Your request is being processed and you should receive an email confirmation for your request. Should you need further assistance, you can respond to that email. You can also track the status of this request here.

```
<img width="1609" alt="Screen Shot 2022-12-26 at 14 01 25" src="https://user-images.githubusercontent.com/24765473/209576923-9dcd04d9-69b6-4882-b462-8f91ec106ac7.png">


```
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
ERROR: (gcloud.beta.container.clusters.create) ResponseError: code=403, message=
        (1) insufficient regional quota to satisfy request: resource "CPUS": request requires '12.0' and is short '2.0'. project has a quota of '24.0' with '10.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=anthos-old
        (2) insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '300.0' and is short '100.0'. project has a quota of '500.0' with '200.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=anthos-old.
        
https://console.cloud.google.com/apis/api/compute.googleapis.com/quotas?project=anthos-sgz
750 for staging - 
Quota: Persistent Disk SSD (GB)
Dimensions:region : us-central1
Current limit: 500 GB
Enter a new quota limit. A limit above 500 GB will require approval from your service provider.

root_@cloudshell:~ (anthos-sgz)$ gcloud container clusters create dev --project=$PROJECT_ID --zone=$ZONE --machine-type e2-standard-4 --image-type ubuntu_containerd --num-nodes 2  --network=$NETWORK --subnetwork=$SUBNET
Default change: VPC-native is the default mode during cluster creation for versions greater than 1.21.0-gke.1500. To create advanced routes based clusters, please pass the `--no-enable-ip-alias` flag
Note: Modifications on the boot disks of node VMs do not persist across node recreations. Nodes are recreated during manual-upgrade, auto-upgrade, auto-repair, and auto-scaling. To preserve modifications across node recreation, use a DaemonSet.
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
ERROR: (gcloud.container.clusters.create) ResponseError: code=403, message=Insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '200.0' and is short '94.0'. project has a quota of '500.0' with '106.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=anthos-sgz.
root_@cloudshell:~ (anthos-sgz)$


AME: serviceusage.googleapis.com
NAME: source.googleapis.com
NAME: sourcerepo.googleapis.com
NAME: sql-component.googleapis.com
NAME: storage-api.googleapis.com
NAME: storage-component.googleapis.com
NAME: storage.googleapis.com
Enabling APIs
API's after
NAME: anthosconfigmanagement.googleapis.com
NAME: artifactregistry.googleapis.com
NAME: autoscaling.googleapis.com
NAME: bigquery.googleapis.com
NAME: bigquerymigration.googleapis.com
NAME: bigquerystorage.googleapis.com
NAME: cloudapis.googleapis.com
NAME: cloudbilling.googleapis.com
NAME: cloudbuild.googleapis.com
NAME: clouddebugger.googleapis.com
NAME: cloudfunctions.googleapis.com
NAME: cloudkms.googleapis.com
NAME: cloudresourcemanager.googleapis.com
NAME: cloudtrace.googleapis.com
NAME: compute.googleapis.com
NAME: container.googleapis.com
NAME: containerfilesystem.googleapis.com
NAME: containerregistry.googleapis.com
NAME: datastore.googleapis.com
NAME: gkeconnect.googleapis.com
NAME: gkehub.googleapis.com
NAME: iam.googleapis.com
NAME: iamcredentials.googleapis.com
NAME: krmapihosting.googleapis.com
NAME: logging.googleapis.com
NAME: monitoring.googleapis.com
NAME: multiclustermetering.googleapis.com
NAME: oslogin.googleapis.com
NAME: pubsub.googleapis.com
NAME: run.googleapis.com
NAME: servicemanagement.googleapis.com
NAME: serviceusage.googleapis.com
NAME: source.googleapis.com
NAME: sourcerepo.googleapis.com
NAME: sql-component.googleapis.com
NAME: storage-api.googleapis.com
NAME: storage-component.googleapis.com
NAME: storage.googleapis.com
Start: 1672076746
Cluster create time: 1672076746 sec
migration cluster
dev cluster
production cluster
Updated property [compute/zone].
Create cluster cymbal-bank-prod
Start: 1672076748
WARNING: The `--enable-stackdriver-kubernetes` flag is deprecated and will be removed in an upcoming release. Please use `--logging` and `--monitoring` instead. For more information, please read: https://cloud.google.com/stackdriver/docs/solutions/gke/installing.
Default change: VPC-native is the default mode during cluster creation for versions greater than 1.21.0-gke.1500. To create advanced routes based clusters, please pass the `--no-enable-ip-alias` flag
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster cymbal-bank-prod in us-central1-a... Cluster is being configured...working   
Creating cluster cymbal-bank-prod in us-central1-a... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1beta1/projects/anthos-old/zones/us-central1-a/clusters/cymbal-bank-prod].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-central1-a/cymbal-bank-prod?project=anthos-old
kubeconfig entry generated for cymbal-bank-prod.
NAME: cymbal-bank-prod
LOCATION: us-central1-a
MASTER_VERSION: 1.24.7-gke.900
MASTER_IP: 34.29.12.134
MACHINE_TYPE: n1-standard-4
NODE_VERSION: 1.24.7-gke.900
NUM_NODES: 2
STATUS: RUNNING
Start: 1672077120
Create cluster cymbal-bank-dev
WARNING: The `--enable-stackdriver-kubernetes` flag is deprecated and will be removed in an upcoming release. Please use `--logging` and `--monitoring` instead. For more information, please read: https://cloud.google.com/stackdriver/docs/solutions/gke/installing.
Default change: VPC-native is the default mode during cluster creation for versions greater than 1.21.0-gke.1500. To create advanced routes based clusters, please pass the `--no-enable-ip-alias` flag
Default change: During creation of nodepools or autoscaling configuration changes for cluster versions greater than 1.24.1-gke.800 a default location policy is applied. For Spot and PVM it defaults to ANY, and for all other VM kinds a BALANCED policy is used. To change the default values use the `--location-policy` flag.
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster cymbal-bank-dev in us-central1-a... Cluster is being health-checked...working.  
Creating cluster cymbal-bank-dev in us-central1-a... Cluster is being health-checked (master is healthy)...done.     
Created [https://container.googleapis.com/v1beta1/projects/anthos-old/zones/us-central1-a/clusters/cymbal-bank-dev].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-central1-a/cymbal-bank-dev?project=anthos-old
kubeconfig entry generated for cymbal-bank-dev.
NAME: cymbal-bank-dev
LOCATION: us-central1-a
MASTER_VERSION: 1.24.7-gke.900
MASTER_IP: 104.197.151.27
MACHINE_TYPE: n1-standard-4
NODE_VERSION: 1.24.7-gke.900
NUM_NODES: 2
STATUS: RUNNING
Finish: 1672077476
Use the following command to switch to your new project
gcloud config set project anthos-old
**** Done ****

```

## 20221227: watch SSD quota on monolith VM migration
default is 500 - the migration requires temporary SSD space in the PVC (Persistent Volume Claim) - delete one of the GKE clusters temporarily as a last resort
<img width="1190" alt="Screen Shot 2022-12-27 at 11 02 41" src="https://user-images.githubusercontent.com/24765473/209691342-3cad5009-d8cc-4c79-8ad1-2a89fbf2bfbe.png">

```
failed to provision volume with StorageClass "standard-rwo": rpc error: code = Internal desc = CreateVolume failed to create single zonal disk "pvc-eca5aaee-d4c9-440f-a44f-cb2684561b57": failed to insert zonal disk: unknown Insert disk operation error: operation operation-1672155418674-5f0d105bd458e-528c8c77-f65dd410 failed (QUOTA_EXCEEDED): Quota 'SSD_TOTAL_GB' exceeded. Limit: 750.0 in region us-central1.
```
<img width="1832" alt="Screen Shot 2022-12-27 at 10 48 16" src="https://user-images.githubusercontent.com/24765473/209689787-bb132d4d-97eb-472f-ad84-d76d4b0885df.png">

<img width="1629" alt="Screen Shot 2022-12-27 at 10 50 09" src="https://user-images.githubusercontent.com/24765473/209689969-c38c1870-c0aa-41da-a00a-85d3a859b276.png">

<img width="1113" alt="Screen Shot 2022-12-27 at 10 52 07" src="https://user-images.githubusercontent.com/24765473/209690156-a00e7bef-5ad9-423f-9a48-672ad607999b.png">

<img width="1554" alt="Screen Shot 2022-12-27 at 10 51 26" src="https://user-images.githubusercontent.com/24765473/209690093-f19939ee-40df-4cda-91a5-471b672ecc7e.png">


<img width="1826" alt="Screen Shot 2022-12-27 at 10 52 42" src="https://user-images.githubusercontent.com/24765473/209690217-05646b1a-d33a-4fe1-afbc-b7940e55a9c6.png">

restarted
```
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS                        STEP                    STATUS  AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts       Extracting files (26612)        GenerateArtifacts       Running 30m13s
michael@cloudshell:~/anthos-old/private/anthos/gcloud (anthos-old)$ migctl migration status ledgermonolith-migration
NAME                            TYPE                    SOURCE                          CURRENT-OPERATION       PROGRESS        STEP                    STATUS          AGE
ledgermonolith-migration        linux-system-container  gcp: "ledgermonolith-service"   GenerateArtifacts                       GenerateArtifacts       Completed       35m15s

Generate artifacts done, repository:{GCS {Bucket anthos-old-migration-artifacts}} folder:v2k-system-ledgermonolith-migration/735d56df-316f-4fa1-84cc-b45daa480ddf/extract/2022-12-27T15:35:33Z
```
cleanup GKE disks
<img width="1141" alt="Screen Shot 2022-12-27 at 11 28 42" src="https://user-images.githubusercontent.com/24765473/209694344-970229d0-2e85-47a3-b8f4-091fc8aab95c.png">

# Notes

https://cloud.google.com/anthos/docs/tutorials/explore-anthos?_ga=2.79992407.-1734523350.1669469024
