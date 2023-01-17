variable "architecture" {}
variable "operatingSystem" {}
variable "image" {}

variable "persistence" {
  description = "K8S persistence configuration"
  type = object({
    forceDisable       = bool
    storageSize        = string
    storageClassName   = string
    storageAccessModes = list(string)
  })
}

variable "imagePullSecretNames" {
  type = list(string)
}
variable "infrastructureSize" {
  type = string
}
variable "tfWaitForRollout" {
  type = bool
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
    ingressClassName = string
    annotations      = map(string)
    fqdns            = list(string)
    overridePaths    = list(string)
  }))
}

variable "toleration" {
  description = "setting a toleration to assign deployment to a specific tainted node"
  default     = []
  type = list(object({
    effect            = optional(string)
    key               = optional(string)
    operator          = optional(string)
    tolerationSeconds = optional(string)
    value             = optional(string)
  }))
}