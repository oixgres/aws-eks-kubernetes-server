# AWS EKS KUBERNETES SERVER

Repo to create EKS kubernetes cluster and nodes in AWS. It requires the following tools

## Pre-requisites
* aws account -> Where resources will be launch
* terraform -> Handle infrastructure

## How to launch kubernetes server
* add your access keys to the main.tf file
* launch infrastructure:
```
terraform init
terraform plan
terraform apply
```

* Once resource are ready update your kubeconfig file
```
aws eks updade-kubeconfig --name eks
```
