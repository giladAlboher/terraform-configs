variable "cluster-name" {
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
  type        = string
  default     = "demo"
}
variable "create_resource" {
  type        = bool
  default     = true
  description = "controls whether the resource should be created"
}
