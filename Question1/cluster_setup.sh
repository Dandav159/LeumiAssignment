#!/bin/bash

### create namespaces ###

kubectl create namespace jenkins
kubectl create namespace app

### create service account and access token for account ###

kubectl create serviceaccount jenkins --namespace=jenkins
kubectl create token jenkins --namespace jenkins

### create role binding of admin to jenkins service account ###

kubectl create rolebinding jenkins-admin-binding --clusterrole=admin --serviceaccount=jenkins:jenkins --namespace=jenkins
kubectl create rolebinding helm-secret-access-binding --clusterrole=admin --serviceaccount=jenkins:default --namespace=app
