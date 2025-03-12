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
variable "infraOverrideConfig" {
  type = object({
    replicas = optional(object({
      min = optional(number, null)
      max = optional(number, null)
    }), {})
    resources = optional(map(object({
      requests = optional(object({
        cpu = optional(string, null)
        memory = optional(string, null)
      }), {})
      limits = optional(object({
        cpu    = optional(string, null)
        memory = optional(string, null)
      }), {})
    })), {})
  })
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
