variable "initContainers" {
  type = map(object({
    image                    = string
    imagePullPolicy          = optional(string, "IfNotPresent")
    stdin                    = optional(bool, false)
    stdinOnce                = optional(bool, false)
    terminationMessagePath   = optional(string, null)
    terminationMessagePolicy = optional(string, null)
    tty                      = optional(bool, false)
    workingDir               = optional(string, "")
    securityContext = optional(object({
      allowPrivilegeEscalation = optional(bool, false)
      capabilities = optional(object({
        add  = optional(list(string), null)
        drop = optional(list(string), null)
      }), {})
      readOnlyRootFilesystem = optional(bool, false)
      privileged             = optional(bool, false)
      runAsGroup             = optional(string, null)
      runAsNonRoot           = optional(bool, null)
      runAsUser              = optional(string, null)
    }), {})

    args = optional(list(string), [])

    resources = optional(map(object({
      requests = optional(object({
        cpu    = optional(string, "1m")
        memory = optional(string, "1Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string, null)
        memory = optional(string, null)
      }), {})
    })), { default = {}})

    customCommand = optional(object({
      enabled = bool
      data    = string
    }), { enabled = false, data = ""})

    preStop = optional(object({
      exec = optional(object({
        enabled = bool
        command = list(string)
      }), { enabled = false, command = []})
      httpGet = optional(object({
        enabled = bool
        path    = optional(string, "/")
        port    = string
        host    = optional(string, "")
        scheme  = optional(string, "HTTP")
        header  = optional(map(string), {})
      }), { enabled = false, port = null})
      tcpSocket = optional(object({
        enabled = bool
        port    = string
      }), { enabled = false, port = null})
    }), {})

    postStart = optional(object({
      exec = optional(object({
        enabled = bool
        command = list(string)
      }), { enabled = false, command = []})
      httpGet = optional(object({
        enabled = bool
        path    = optional(string, "/")
        port    = string
        host    = optional(string, "")
        scheme  = optional(string, "HTTP")
        header  = optional(map(string), {})
      }), { enabled = false, port = null})
      tcpSocket = optional(object({
        enabled = bool
        port    = string
      }), { enabled = false, port = null})
    }), {})

  }))
}