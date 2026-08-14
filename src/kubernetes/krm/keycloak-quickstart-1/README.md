https://www.keycloak.org/getting-started/getting-started-kube
from
https://github.com/keycloak/keycloak-quickstarts/tree/main/kubernetes

# deployment
```
ubuntu@ubuntu01:~/wse_github/GDC/GDCBareMetal/src/kubernetes/krm/keycloak-quickstart-1$ kubectl apply -f keycloak.yaml
service/keycloak created
service/keycloak-discovery created
statefulset.apps/keycloak created
deployment.apps/postgres created
service/postgres created
ubuntu@ubuntu01:~/wse_github/GDC/GDCBareMetal/src/kubernetes/krm/keycloak-quickstart-1$ kubectl get pods -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
default              keycloak-0                                   0/1     Running   0          25s
default              postgres-5ccb8885d8-fdhrv                    1/1     Running   0          25s
kube-system          coredns-589f44dc88-gnbkc                     1/1     Running   0          17h
kube-system          coredns-589f44dc88-sxzvj                     1/1     Running   0          17h
kube-system          etcd-kind-control-plane                      1/1     Running   0          17h
kube-system          kindnet-rtft2                                1/1     Running   0          17h
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          17h
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          17h
kube-system          kube-proxy-dr954                             1/1     Running   0          17h
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          17h
local-path-storage   local-path-provisioner-855c7b7774-ttsbh      1/1     Running   0          17h
ubuntu@ubuntu01:~/wse_github/GDC/GDCBareMetal/src/kubernetes/krm/keycloak-quickstart-1$ kubectl get services
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
keycloak             ClusterIP   10.96.180.148   <none>        8080/TCP   35s
keycloak-discovery   ClusterIP   None            <none>        <none>     35s
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP    17h
postgres             ClusterIP   10.96.105.165   <none>        5432/TCP   35s
ubuntu@ubuntu01:~/wse_github/GDC/GDCBareMetal/src/kubernetes/krm/keycloak-quickstart-1$ kubectl get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
postgres   1/1     1            1           45s
ubuntu@ubuntu01:~/wse_github/GDC/GDCBareMetal/src/kubernetes/krm/keycloak-quickstart-1$ kubectl get statefulsets
NAME       READY   AGE
keycloak   2/2     66s

```


