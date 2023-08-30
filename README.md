1. deploy eks cluster - terraform init/apply
2. to connect to the cluster :
   aws eks update-kubeconfig --region us-east-1 --name demo
3. deploy argo-cd-setup - terraform init/apply
4. port-forward the svc - kubectl port-forward svc/argocd-server -n argocd 8080:443
5. deploy this yaml in argocd:

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