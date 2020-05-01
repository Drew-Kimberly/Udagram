#! /bin/bash

K8s_DIR="$(dirname $(dirname $(dirname $(realpath $0))))/k8s"
REGION=$1
EKS_CLUSTER=$2
COMMIT=$3

echo "Configuring kubeconfig for EKS Cluster ${EKS_CLUSTER} using AWS CLI"
aws --region $REGION eks update-kubeconfig --name $AWS_EKS_CLUSTER

echo "Deploying Kubernetes resources at commit ${COMMIT}..."
bash "${K8s_DIR}/deploy.sh" $COMMIT

# Watch each deployment rollout until it has completed (or errored).
for app_dir in "$K8s_DIR/apps"/*
do
  APP=$(basename "$app_dir")
  kubectl rollout status deploy/$APP
done
