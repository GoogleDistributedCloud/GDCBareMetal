# biometric-backend
Biometric Backend originally from
- https://github.com/ObrienlabsDev/biometric-backend
- and
- reference https://github.com/cloud-quickstart/reference-architecture
- see https://github.com/ObrienlabsDev/doppler-radar-ml/issues
- see https://github.com/ObrienlabsDev/biometric-backend-grpc-http2
- see https://github.com/ObrienlabsDev/biometric-backend-mqtt-http3

# Links
- http://local.obrienlabs.io:8889/nbi/api/latest?user=20250921
- heart 
## Architecture
### Deployment
#### Helm
#### Kubernetes
see https://github.com/ObrienlabsDev/biometric-backend/tree/main/biometric-nbi/src/kubernetes

URLS
- http://192.168.0.203:30888/nbi/swagger-ui.html

<img width="1987" height="714" alt="Screenshot 2026-09-07 at 18 54 47" src="https://github.com/user-attachments/assets/e5a5faf8-8282-45b1-b8d6-bb37f5a0d6a9" />


The following script runs both the mysql and biometric-nbi springboot containers

```
kubernetes % ./deploy.sh
(venv-t214) michaelobrien@mbp8 kubernetes % kubectl get pods -n mysql                                    
NAME                    READY   STATUS    RESTARTS   AGE
mysql-9fbfc4867-bj4gz   1/1     Running   0          5m39s
(venv-t214) michaelobrien@mbp8 kubernetes % kubectl get services -n mysql                                
NAME    TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
mysql   ClusterIP   None         <none>        3306/TCP   31m
(venv-t214) michaelobrien@mbp8 kubernetes % kubectl exec -it mysql-9fbfc4867-bj4gz -n mysql  -- /bin/bash
bash-5.1# mysql -p

mysql> CREATE DATABASE IF NOT EXISTS biometric;
Query OK, 1 row affected (0.01 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| biometric          |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.00 sec)

mysql> use biometric;
Database changed
mysql> exit
Bye
bash-5.1# exit
exit
(venv-t214) michaelobrien@mbp8 kubernetes % 

```

test outside by port forwarding

```
(venv-t214) michaelobrien@mbp8 kubernetes % kubectl port-forward mysql-9fbfc4867-bj4gz -n mysql 3306:3306
Forwarding from 127.0.0.1:3306 -> 3306
Forwarding from [::1]:3306 -> 3306
```

If you prefer direct access without port forwarding, update `mysql-service.yaml`
to use a `NodePort` service. The example in this repository exposes port `3306`
on node port `30306`:

```
spec:
  type: NodePort
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
      nodePort: 30306
```
After applying the updated service you can connect using `<node-ip>:30306` - however try to use the internal dns name (without the internal or external port).
```
          env:
            - name: SPRING_DATASOURCE_URL
              value: jdbc:mysql://mysql.mysql.svc.cluster.local/biometric
```

![Image](https://github.com/user-attachments/assets/943d18d8-2cfc-478e-91ed-a7cd7b1dcf23)

remote NodePort connection

<img width="901" height="606" alt="Screenshot 2026-09-07 at 17 54 16" src="https://github.com/user-attachments/assets/aa55fcab-675a-4376-b07b-dc2d3d3f534b" />

##### Kubernetes Deployment example

20260907
```
ubuntu@14900c:~/wse_github/obrienlabsdev/biometric-backend/biometric-nbi/src/kubernetes$ ./undeploy.sh 
service "biometric-nbi" deleted from biometric namespace
deployment.apps "biometric-nbi" deleted from biometric namespace
namespace "biometric" deleted
job.batch "mysql-init" deleted from mysql namespace
service "mysql" deleted from mysql namespace
deployment.apps "mysql" deleted from mysql namespace
secret "mysql-secret" deleted from mysql namespace
persistentvolume "mysql-pv-volume" deleted
persistentvolumeclaim "mysql-pv-claim" deleted from mysql namespace
namespace "mysql" deleted
ubuntu@14900c:~/wse_github/obrienlabsdev/biometric-backend/biometric-nbi/src/kubernetes$ ./deploy.sh 
namespace/mysql created
persistentvolume/mysql-pv-volume created
persistentvolumeclaim/mysql-pv-claim created
secret/mysql-secret created
deployment.apps/mysql created
service/mysql created
job.batch/mysql-init created
namespace/biometric created
deployment.apps/biometric-nbi created
service/biometric-nbi created
ubuntu@14900c:~/wse_github/obrienlabsdev/biometric-backend/biometric-nbi/src/kubernetes$ kubectl get pods -n biometric
NAME                             READY   STATUS    RESTARTS   AGE
biometric-nbi-55c7c97c66-9786p   1/1     Running   0          14s
ubuntu@14900c:~/wse_github/obrienlabsdev/biometric-backend/biometric-nbi/src/kubernetes$ kubectl get pods -n mysql
NAME                    READY   STATUS      RESTARTS   AGE
mysql-b4b894846-mv88t   1/1     Running     0          19s
mysql-init-5zrhc        0/1     Completed   1          19s
ubuntu@14900c:~/wse_github/obrienlabsdev/biometric-backend/biometric-nbi/src/kubernetes$ kubectl logs -f biometric-nbi-55c7c97c66-9786p -n biometric
Picked up JAVA_TOOL_OPTIONS: -XX:-UseContainerSupport

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::               (v2.5.15)

2026-09-07 22:30:54.578  INFO 1 --- [           main] d.o.b.nbi.BiometricNbiApplication        : Starting BiometricNbiApplication v0.0.1-SNAPSHOT using Java 17.0.2 on biometric-nbi-55c7c97c66-9786p with PID 1 (/opt/app/ROOT.jar started by root in /)
2026-09-07 22:30:54.579  INFO 1 --- [           main] d.o.b.nbi.BiometricNbiApplication        : No active profile set, falling back to 1 default profile: "default"
2026-09-07 22:30:54.893  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2026-09-07 22:30:54.915  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 18 ms. Found 1 JPA repository interfaces.
2026-09-07 22:30:55.244  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2026-09-07 22:30:55.249  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2026-09-07 22:30:55.249  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.75]
2026-09-07 22:30:55.275  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/nbi]    : Initializing Spring embedded WebApplicationContext
2026-09-07 22:30:55.275  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 675 ms
2026-09-07 22:30:55.397  INFO 1 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2026-09-07 22:30:55.421  INFO 1 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.33
2026-09-07 22:30:55.476  INFO 1 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2026-09-07 22:30:55.525  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2026-09-07 22:30:55.647  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2026-09-07 22:30:55.661  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.MySQL8Dialect
2026-09-07 22:30:55.913  INFO 1 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2026-09-07 22:30:55.917  INFO 1 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2026-09-07 22:30:56.140  WARN 1 --- [           main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2026-09-07 22:30:56.168 DEBUG 1 --- [           main] s.w.s.m.m.a.RequestMappingHandlerMapping : 12 mappings in 'requestMappingHandlerMapping'
2026-09-07 22:30:56.198  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2026-09-07 22:30:56.225  INFO 1 --- [           main] pertySourcedRequestMappingHandlerMapping : Mapped URL path [/v2/api-docs] onto method [springfox.documentation.swagger2.web.Swagger2Controller#getDocumentation(String, HttpServletRequest)]
2026-09-07 22:30:56.271 DEBUG 1 --- [           main] s.w.s.m.m.a.RequestMappingHandlerAdapter : ControllerAdvice beans: 0 @ModelAttribute, 0 @InitBinder, 1 RequestBodyAdvice, 1 ResponseBodyAdvice
2026-09-07 22:30:56.326 DEBUG 1 --- [           main] o.s.w.s.handler.SimpleUrlHandlerMapping  : Patterns [/webjars/**, /**] in 'resourceHandlerMapping'
2026-09-07 22:30:56.329 DEBUG 1 --- [           main] .m.m.a.ExceptionHandlerExceptionResolver : ControllerAdvice beans: 0 @ExceptionHandler, 1 ResponseBodyAdvice
2026-09-07 22:30:56.383  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path '/nbi'
2026-09-07 22:30:56.383  INFO 1 --- [           main] d.s.w.p.DocumentationPluginsBootstrapper : Context refreshed
2026-09-07 22:30:56.390  INFO 1 --- [           main] d.s.w.p.DocumentationPluginsBootstrapper : Found 1 custom documentation plugin(s)
2026-09-07 22:30:56.411  INFO 1 --- [           main] s.d.s.w.s.ApiListingReferenceScanner     : Scanning for api listing references
2026-09-07 22:30:56.519  INFO 1 --- [           main] .d.s.w.r.o.CachingOperationNameGenerator : Generating unique operation named: handleUsingGET_1
2026-09-07 22:30:56.538  INFO 1 --- [           main] d.o.b.nbi.BiometricNbiApplication        : Started BiometricNbiApplication in 2.126 seconds (JVM running for 2.302)
```

