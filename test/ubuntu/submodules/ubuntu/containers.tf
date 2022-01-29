locals {
  containers = {
    "ubuntu" = {
      image = var.image
      args = [
      ]

      //custom command
      customCommand = {
        enabled = false
        data    = ""
      }

      resources = {
        S = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            memory = "256Mi"
            cpu    = null
          }
        }
      }

      ports = [
      ]

      postStart = {
        exec = {
          enabled = false
          command = ["/bin/sleep", 1]
        }
        httpGet = {
          enabled = false
          path    = "/"
          port    = "none"
          host    = ""
          scheme  = "http"
          header  = {}
        }
        tcpSocket = {
          enabled = false
          port    = "none"
        }
      }
      preStop = {
        exec = {
          enabled = false
          command = ["/bin/sleep", 1]
        }
        httpGet = {
          enabled = false
          path    = "/"
          port    = "none"
          host    = ""
          scheme  = "http"
          header  = {}
        }
        tcpSocket = {
          enabled = false
          port    = "none"
        }
      }

      probes = {
        startup = {
          initialDelaySeconds = 5
          successThreshold    = 1
          failureThreshold    = 60
          periodSeconds       = 3
          timeoutSeconds      = 1

          exec = {
            enabled = false
            command = []
          }
          httpGet = {
            enabled = false
            path    = "/"
            port    = "none"
            host    = ""
            scheme  = "http"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "none"
          }
        }

        readiness = {
          initialDelaySeconds = 5
          successThreshold    = 1
          failureThreshold    = 60
          periodSeconds       = 3
          timeoutSeconds      = 1

          exec = {
            enabled = false
            command = []
          }
          httpGet = {
            enabled = false
            path    = "/"
            port    = "none"
            host    = ""
            scheme  = "http"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "none"
          }
        }

        liveness = {
          initialDelaySeconds = 5
          successThreshold    = 1
          failureThreshold    = 60
          periodSeconds       = 3
          timeoutSeconds      = 1

          exec = {
            enabled = false
            command = []
          }
          httpGet = {
            enabled = false
            path    = "/"
            port    = "none"
            host    = ""
            scheme  = "http"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "none"
          }
        }
      }

      imagePullPolicy          = "IfNotPresent"
      stdin                    = true
      stdinOnce                = false
      terminationMessagePath   = null
      terminationMessagePolicy = null
      tty                      = true
      workingDir               = ""

      securityContext = {
        allowPrivilegeEscalation = false
        capabilities = {
          add  = null
          drop = null
        }
        readOnlyRootFilesystem = false
        privileged             = false
        runAsGroup             = null
        runAsNonRoot           = null
        runAsUser              = null
      }
    }
  }
}