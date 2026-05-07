# Secure Private Data Center
Conslidated private data center artifacts.
This repo details various approaches to standing up an air gapped data center that optionally uses or replicates functionality in GDC (Google Distributed Cloud) - both software only and air gapped solutions.


# Hardware
See https://cloud.google.com/sovereign-cloud?hl=en which includes Google Cloud Dedicated and Google Distributed Cloud


## GDC - Google Distributed Cloud
- https://github.com/ObrienlabsDev/blog/issues?q=state%3Aopen%20label%3A%22GDC%22
- 
GDC is Google's version of private or hybrid cloud within your own data center. 
There are 3 main versions of GDC - where GDC Connected and GDC air-gapped are Google provided hardware and software.  We will concentrate on [GDC software only - for bare metal](https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/concepts/about-bare-metal).

[GDCC](https://docs.cloud.google.com/distributed-cloud/edge/latest/docs/overview) - Google Distributed Cloud connected (edge)

[GDCAG](https://docs.cloud.google.com/distributed-cloud/hosted/docs/ga/gdch) - Google Distributed Cloud air-gapped

[GDCS](https://docs.cloud.google.com/distributed-cloud/docs/overview#gdcv) - Google Distributed Cloud software only

There was a historical variant of GDC Hosted (renamed GDC connected (edge) where a POC can be setup to install GDC software only on your own VMs to prep for eventual delivery and integration of the 4 minimum racks in a 300k/month GDC Hosted - https://docs.cloud.google.com/distributed-cloud/hosted/docs/latest/gdch/resources/faq

### GDC Connected - Hardware Component Mapping
#### Google Distributed Cloud at Next 26
At the GCP conference in Las Vegas in April 2026 there were 4 GDC related presentations - however the hardware on the showcase floor was where we could talk directly to GDC personnel and the hardware vendor partners like Dell, Intel, NetApp, Palo Alto and Thales.
<img width="414" height="850" alt="_next_26_gdcc_Screenshot 2026-04-26 at 18 20 10" src="https://github.com/user-attachments/assets/87785c7e-421c-41c0-a077-cf4c5734dcfe" />

 Component | Vendor | Model | Alternate 
--- | --- | --- | ---
TOR Switches 10G | . | . | 
TOR Switches 100-400G | . | . | 
Firewall | Palo Alto | <img width="1143" height="325" alt="_next_26_pa_Screenshot 2026-04-26 at 18 23 45" src="https://github.com/user-attachments/assets/19853c04-c9ac-458b-9557-4e2b9c675cda" /> | .
Identity | Thales | <img width="1171" height="130" alt="_next_26_thales_Screenshot 2026-04-26 at 18 23 59" src="https://github.com/user-attachments/assets/047f752b-b370-4192-ab17-823a40aca636" /> | .
Storage | NetApp | <img width="1160" height="248" alt="_next_26_netapp_Screenshot 2026-04-26 at 18 23 06" src="https://github.com/user-attachments/assets/dc3f24c0-1367-4cfd-8edc-e059a66c4bd9" /> | . 
Servers | HP | <img width="1158" height="646" alt="_next_26_gdcc_servers_Screenshot 2026-04-26 at 18 24 36" src="https://github.com/user-attachments/assets/41d37a4c-c273-4e2d-a31d-269462c04639" />  | . 
Servers | HPE | This looks to be HPE related  <img width="1134" height="141" alt="_next_26_gdcc_question_Screenshot 2026-04-26 at 18 25 02" src="https://github.com/user-attachments/assets/bd0660dd-1568-4136-8061-acc1f1419357" /> | . 
Servers | Intel | <img width="653" height="506" alt="_next_26_intel_Screenshot 2026-04-26 at 18 27 27" src="https://github.com/user-attachments/assets/607b5c21-95df-4c8e-9303-13a0afdd3a88" />
GPUs | . | . | .
Power Supply | . | <img width="1189" height="720" alt="_next_26_gdcc_power_Screenshot 2026-04-26 at 18 24 23" src="https://github.com/user-attachments/assets/f33c6a96-e44a-40ad-98a5-4522ce1020bf" /> | 
. | . | . | .


unknown - possible HP Edgeline - https://www.hpe.com/ca/en/solutions/edge-computing.html - 

### GDC Bare Metal - Hardware Component Mapping

 Component | Vendor | Model | Alternate 
--- | --- | --- | ---
TOR Switches 10G | . | . | 
TOR Switches 100-400G | . | . | 
Identity | . | . | .
Storage | . | . | . 
Servers | . | . | . 
GPUs | . | . | .
Power Supply | . | . | 
. | . | . | .

### GDC Air Gapped Appliance - Hardware Component Mapping


### 5U HPE-EL8000 - In the field GDC AG ruggedized.
See https://docs.cloud.google.com/distributed-cloud/hosted/docs/latest/appliance/overview#hardware_components

<img width="842" height="766" alt="gdc_air_gapped_appliance_front_profile" src="https://github.com/user-attachments/assets/28560cab-1702-4d5c-9db3-251425d7e7e7" />

 Component | Vendor | Model | Alternate 
--- | --- | --- | ---
TOR Switches 10G | . | . | 
TOR Switches 100-400G | . | . | 
HSM | | | 
Identity | . | . | .
Storage | NetApp | NetApp ONTAP Select (OTS) | . 
Servers | . | . | . 
GPUs | . | . | .
Power Supply | . | . | 
. | . | . | .

see - https://buy.hpe.com/ca/en/compute/edgeline-systems/edgeline-systems/hpe-edgeline-el8000t-converged-edge-system/p/1012828509
specifically the HPE - Edglone E8000 https://wiseit.com.ua/en/hpe-server-dlya-iot/
with rugged case https://ecommerce.ultralifecorporation.com/ECommerce/product/el8000-ca/hpe-el8000-server-travel-case
- https://www.lemondeinformatique.fr/actualites/lire-next2023-google-cloud-muscle-son-infrastructure-pour-l-ia-91415.html

### 6U HPE-EL8000 - GDC Air Gapped Appliance - Next 2023
<img width="1080" height="1342" alt="_edge-cloud-google_next_2023" src="https://github.com/user-attachments/assets/1a352601-d19f-43ad-9808-4c789324a7ec" />


#### GDC-AG connectivity
5 pathways for updates.

Vulnerability signatures

EDR - Incoming Detection and Response updates

Firewall IOC and signature updates

Threat intelligence

Code updates
(including image updates)

#### Operations Suite Infrastucture
OSI includes servicenow

#### Multitenant Organizations
Hardware level isolation with appliance pulg/play into the base 4 to 30 rack GDC
organizations, projects (no folders), tags, kubernetes taints.


### GDC software only for Bare Metal
- https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/concepts/about-bare-metal

This GDC software-only for BM looks to be a rebrand of Anthos where on prem CPUs are billed back to the GCP Project.




# Software

## GDC Software Component Mapping

 Component | Use Case | GCP | GDC  | Spec | OSS | Commercial
--- | --- | --- | --- | --- | --- | ---
API Gateway | L7 LB | Apigee | . | GKE dataplane 2 Gateway API | Ingress | 
Connect Agent (GKE) | anthos fleet registration | . | [Connect Agent](https://docs.cloud.google.com/kubernetes-engine/fleet-management/docs/connect-agent) | . | . | .
GKE Cluster Management | . | . | Anthos | . | [CAPI](https://github.com/kubernetes-sigs/cluster-api) | .
Identity/SSO | RBAC | . | . | OIDC | KeyCloak | AD (Active Directory), IBM Verify
IDS/IPS | TLS Inspection | Palo Alto NGFW | Palo Alto | . | Falco | .
Logging | . | . | . | . | ELK | .
Networking/eBPF/CNI | . | . | . | . | Cilium | . 
Observability | . | . | . | . | Prometheus / OpenTelemetry | .
Org Policies | . | . | . | . | Open Policy Agent/Kyverno
Project | . | . | . | . | K8s Namespaces or clusters | .
Service Mesh | . | . | . | . | Istio | .
Storage | PVC/Block | . | NetApp | . | . | [GCNV](https://cloud.google.com/netapp-volumes?hl=en) [Symcloud](https://symphony.rakuten.com/telecom-cloud/cloud-native-storage)
VM virtualization | VMs on Kubernetes | GCE | VM Manager | . | [KubeVirt](https://kubevirt.io/) | .
. | . | . | . | . | . | .

Gemini Enterprise (formerly VertexAI) - translate, speech-to-text, workbench
postgreSQL (check alloyDB Omni), Oracle byod


## CAPI - Cluster API
- https://github.com/kubernetes-sigs/cluster-api
CAPI is used under the cover by Anthos.

## KubeVirt
- https://kubevirt.io/
KubeVirt is used ther the cover by VM Manager - https://docs.cloud.google.com/distributed-cloud/connected/latest/docs/virtual-machines

## Storage
### NetApp
- [GCNV](https://cloud.google.com/netapp-volumes?hl=en)
- https://github.com/ObrienlabsDev/blog/issues/183
### Rakuten
- Symcloud Storage is used by GDC - https://symphony.rakuten.com/telecom-cloud/cloud-native-storage
- https://docs.cloud.google.com/distributed-cloud/connected/latest/docs/virtual-machines#configure_symcloud_storage
- https://docs.cloud.google.com/distributed-cloud/connected/latest/docs/storage
- 
### Harbor
- https://goharbor.io/
- 
## Openstack

## Open Nebula
- Open Nebula - https://en.wikipedia.org/wiki/OpenNebula


# Personas
## Infrastructure Operations
## Platform Administrator
## Application Operator


# GDC - Simulated Local Rack

<img width="679" height="966" alt="_gdc_simulated_rackScreenshot 2026-04-30 at 12 30 20" src="https://github.com/user-attachments/assets/5ce286da-5c5e-4327-9360-888a6153c2e8" />


## Lenovo BMC Rack Servers as GDC Simulators
- https://vmware.lenovo.com/content/recipe/SR250%20V3-Raptor%20lake-ESXi9.0.html
- https://serverproven.lenovo.com/
- https://lenovopress.lenovo.com/lp1215.pdf#:~:text=Lenovo%20has%20certified%20the%20ThinkAgile%20VX%20solution,an%20Anthos%20Ready%20virtualized%20platform%2C%20with%20bare%2Dmetal

### Lenovo SR250 V3 Rack Server
Lenovo XEON blades are cost effective for GDC simulation and include a secondary management CPU/Software stack for configuraiton - lead time is 30 days for shipping.
The following SR250 V3 server can run either Redhat or Ubuntu.

After post shipping diagnostics and setup...
<img width="1254" height="942" alt="Screenshot 2026-03-29 at 20 23 00" src="https://github.com/user-attachments/assets/d9c38913-ae43-408c-bb3d-e065b53b0784" />

The blades can be installed to a standard 19 inch rack in 1U slots and connected to top of rack switches/routers along with separate redundant power sources.
<img width="1485" height="849" alt="Screenshot 2026-03-29 at 20 00 20" src="https://github.com/user-attachments/assets/b3d52b15-0e7c-49e3-8fb6-5ed290194c87" />

For smaller rack depths such as 24 inches - the supplied lenovo specific extendable rails must be replaced with fixed 3rd party rails.
<img width="2052" height="299" alt="Screenshot 2026-03-29 at 21 09 48" src="https://github.com/user-attachments/assets/b06025e4-1298-4761-83a6-88a0aec4a9a2" />

SR250 V3 noise levels - https://youtu.be/E6iNi3QMMcE

### TOR Networking
Currently using TPLink 10gbps rack switches and routers.

# DevOps
## Server Setup
- https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/downloads
- 


# Use Cases
- https://github.com/ObrienlabsDev/drone-streaming-extraction?tab=readme-ov-file
- https://github.com/ObrienlabsDev/blog/wiki/Drone-Streaming-Extraction
- 
# Issues
- https://github.com/ObrienlabsDev/blog/issues/174

## GDC Documentation
- https://services.google.com/fh/files/misc/google_distributed_cloud_datasheets_all.pdf
- https://docs.cloud.google.com/distributed-cloud/docs
- https://cloud.google.com/distributed-cloud?hl=en
- See [VM Runtime](https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/vm-runtime/enable-disable) (wraps Redhat [KubeVirt)](https://kubevirt.io/) https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/vm-runtime/enable-disable
- https://cloud.google.com/blog/topics/hybrid-cloud/using-gdc-sandbox-to-emulate-air-gapped-environments
- https://docs.cloud.google.com/distributed-cloud/sandbox/latest


### GDC Training
- https://partner.skills.google/catalog?keywords=GDC
- https://cloud.google.com/customers/rubin-observatory
- 
# Links
- https://cloud.google.com/blog/topics/hybrid-cloud/using-gdc-sandbox-to-emulate-air-gapped-environments
-  GDC on bare metal - https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/downloads
- https://www.supermicro.com/en/solutions/google-distributed-cloud-virtual
- https://cloud.google.com/blog/products/infrastructure-modernization/google-distributed-cloud-edge-appliance-use-cases/
- https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/try/admin-user-gce-vms
- https://www.datacenterdynamics.com/en/news/google-makes-distributed-cloud-edge-hardware-generally-available/
- https://cloud.google.com/blog/products/infrastructure-modernization/google-distributed-cloud-edge-appliance-use-cases/
- GDC Edge Appliance is deprecated - https://docs.cloud.google.com/distributed-cloud/edge-appliance/deprecated-notice
- https://cloud.google.com/blog/topics/hybrid-cloud/using-gdc-sandbox-to-emulate-air-gapped-environments
- https://docs.cloud.google.com/distributed-cloud/sandbox/latest


- https://github.com/ObrienlabsDev/secure-private-data-center
- https://github.com/ObrienlabsDev/blog/blob/main/google-distributed-cloud.md
- L300 Anthos Migration notes - https://github.com/ObrienlabsDev/gcp-infrastructure-as-code/issues/22
- https://docs.cloud.google.com/kubernetes-engine/distributed-cloud/bare-metal/docs/vm-runtime/enable-disable
- https://partner.skills.google/catalog?keywords=GDC
- https://cloud.google.com/customers/rubin-observatory


# Private Cloud: PaaS Kubernetes stack with IaaS provisioning - HA and DR
- https://github.com/ObrienlabsDev/blog/blob/main/google-distributed-cloud.md
- https://github.com/ObrienlabsDev/blog/blob/main/private-cloud.md
- https://github.com/ObrienlabsDev/secure-private-data-center
- https://github.com/ObrienlabsDev/blog/issues/172
- https://github.com/ObrienlabsDev/blog/issues/137
- https://github.com/ObrienlabsDev/blog/issues/171
- https://github.com/ObrienlabsDev/blog/issues/170
- https://github.com/ObrienlabsDev/blog/issues/163
- https://github.com/ObrienlabsDev/blog/issues/174
- Google internal-only L300 Anthos Migration notes - https://github.com/ObrienlabsDev/gcp-infrastructure-as-code/issues/22

# Finances
## GDC Costs
GDC virtual - 25k/m

## GKE Costs
GKE control planes are per cluster (regardless of size) - at $0.1/hr - with free credits of 74.4 allocated for a single cluster (autopilot or zonal) - https://cloud.google.com/kubernetes-engine/pricing
### Anthos Costs
Anthos has a one time credit of 1000US - getting details for new accounts.
<img width="910" height="43" alt="Screenshot 2026-03-31 at 16 17 50" src="https://github.com/user-attachments/assets/9b7dfaef-3bc3-404e-93c9-5338951201d2" />

# Compatabiiity
## Ubuntu Certified
Details around various hardware configurations that support Ubuntu.
https://ubuntu.com/certified
### QSFP56 NVIDIA DGX Spark
- https://ca.store.ui.com/ca/en/category/switching-enterprise/collections/enterprise-campus-24/products/ecs-24s-poe

### Lenovo SR250 V3
- https://lenovopress.lenovo.com/lp1802-thinksystem-sr250-v3-server (acoustics - https://pubs.lenovo.com/uefi_xeon_4th/operating_modes)
- https://datacentersupport.lenovo.com/ca/en/products/servers/thinksystem/sr250v3/7dcl/downloads/driver-list/
- https://pubs.lenovo.com/sr250-v3/sr250_v3_user_guide.pdf
- https://pubs.lenovo.com/sr150/thinksystem_toolless_friction_rail_v2.pdf
- Ubuntu 24 ready - https://lenovopress.lenovo.com/osig#server_families=thinksystem&servers=sr250-v3-xeon-6300-7dcm-7dcl&os_families=ubuntu-server&os_versions=ubuntu-24&support=all&availability=available&form_factors=rack-1u-1s
- https://lenovopress.lenovo.com/lp1802.pdf
- https://lenovopress.lenovo.com/lp1288-thinksystem-raid-adapter-and-hba-reference
- 

### SFP28
- https://ca.store.ui.com/ca/en/category/switching-professional-max-xg/products/usw-pro-xg-24

# TODO
- lock down Google Cloud Dedicated and it's relationship or rename to Google Cloud Distributed (Air Gapped or Connected)

# Partner Companies
## Thales
- https://cpl.thalesgroup.com/about-us/newsroom/thales-introduces-imperva-for-google-cloud
- 
# References
- ONAP - https://onap.org/
- GoC/SSC Aurora (Cross CSP Kubernetes based LZ for use in Public Sector)  - https://github.com/gccloudone-aurora including helm charts - https://github.com/gccloudone-aurora/aurora-platform-charts (not https://github.com/gccloudone/aurora) - tracking https://github.com/ObrienlabsDev/blog/issues/176
