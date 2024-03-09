#!/bin/bash
set -x #echo on

source .export_vars.sh


read -e -p 'Enter kluster name (e.g. fleetman.k8s.local where .k8s.local part is !!!MANDATORY!!!): ' -i "${NAME}" NAME
read -e -p "Enter bucket name (e.g. my-kops-test-bucket-r3i7h3d): " -i "${KOPSBUCKET}" KOPSBUCKET
read -e -p "Enter bucket URL (e.g. s3://my-kops-test-bucket-r3i7h3d): " -i "${KOPS_STATE_STORE}" KOPS_STATE_STORE


kubectl get nodes
kubectl get all
kubectl -n kube-system get po


kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE}

printf "\n\n\n\n\n\n\n\n\n\n\n"
echo "Run this command to delete custer"
echo "export KOPS_STATE_STORE=${KOPS_STATE_STORE} ; kops delete cluster --name=${NAME} --yes"



