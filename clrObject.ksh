#!/bin/ksh

kubectl get all --namespace=dev|grep -v NAME|sed 's/^$//g'|awk '{print $1}' > test.txt
kubectl get pv --namespace=dev|grep -v NAME|sed 's/^$//g'|awk '{print $1}' >> test.txt
kubectl get pvc --namespace=dev|grep -v NAME|sed 's/^$//g'|awk '{print $1}' >> test.txt
for i in `cat test.txt|sort`
do
	kubectl delete ${i} --namespace=dev
done
