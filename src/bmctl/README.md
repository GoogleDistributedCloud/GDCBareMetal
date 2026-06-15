## 20260614 bmctl for Google Distributed Cloud - Software Only - bare metal

- https://github.com/GoogleDistributedCloud/GDCBareMetal/issues/3

### Update kubectl
Currently v1.31

```
gcloud components install kubectl
┌──────────────────────────────────────────────────────────────────┐
│               These components will be installed.                │
├────────────────────────────────────────────┬─────────┬───────────┤
│                    Name                    │ Version │    Size   │
├────────────────────────────────────────────┼─────────┼───────────┤
│ gke-gcloud-auth-plugin (Platform Specific) │  0.5.15 │   3.5 MiB │
│ kubectl                                    │  1.35.3 │   < 1 MiB │
│ kubectl (Platform Specific)                │  1.35.3 │ 123.6 MiB │
└────────────────────────────────────────────┴─────────┴───────────┘

kubectl version
Client Version: v1.31.3
Kustomize Version: v5.4.2

which kubectl
/opt/homebrew/bin/kubectl

brew upgrade kubectl
==> Upgraded 2 outdated packages
kubectl 1.31.3 -> 1.36.2
minikube 1.34.0 -> 1.38.1

kubectl version
Client Version: v1.36.2
Kustomize Version: v5.8.1
```


#### Clone anthos-samples fork

https://github.com/GoogleDistributedCloud/anthos-samples

```
https://github.com/GoogleDistributedCloud/anthos-samples
```

#### Run anthos script

Ask for 1000G up from the default of 500 for SSD quota first
ask for 40 vCPUs globally and at the region level


```
michael@cloudshell:~$ gcloud config set project gdc-anthos-oty
[environment: untagged] Read more to tag: g.co/cloud/project-env-tag.
Updated property [core/project].
michael@cloudshell:~ (gdc-anthos-oty)$ gcloud services enable anthos.googleapis.com

michael@cloudshell:~$ gcloud config set project gdc-anthos-olt
[environment: untagged] Read more to tag: g.co/cloud/project-env-tag.
Updated property [core/project].
michael@cloudshell:~ (gdc-anthos-olt)$ gcloud services enable anthos.googleapis.com
Operation "operations/acf.p2-783485922039-62e894f3-0d03-4b43-a2ca-bfaee7c66397" finished successfully.

gcloud services enable gkeonprem.googleapis.com

 REGION=northamerica-northeast1
 PROJECT_ID=gdc-anthos-olt
 export ZONE=$REGION-a

# https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/try/admin-user-gce-vms
 export ADMIN_CLUSTER_NAME=gdc-admin
 export ON_PREM_API_REGION=$REGION

 echo "list anthos API versions"
 gcloud container bare-metal admin-clusters query-version-config --location=$ON_PREM_API_REGION 

versions:
- version: 1.35.0-gke.525
- version: 1.34.400-gke.88
- version: 1.34.300-gke.59
- version: 1.34.200-gke.68
- version: 1.33.800-gke.75
- version: 1.33.700-gke.71
- version: 1.33.600-gke.39
- version: 1.32.1100-gke.84
- version: 1.32.1000-gke.57
- version: 1.32.900-gke.60
- version: 1.31.1100-gke.40
- version: 1.31.1000-gke.44
- version: 1.31.900-gke.38
- version: 1.30.1200-gke.63
- version: 1.30.1100-gke.67
- version: 1.30.1000-gke.85
- version: 1.29.1200-gke.98
- version: 1.29.1100-gke.84
- version: 1.29.1000-gke.93
- version: 1.28.1400-gke.79
- version: 1.28.1300-gke.59
- version: 1.28.1200-gke.83
- version: 1.16.12
- version: 1.16.11


anthos-bm-gcp-bash % ./install_admin_cluster.sh                                       

✅ Using Project [gdc-anthos-olt], Zone [northamerica-northeast1-a], Cluster name [gdc-admin] and Anthos bare metal version [1.35.0-gke.525].

1) All-(Setup-and-Install)  3) Quit
2) Setup-Only

Please select an installation mode: 2


michaelobrien@mbp8 anthos-bm-gcp-bash % ./install_admin_cluster.sh                                       

✅ Using Project [gdc-anthos-olt], Zone [northamerica-northeast1-a], Cluster name [gdc-admin] and Anthos bare metal version [1.35.0-gke.525].

1) All-(Setup-and-Install)  3) Quit
2) Setup-Only

Please select an installation mode: 2

You chose 'Setup-Only'.This will only set up the GCE infrastructure; Anthos bare metal cluster creation will be skipped.
Please confirm selection. (Use 'Y' or 'y' for Yes and 'N' or 'n' for No) Y
🔄 Creating Service Account and Service Account key...
Created service account [baremetal-gcr].
created key [9da509cfeb1595da7664bf062fd9e800cf0e4968] of type [json] as [bm-gcr.json] for [baremetal-gcr@gdc-anthos-olt.iam.gserviceaccount.com]
✅ Successfully created Service Account and downloaded key file.

🔄 Enabling GCP Service APIs...
Operation "operations/acat.p2-783485922039-f3944c65-bca3-4e63-a18a-a24981f0af20" finished successfully.
✅ Successfully enabled GCP Service APIs.

🔄 Adding IAM roles to the default compute engine Service Account for metadata management...
Updated IAM policy for project [gdc-anthos-olt].
bindings:
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/compute.instanceAdmin.v1
- members:
  - serviceAccount:783485922039@cloudservices.gserviceaccount.com
  role: roles/compute.instanceGroupManagerServiceAgent
- members:
  - serviceAccount:service-783485922039@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:service-783485922039@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - serviceAccount:service-783485922039@containerregistry.iam.gserviceaccount.com
  role: roles/containerregistry.ServiceAgent
- members:
  - serviceAccount:service-783485922039@gcp-sa-gkeonprem.iam.gserviceaccount.com
  role: roles/gkeonprem.serviceAgent
- members:
  - user:michael@obrienlabs.tech
  role: roles/owner
- members:
  - serviceAccount:service-783485922039@gcp-sa-pubsub.iam.gserviceaccount.com
  role: roles/pubsub.serviceAgent
etag: BwZUO65ooJg=
version: 1
Updated IAM policy for project [gdc-anthos-olt].
bindings:
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/compute.instanceAdmin.v1
- members:
  - serviceAccount:783485922039@cloudservices.gserviceaccount.com
  role: roles/compute.instanceGroupManagerServiceAgent
- members:
  - serviceAccount:service-783485922039@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:service-783485922039@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - serviceAccount:service-783485922039@containerregistry.iam.gserviceaccount.com
  role: roles/containerregistry.ServiceAgent
- members:
  - serviceAccount:service-783485922039@gcp-sa-gkeonprem.iam.gserviceaccount.com
  role: roles/gkeonprem.serviceAgent
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/iam.serviceAccountUser
- members:
  - user:michael@obrienlabs.tech
  role: roles/owner
- members:
  - serviceAccount:service-783485922039@gcp-sa-pubsub.iam.gserviceaccount.com
  role: roles/pubsub.serviceAgent
etag: BwZUO66LGj4=
version: 1
Updated IAM policy for project [gdc-anthos-olt].
bindings:
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/compute.instanceAdmin.v1
- members:
  - serviceAccount:783485922039@cloudservices.gserviceaccount.com
  role: roles/compute.instanceGroupManagerServiceAgent
- members:
  - serviceAccount:service-783485922039@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:service-783485922039@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - serviceAccount:service-783485922039@containerregistry.iam.gserviceaccount.com
  role: roles/containerregistry.ServiceAgent
- members:
  - serviceAccount:service-783485922039@gcp-sa-gkeonprem.iam.gserviceaccount.com
  role: roles/gkeonprem.serviceAgent
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/iam.serviceAccountKeyAdmin
- members:
  - serviceAccount:783485922039-compute@developer.gserviceaccount.com
  role: roles/iam.serviceAccountUser
- members:
  - user:michael@obrienlabs.tech
  role: roles/owner
- members:
  - serviceAccount:service-783485922039@gcp-sa-pubsub.iam.gserviceaccount.com
  role: roles/pubsub.serviceAgent
etag: BwZUO66sPvg=
version: 1
✅ Successfully added metadata permissions to default compute SA.

🔄 Adding IAM roles to the Service Account...
✅ Successfully added the requires IAM roles to the Service Account.

🔄 Setting up array variables for the VM names and IP addresses...
✅ Variables for the VM names and IP addresses setup.

🔄 Creating GCE VMs...
ERROR: (gcloud.compute.instances.create) Could not fetch resource:
---
code: ZONE_RESOURCE_POOL_EXHAUSTED
errorDetails:
- help:
    links:
    - description: Troubleshooting documentation
      url: https://cloud.google.com/compute/docs/resource-error
- localizedMessage:
    locale: en-US
    message: A n1-standard-8 VM instance is currently unavailable in the northamerica-northeast1-a
      zone. Alternatively, you can try your request again with a different VM hardware
      configuration or at a later time. For more information, see the troubleshooting
      documentation.
- errorInfo:
    domain: compute.googleapis.com
    metadatas:
      attachment: ''
      vmType: n1-standard-8
      zone: northamerica-northeast1-a
      zonesAvailable: ''
    reason: resource_availability
message: The zone 'projects/gdc-anthos-olt/zones/northamerica-northeast1-a' does not
  have enough resources available to fulfill the request.  Try a different zone, or
  try again later.


  checking quota and/or switch region
  is nane1 related (tried ol.dev) - switching to nane2 then us

  nane2-a working - but need more quota

  🔄 Creating GCE VMs...
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-ws].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME    ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-ws  northamerica-northeast2-a  n1-standard-8               10.188.0.2   34.130.38.140  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-admin-cluster-cp].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME                  ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-admin-cluster-cp  northamerica-northeast2-a  n1-standard-8               10.188.0.3   34.130.175.94  RUNNING
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

ERROR: (gcloud.compute.instances.create) Could not fetch resource:
 - Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 in region northamerica-northeast2.
	metric name = compute.googleapis.com/ssd_total_storage
	limit name = SSD-TOTAL-GB-per-project-region
	limit = 500.0
	dimensions = region: northamerica-northeast2
Try your request in another zone, or view documentation on how to increase quotas: https://cloud.google.com/compute/quotas.

our quota request for gdc-anthos2-old has been approved and your project quota has been adjusted according to the following requested limits:

+--------------+--------------------------------+-------------------------+-----------------+----------------+
| NAME         | DIMENSIONS                     | REGION                  | REQUESTED LIMIT | APPROVED LIMIT |
+--------------+--------------------------------+-------------------------+-----------------+----------------+
| SSD_TOTAL_GB | region=northamerica-northeast2 | northamerica-northeast2 |            1000 |           1000 |
+--------------+--------------------------------+-------------------------+-----------------+----------------+
```

 500 to 1000G
 https://console.cloud.google.com/iam-admin/quotas?orgonly=true&project=gdc-anthos2-old&supportedpurview=organizationId,folder,project

```
set vCPUs to 40
Quota 'CPUS_ALL_REGIONS' exceeded.  Limit: 32.0 globally.

Your quota request for gdc-anthos2-old has been approved and your project quota has been adjusted according to the following requested limits:

+------------------+------------+--------+-----------------+----------------+
| NAME             | DIMENSIONS | REGION | REQUESTED LIMIT | APPROVED LIMIT |
+------------------+------------+--------+-----------------+----------------+
| CPUS_ALL_REGIONS |            | GLOBAL |              64 |             64 |
+------------------+------------+--------+-----------------+----------------+


🔄 Creating GCE VMs...
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-ws].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME    ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
abm-ws  northamerica-northeast2-a  n1-standard-8               10.188.0.9   34.124.121.141  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-admin-cluster-cp].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME                  ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-admin-cluster-cp  northamerica-northeast2-a  n1-standard-8               10.188.0.10  34.130.38.140  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-user-cluster-cp].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME                 ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-user-cluster-cp  northamerica-northeast2-a  n1-standard-8               10.188.0.11  34.130.175.94  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-user-cluster-w1].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME                 ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-user-cluster-w1  northamerica-northeast2-a  n1-standard-8               10.188.0.12  34.130.68.157  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/gdc-anthos2-old/zones/northamerica-northeast2-a/instances/abm-user-cluster-w2].
WARNING: Some requests generated warnings:
 - Disk size: '200 GB' is larger than image size: '10 GB'. You might need to resize the root repartition manually if the operating system does not support automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd for details.

NAME                 ZONE                       MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
abm-user-cluster-w2  northamerica-northeast2-a  n1-standard-8               10.188.0.13  34.130.44.189  RUNNING
✅ Successfully created GCE VMs.

🔄 Checking SSH access to the GCE VMs...
Updating project ssh metadata...⠧U

|---------------------------------------------------------------------------------------------------------|
| VM Name               | L2 Network IP (VxLAN) | INFO                                                    |
|---------------------------------------------------------------------------------------------------------|
| abm-admin-cluster-cp  | 10.200.0.3            | 🌟 Ready for use as control plane for the admin cluster |
| abm-user-cluster-cp   | 10.200.0.4            | 🌟 Ready for use as control plane for the user cluster  |
| abm-user-cluster-w1   | 10.200.0.5            | 🌟 Ready for use as worker for the user cluster         |
| abm-user-cluster-w2   | 10.200.0.6            | 🌟 Ready for use as worker for the user cluster         |
|---------------------------------------------------------------------------------------------------------|

list all the VMs
michaelobrien@mbp8 GDCBareMetal % gcloud compute instances list | grep 'abm'
abm-admin-cluster-cp  northamerica-northeast2-a  n1-standard-8               10.188.0.10  34.130.38.140   RUNNING
abm-user-cluster-cp   northamerica-northeast2-a  n1-standard-8               10.188.0.11  34.130.175.94   RUNNING
abm-user-cluster-w1   northamerica-northeast2-a  n1-standard-8               10.188.0.12  34.130.68.157   RUNNING
abm-user-cluster-w2   northamerica-northeast2-a  n1-standard-8               10.188.0.13  34.130.44.189   RUNNING
abm-ws                northamerica-northeast2-a  n1-standard-8               10.188.0.9   34.124.121.141  RUNNING
```

download bmctl

```
gcloud storage cp gs://anthos-baremetal-release/bmctl/$BMCTL_VERSION/linux-amd64/bmctl .
Copying gs://anthos-baremetal-release/bmctl/1.35.0-gke.525/linux-amd64/bmctl to file://./bmctl
  Completed files 1/1 | 139.0MiB/139.0MiB                                      

Average throughput: 49.0MiB/s
ls -la
-rw-r--r--   1 mic...  staff  145767283 Jun 14 20:34 bmctl
```

