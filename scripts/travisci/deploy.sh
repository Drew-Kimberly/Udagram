#! /bin/bash

K8s_DIR="$(dirname $(dirname $(dirname $(realpath $0))))/k8s"

echo "Configuring kubeconfig for EKS Cluster ${AWS_EKS_CLUSTER} using AWS CLI"
aws --region $AWS_REGION eks update-kubeconfig --name $AWS_EKS_CLUSTER

echo "Deploying Kubernetes resources..."
bash "${K8s_DIR}/deploy.sh" $TRAVIS_COMMIT

# Watch each deployment rollout until it has completed (or errored).
for app in "$K8s_DIR/apps"/*
do
  kubectl rollout status deploy/$app &
done
