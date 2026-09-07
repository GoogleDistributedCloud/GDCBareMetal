#!/bin/bash

kubectl delete -f biometric-nbi-springboot-service.yaml
kubectl delete -f biometric-nbi-springboot-deployment.yaml
kubectl delete -f biometric-namespace.yaml
kubectl delete -f mysql-database-init-job.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f mysql-storage.yaml
kubectl delete -f mysql-namespace.yaml

