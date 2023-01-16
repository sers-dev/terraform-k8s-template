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
      resourceNames   = list(string)
      nonResourceUrls = list(string)
    }))
    roleRules = list(object({
      apiGroups     = list(string)
      resources     = list(string)
      verbs         = list(string)
      resourceNames = list(string)
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
    ], var.podResourceType)
    error_message = "Must be one of \"deployment\", \"daemonset\", \"statefulset\", \"job\", \"cronjob\"."
  }
}


variable "applicationConfig" {
  type = object({
    triggerRollingUpdate = object({
      configEnv      = bool
      configVolumes  = bool
      secretEnv      = bool
      secretVolumes  = bool
      customCommands = bool
    })

    externalConfigEnvs = list(string)
    externalSecretEnvs = list(string)
    externalConfigVolumes = map(object({
      defaultMode = string
      path        = string
    }))
    externalSecretVolumes = map(object({
      defaultMode = string
      path        = string
    }))
    configEnv = map(string)
    secretEnv = map(string)
    envFieldRef = map(object({
      version = string
      field   = string
    }))
    configVolumes = map(object({
      defaultMode = string
      path        = string
      data        = map(string)
      binaryData  = map(string)
    }))
    secretVolumes = map(object({
      defaultMode = string
      path        = string
      data        = map(string)
      binaryData  = map(string)
    }))
  })
}
variable "dns" {
  type = object({
    policy = string
    config = object({
      nameservers = list(string)
      searches    = list(string)
      options     = map(string)
    })
  })
}

variable "hostConfig" {
  type = object({
    hostNetwork           = bool
    hostIpc               = bool
    hostPid               = bool
    hostname              = string
    shareProcessNamespace = bool
    hostAliases           = map(list(string))
    securityContext = object({
      fsGroup            = string
      runAsGroup         = string
      runAsNonRoot       = bool
      runAsUser          = string
      supplementalGroups = list(string)
    })

  })
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
    terminationGracePeriodSeconds = string
    minReadySeconds               = string
    deadlineSeconds               = string
    revisionHistoryLimit          = string

    rollingUpdate = object({
      maxSurge       = string
      maxUnavailable = string
    })

    // cronjob only
    // min, hour, day of month, month, day of week
    schedule                   = string
    concurrencyPolicy          = string
    failedJobsHistoryLimit     = string
    successfulJobsHistoryLimit = string
    suspend                    = bool

    // job only
    backoffLimit            = string
    ttlSecondsAfterFinished = string
    completions             = string




    priorityClassName = string
    restartPolicy     = string



  })
}

variable "toleration" {
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
}

variable "topologySpread" {
  type = list(object({
    maxSkew           = string
    topologyKey       = string
    whenUnsatisfiable = string
  }))
}



variable "volumes" {
  type = object({
    emptyDir = map(object({
      path      = string
      medium    = string
      sizeLimit = string
    }))
    hostPath = map(object({
      hostPath = string
      path     = string
      type     = string
    }))
  })
}

variable "podDisruptionBudget" {
  type = object({
    enabled      = bool
    minAvailable = string
  })
}

variable "horizontalPodAutoscaler" {
  type = object({
    enabled = bool
    metrics = list(object({
      type = string
      name = string
      describedObject = object({
        apiVersion = string
        kind       = string
      })
      metric = object({
        matchLabels = map(string)
      })
      target = object({
        type               = string
        averageValue       = string
        averageUtilization = string
        value              = string
      })
    }))
    behavior = object({
      scaleDown = object({
        stabilizationWindowSeconds = string
        selectPolicy               = string
        policies = list(object({
          periodSeconds = string
          type          = string
          value         = string
        }))
      })
      scaleUp = object({
        stabilizationWindowSeconds = string
        selectPolicy               = string
        policies = list(object({
          periodSeconds = string
          type          = string
          value         = string
        }))
      })
    })
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
