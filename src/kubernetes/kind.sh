#!/bin/bash
# https://github.com/ObrienlabsDev/blog/issues/112
# https://cluster-api.sigs.k8s.io/user/quick-start
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
#
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

