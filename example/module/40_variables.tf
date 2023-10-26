variable "createNamespace" {}
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
    service         = map(string)
    pod             = map(string)
    podResourceType = map(string)
  })
}
variable "ingress" {
  type = map(object({
    tlsEnabled       = bool
    ingressClassName = string
    pathType         = string
    annotations      = map(string)
    fqdns            = list(string)
    overridePaths    = list(string)
  }))
}

variable "ca" {
  type = object({
    crt       = string
    key       = string
  })
  description = "Certificate Authority to use for self signed Certs. `null` will auto-generate a CA if required."
}

variable "tlsConfig" {
  type = object({
    enableSelfSignedIngress = bool
    rsaBits = string
    earlyRenewalHours = string
    validityPeriodHours = string
  })
}

variable "forceDisableCRDs" {
  type = bool
}

variable "forceDisableWebhooks" {
  type = bool
}
