## 20260614 bmctl for Google Distributed Cloud - Software Only - bare metal

- https://github.com/GoogleDistributedCloud/GDCBareMetal/issues/3

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

```

