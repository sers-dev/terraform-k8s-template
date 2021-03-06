variable "initContainers" {
  type = map(object({
    image                    = string
    imagePullPolicy          = string
    stdin                    = bool
    stdinOnce                = bool
    terminationMessagePath   = string
    terminationMessagePolicy = string
    tty                      = bool
    workingDir               = string
    securityContext = object({
      allowPrivilegeEscalation = bool
      capabilities = object({
        add  = list(string)
        drop = list(string)
      })
      readOnlyRootFilesystem = bool
      privileged             = bool
      runAsGroup             = string
      runAsNonRoot           = bool
      runAsUser              = string
    })

    args = list(string)


    resources = map(object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    }))

    customCommand = object({
      enabled = bool
      data    = string
    })

    preStop = object({
      exec = object({
        enabled = bool
        command = list(string)
      })
      httpGet = object({
        enabled = bool
        path    = string
        port    = string
        host    = string
        scheme  = string
        header  = map(string)
      })
      tcpSocket = object({
        enabled = bool
        port    = string
      })
    })

    postStart = object({
      exec = object({
        enabled = bool
        command = list(string)
      })
      httpGet = object({
        enabled = bool
        path    = string
        port    = string
        host    = string
        scheme  = string
        header  = map(string)
      })
      tcpSocket = object({
        enabled = bool
        port    = string
      })
    })


  }))
}