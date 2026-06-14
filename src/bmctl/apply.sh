#!/bin/bash
# 20260614 - michael at obrienlabs dev - start bmctl script for gdc software only

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
./deployment.sh  -u olt -c true -d false

-u [unique] true/false       : unique identifier for your project - take your org/domain 1st letters forward/reverse - ie: landing.gcp.zone lgz
-c [create] true/false       : create deployment
-d [delete] true/false       : delete deployment
EOF
}

# for ease of override - key/value pairs for constants - shared by all scripts
source ./vars.sh

one-time-service-enables() {
gcloud services enable anthos.googleapis.com
gcloud services enable gkeonprem.googleapis.com
}

deployment() {
  echo "Date: $(date)"
  echo "Timestamp: $(date +%s)"
  echo "running with: -u $UNIQUE -c $CREATE_KCC -d $DELETE_KCC -p $PROJECT_ID $ZONE"

  startd=`date +%s`
  echo "Start: ${startd}"

  gcloud config set project ${PROJECT_ID}
  gcloud config set compute/zone ${ZONE}

  echo "list anthos API versions"
  gcloud container bare-metal admin-clusters query-version-config --location=$ON_PREM_API_REGION 

  # git clone git@github.com:GoogleDistributedCloud/anthos-samples
  # cd anthos-samples/anthos-bm-gcp-bash
  # source ../../GDCBareMetal/src/bmctl/vars.sh 
  # ./install_admin_cluster.sh 

}


UNIQUE=olt
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


