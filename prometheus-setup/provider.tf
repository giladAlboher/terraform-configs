provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Used to interact with the resources supported by Kubernetes.
# The provider needs to be configured with the proper credentials before it can be used.
provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}