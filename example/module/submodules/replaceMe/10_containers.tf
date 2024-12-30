locals {
  containers = {
    "replaceMe" = {
      image = var.image
      args = [
        #replaceMe
      ]

      //custom command
      customCommand = {
        enabled = false
        data    = "" #templatefile("${path.module}/files/replaceMe", {})
      }

      resources = {
        S = {
          requests = {
            cpu    = "replaceMe"
            memory = "replaceMe"
          }
          limits = {
            memory = "replaceMe"
            cpu    = null
          }
        }
      }

      ports = [
        #{
        #  port           = 8080
        #  host_ip        = null
        #  name           = "replaceMe"
        #  protocol       = "TCP"
        #  ingressEnabled = true
        #  serviceTypes = ["Headless", "ClusterIP", "LoadBalancer"]
        #},
      ]

      postStart = {
        exec = {
          enabled = false
          command = ["/bin/sleep", 1]
        }
        httpGet = {
          enabled = false
          path    = "/"
          port    = "replaceMe"
          host    = ""
          scheme  = "HTTP"
          header  = {}
        }
        tcpSocket = {
          enabled = false
          port    = "replaceMe"
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
          port    = "replaceMe"
          host    = ""
          scheme  = "HTTP"
          header  = {}
        }
        tcpSocket = {
          enabled = false
          port    = "replaceMe"
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
            port    = "replaceMe"
            host    = ""
            scheme  = "HTTP"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "replaceMe"
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
            port    = "replaceMe"
            host    = ""
            scheme  = "HTTP"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "replaceMe"
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
            port    = "replaceMe"
            host    = ""
            scheme  = "HTTP"
            header  = {}
          }
          tcpSocket = {
            enabled = false
            port    = "replaceMe"
          }
        }
      }

      imagePullPolicy          = "IfNotPresent"
      stdin                    = false
      stdinOnce                = false
      terminationMessagePath   = null
      terminationMessagePolicy = null
      tty                      = false
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

        seccompProfile = {
          type = "Unconfined"
        }
      }
    }
  }
}