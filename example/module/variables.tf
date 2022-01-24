variable "additionalLabels" {}
variable "additionalNodeSelectorLabels" {}
variable "clusterName" {}
variable "namePrefix" {}
variable "instance" {}
variable "namespace" {}
variable "owner" {}
variable "imagePullSecretNames" {
  type = list(string)
}
variable "persistence" {
  description = "K8S persistence configuration"
  type = object({
    forceDisable       = bool
    storageSize        = string
    storageClassName   = string
    storageAccessModes = list(string)
  })
}

variable "infrastructureSize" {}
variable "tfWaitForRollout" {}

variable "operatingSystem" {
  default = "linux"
}
variable "architecture" {
  default = "amd64"
}
variable "additionalAnnotations" {
  type = object({
    service = map(string)
    pod = map(string)
    podResourceType = map(string)
  })
}
variable "ingress" {
  type = map(object({
    ingressClassName = string
    annotations      = map(string)
    fqdns            = list(string)
    overridePaths    = list(string)
  }))
}