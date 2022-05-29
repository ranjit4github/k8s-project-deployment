# kubernetes_demo_project
A java application having a tomcat webserver and mysql database pods using namespace, configMap, secret, persistentVolume, service, label, selector and replicaset.

Pre-requisites:
---------------
1. Install 'kubectl'
2. Install 'minikube'
3. Before working on this project make sure you have setup single node cluster and it is running.

Pod creation & project setup
----------------------------
Go to the directory where you have kept all your yaml files.

1. 1st create the images out of the Dockerfiles `Dockerfile-mysql` & `Dockerfile-tomcat`.
```
docker build -t mysql:1.1 /path/to/dockerfile/Dockerfile-mysql .
docker build -t loginwebapp:1.2 /path/to/dockerfile/Dockerfile-tomcat .
```
2. Create a namespace where you want to run your pod
```
kubectl create -f namespaceDefinition.yml
```
3. Create configMap
```
kubectl create -f configmap-mysql.yml
```

4. Create secret to secure the DB credentials
```
kubectl create -f secret-mysql.yml
```

5. Create *persistent volume* and *persistent volume claim*
```
kubectl create -f mysql-pv.yml
```

6. Now create pods using *replicaset*
**Note:** The service and replicaset are added in one yaml file
```
kubectl create -f replicasetDefinition-tomcat.yml
kubectl create -f replicasetDefinition-mysqldb.yml
```

At this point your pods will be up and running.

**Check pods and the services.**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get all --namespace=dev**
NAME                             READY   STATUS    RESTARTS   AGE
pod/mysqldb-replicaset-w5tgg     1/1     Running   6          6d12h
pod/tomcatweb-replicaset-kn8bz   1/1     Running   6          6d12h
pod/tomcatweb-replicaset-tdj4q   1/1     Running   6          6d12h

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysqldb-service   ClusterIP   None             <none>        3306/TCP         6d12h
service/tomcat-service    NodePort    10.105.128.104   <none>        8080:30008/TCP   6d12h

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/mysqldb-replicaset     1         1         1       6d12h
replicaset.apps/tomcatweb-replicaset   2         2         2       6d12h
```
**To check configMap**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get configmap --namespace=dev**
NAME        DATA   AGE
db-config   3      8d
```
**To check secret**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get secret --namespace=dev**
NAME                  TYPE                                  DATA   AGE
db-secret             Opaque                                2      9d
default-token-99hkl   kubernetes.io/service-account-token   3      10d
```
**Persisten Volume**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get pv --namespace=dev**
NAME              CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
mysql-pv-volume   2Gi        RWO            Retain           Bound    dev/mysql-pv-claim   manual                  8d
```
**Persistent Volume Claim**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get pvc --namespace=dev**
NAME             STATUS   VOLUME            CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Bound    mysql-pv-volume   2Gi        RWO            manual         8d
```
**Check the pods**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get pods --namespace=dev**
NAME                         READY   STATUS    RESTARTS   AGE
mysqldb-replicaset-w5tgg     1/1     Running   6          6d12h
tomcatweb-replicaset-kn8bz   1/1     Running   6          6d12h
tomcatweb-replicaset-tdj4q   1/1     Running   6          6d12h
```
**Check the services**
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl get services --namespace=dev**
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
mysqldb-service   ClusterIP   None             <none>        3306/TCP         6d12h
tomcat-service    NodePort    10.105.128.104   <none>        8080:30008/TCP   6d12h
```
**Note:** Here the namespace was create as *dev*. So you need to specify the namespace name while diplaying the details.

## To view the application in your web browser, describe the service and get the LoadBalancer Ingress name and the NodePort
```
Ranjits-MacBook-Air:Desktop ranjitswain$ **kubectl describe service tomcat-service --namespace=dev**
Name:                     tomcat-service
Namespace:                dev
Labels:                   <none>
Annotations:              <none>
Selector:                 app=tomcatwebapp,type=front-end
Type:                     NodePort
IP:                       10.101.111.123
LoadBalancer Ingress:     localhost
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30008/TCP
Endpoints:                10.1.1.15:8080,10.1.1.17:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```
***i.e. http://localhost:30008/LoginWebApp/***

*LoginWebApp* is your application name.

