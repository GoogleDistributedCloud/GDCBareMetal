#!/bin/bash

kubectl apply -f mysql-namespace.yaml
kubectl apply -f mysql-storage.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f mysql-database-init-job.yaml
# job to create and populated the database
kubectl apply -f biometric-namespace.yaml
kubectl apply -f biometric-nbi-springboot-deployment.yaml
kubectl apply -f biometric-nbi-springboot-service.yaml




#kubectl get namespaces
#kubectl get secrets -n mysql
#kubectl describe secret mysql-secret -n mysql
#kubectl get pv -n mysql
#kubectl get pvc -n mysql
#kubectl get pods -n mysql
#kubectl get service -n mysql
   
#kubectl exec --stdin --tty mysql-7cf66456c-hhqxr -- /bin/bash
#kubectl exec --stdin --tty mysql-7cf66456c-hhqxr -n mysql -- /bin/bash
 
