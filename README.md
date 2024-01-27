# README: Setting Up EKS Cluster and Applications

This README provides a step-by-step guide for setting up an Amazon EKS (Elastic Kubernetes Service) cluster and deploying various applications using Terraform. Follow the instructions below to seamlessly configure your environment.

## Amazon EKS Cluster Setup

1. Navigate to the eks-setup directory:
    ```bash
    cd eks-setup
    ```

2. Deploy the EKS cluster:
    ```bash
    terraform init
    terraform apply
    ```

3. Connect to the EKS cluster:
    ```bash
    aws eks update-kubeconfig --region us-east-1 --name eks-cluster-traking-project
    ```

## ArgoCD Setup

1. Navigate to the ArgoCD setup directory:
    ```bash
    cd ../argo-cd-setup
    ```

2. Deploy ArgoCD:
    ```bash
    terraform init
    terraform apply
    ```

3. Port-forward the ArgoCD service:
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

4. Fetch and decrypt the password to connect to the ArgoCD server:
    ```bash
    kubectl get secrets argocd-initial-admin-secret -o yaml -n argocd | grep password: | sed 's#.*password: ##g' | base64 -d
    ```

5. Deploy the configurations in ArgoCD. Create a new app and paste the YAML configuration provided.

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mahat
spec:
  destination:
    name: ''
    namespace: project
    server: 'https://kubernetes.default.svc'
  source:
    path: .
    repoURL: 'https://github.com/ZivAmram/mahat-project-configs.git'
    targetRevision: HEAD
  sources: []
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
      - ApplyOutOfSyncOnly=true
    syncInterval: 3m # Set the sync interval to 3 minutes

## Prometheus Setup

1. Navigate to the prometheus-setup directory:
    ```bash
    cd ../prometheus-setup
    ```

2. Deploy Prometheus:
    ```bash
    terraform init
    terraform apply
    ```

3. Port-forward the Prometheus service:
    ```bash
    kubectl port-forward svc/prometheus-operated -n monitoring 9090:9090
    ```

- Port-forward Grafana service:
    ```bash
    kubectl port-forward svc/kube-prometheus-stackr-grafana 3000:80 -n monitoring
    ```
    - Username: admin
    - Password: prom-operator

- Port-forward the app and mongo services:
    ```bash
    kubectl port-forward svc/trading-app-svc 5000:8080 -n project
    kubectl port-forward svc/mongo 27017:27017 -n project
    ```

## Additional Steps (Optional)

- To view the cluster in the AWS website, apply the view-pods-role.yaml file:
    ```bash
    kubectl apply -f view-pods-role.yaml
    ```
    
## Destroy

1. On the AWS console, delete the load balancer and the S3 bucket that contains the Terraform state.

2. Navigate to the eks-setup directory:
    ```bash
    cd eks-setup
    ```

3. Destroy the EKS cluster:
    ```bash
    terraform destroy
    ```

Follow these instructions carefully to ensure a smooth setup and teardown process for your EKS cluster and associated applications.