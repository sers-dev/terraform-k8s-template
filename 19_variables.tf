variable "tfWaitForRollout" {
  type = bool
}

variable "imagePullSecretNames" {
  type = list(string)
}

variable "operatingSystem" {}
variable "architecture" {}

variable "infrastructureSize" {}

variable "consistency" {
  type = object({
    hard = object({
      namespace           = string
      namespaceUniqueName = string
      clusterUniqueName   = string
      clusterName         = string
    })
    soft = object({
      labels       = map(string)
      matchLabels  = map(string)
      nodeSelector = map(string)
    })
  })
}

variable "rbac" {
  description = "K8S permissions"
  type = object({
    clusterRoleRules = list(object({
      apiGroups       = list(string)
      resources       = list(string)
      verbs           = list(string)
      resourceNames   = optional(list(string), [])
      nonResourceUrls = optional(list(string), [])
    }))
    roleRules = list(object({
      apiGroups     = list(string)
      resources     = list(string)
      verbs         = list(string)
      resourceNames = optional(list(string), [])
    }))
  })
}

variable "persistence" {
  description = "K8S persistence configuration"
  type = object({
    #configured per module
    enablePersistence = bool
    mounts = list(object({
      containerPath = string,
      volumePath    = string
    }))
    #configured per instance
    forceDisable       = bool
    storageSize        = string
    storageClassName   = string
    storageAccessModes = list(string)
  })
}

variable "podResourceType" {
  description = "The type of resource to be used to manage the pod"
  type        = string
  validation {
    condition = contains([
      "deployment",
      "daemonset",
      "statefulset",
      "job",
      "cronjob",
      "none"
    ], var.podResourceType)
    error_message = "Must be one of \"deployment\", \"daemonset\", \"statefulset\", \"job\", \"cronjob\", \"none\"."
  }
}


variable "applicationConfig" {
  type = object({
    triggerRollingUpdate = optional(object({
      configEnv      = optional(bool, true)
      configVolumes  = optional(bool, true)
      secretEnv      = optional(bool, true)
      secretVolumes  = optional(bool, true)
      customCommands = optional(bool, true)
    }), {})

    externalConfigEnvs = optional(list(string), [])
    externalSecretEnvs = optional(list(string), [])
    externalConfigVolumes = optional(map(object({
      defaultMode = optional(string, 0755)
      path        = string
    })), {})
    externalSecretVolumes = optional(map(object({
      defaultMode = optional(string, 0600)
      path        = string
    })), {})
    configEnv = optional(map(string), {})
    secretEnv = optional(map(string), {})
    envFieldRef = optional(map(object({
      version = optional(string, "v1")
      field   = string
    })), {})
    configVolumes = optional(map(object({
      defaultMode = optional(string, 0644)
      path        = string
      data        = optional(map(string), {})
      binaryData  = optional(map(string), {})
      enableSubpathMount = optional(bool, false)
    })), {})
    secretVolumes = optional(map(object({
      defaultMode = optional(string, 0644)
      path        = string
      data        = optional(map(string), {})
      binaryData  = optional(map(string), {})
      enableSubpathMount = optional(bool, false)
    })), {})
  })

  default = {}
}
variable "dns" {
  type = object({
    policy = optional(string, "ClusterFirst")
    config = optional(object({
      nameservers = optional(list(string), [])
      searches    = optional(list(string), [])
      options     = optional(map(string), { "ndots" = "2"})
    }), {})
  })

  default = {}
}

variable "hostConfig" {
  type = object({
    hostNetwork           = optional(bool, false)
    hostIpc               = optional(bool, false)
    hostPid               = optional(bool, false)
    hostname              = optional(string, "")
    shareProcessNamespace = optional(bool, true)
    hostAliases           = optional(map(list(string)), {})
    securityContext = optional(object({
      fsGroup            = optional(string, null)
      runAsGroup         = optional(string, null)
      runAsNonRoot       = optional(bool, null)
      runAsUser          = optional(string, null)
      supplementalGroups = optional(list(string), [])
    }), {})

  })

  default = {}
}
locals {
  #this check is required because the current version of the k8s provider (2.6.1) would always display a change if no value is set within the securityContext
  globalSecurityContextEnabled = var.hostConfig.securityContext.fsGroup != null || var.hostConfig.securityContext.runAsUser != null || var.hostConfig.securityContext.runAsGroup != null || var.hostConfig.securityContext.runAsNonRoot != null || length(var.hostConfig.securityContext.supplementalGroups) > 0
}

variable "podResourceTypeConfig" {
  type = object({
    podAnnotations = map(string)
    annotations    = map(string)

    minReplicas                   = string
    maxReplicas                   = string
    terminationGracePeriodSeconds = optional(string, 10)
    minReadySeconds               = optional(string, 0)
    deadlineSeconds               = optional(string, 120)
    revisionHistoryLimit          = optional(string, 3)

    rollingUpdate = optional(object({
      maxSurge       = optional(string, "25%")
      maxUnavailable = optional(string, "25%")
    }), {})
    podManagementPolicy = optional(string, "OrderedReady")

    tolerations = optional(map(object({
      effect            = optional(string)
      key               = optional(string)
      operator          = optional(string)
      tolerationSeconds = optional(string)
      value             = optional(string)
    })), {})

    // cronjob only
    // min, hour, day of month, month, day of week
    schedule                   = optional(string, null)
    concurrencyPolicy          = optional(string, "Forbid")
    failedJobsHistoryLimit     = optional(string, 3)
    successfulJobsHistoryLimit = optional(string, 3)
    suspend                    = optional(bool, false)

    // job only
    backoffLimit            = optional(string, 6)
    ttlSecondsAfterFinished = optional(string, null)
    completions             = optional(string, null)




    priorityClassName = optional(string, "")
    restartPolicy     = optional(string, "Always")



  })
}

variable "topologySpread" {
  type = list(object({
    maxSkew           = optional(string, 1)
    topologyKey       = string
    whenUnsatisfiable = optional(string, "DoNotSchedule")
  }))
  default = [{
    topologyKey = "kubernetes.io/hostname"
  }]
}



variable "volumes" {
  type = object({
    emptyDir = optional(map(object({
      path      = string
      medium    = string
      sizeLimit = string
    })), {})
    hostPath = optional(map(object({
      hostPath    = string
      path        = string
      type        = string
      propagation = string
    })), {})
  })

  default = {}
}

variable "podDisruptionBudget" {
  type = object({
    enabled      = optional(bool, false)
    minAvailable = optional(string, 1)
  })
  default = {}
}

variable "horizontalPodAutoscaler" {
  type = object({
    enabled = bool
    metrics = optional(list(object({
      type = string
      name = string
      describedObject = optional(object({
        apiVersion = string
        kind       = string
      }), null)
      metric = optional(object({
        matchLabels = map(string)
      }), null)
      target = optional(object({
        type               = optional(string, "Utilization")
        averageValue       = optional(string, 0)
        averageUtilization = optional(string, 75)
        value              = optional(string, null)
      }), {})
    })), [{ type = "Resource", name = "cpu"}])
    behavior = optional(object({
      scaleDown = optional(object({
        stabilizationWindowSeconds = optional(string, 300)
        selectPolicy               = optional(string, "Min")
        policies = optional(list(object({
          periodSeconds = string
          type          = optional(string, "Percent")
          value         = string
        })), [{ periodSeconds = 60, value = "25"}])
      }), {})
      scaleUp = optional(object({
        stabilizationWindowSeconds = optional(string, 300)
        selectPolicy               = optional(string, "Max")
        policies = optional(list(object({
          periodSeconds = string
          type          = optional(string, "Percent")
          value         = string
        })), [{ periodSeconds = 15, value = "100"}])
      }), {})
    }), {})
  })
}

variable "ingress" {
  type = map(object({
    tlsEnabled       = bool
    ingressClassName = string
    pathType         = optional(string, "Prefix")
    annotations      = optional(map(string), {})
    fqdns            = list(string)
    overridePaths    = optional(list(string), [])
  }))
}
