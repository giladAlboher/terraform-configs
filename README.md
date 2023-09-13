1. deploy eks cluster - terraform init/apply

2. to connect to the cluster :
   aws eks update-kubeconfig --region us-east-1 --name demo

3. deploy argo-cd-setup - terraform init/apply

4. port-forward the svc - kubectl port-forward svc/argocd-server -n argocd       8080:443
5. kubectl get secrets argocd-initial-admin-secret -o yaml -n argocd
   password:
   echo enter_the_code_here | base64 -D
   username:
   admin

6. deploy this yaml in argocd:

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

7. deploy prometheus - terraform init/apply

8. kubectl port-forward svc/prometheus-operated -n monitoring 9090:9090

8. kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml

9. kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml 

10. kubectl apply -f cwagent-configmap.yaml

11. kubectl apply -f cwagent-daemonset.yaml

12. grafana: kubectl port-forward svc/kube-prometheus-stackr-grafana 3000:80 -n monitoring

13. kubectl get secrets -n monitoring kube-prometheus-stackr-grafana -o yaml