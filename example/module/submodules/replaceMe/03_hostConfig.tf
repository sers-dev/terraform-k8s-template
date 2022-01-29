locals {
  hostConfig = {
    hostNetwork           = false
    hostIpc               = false
    hostPid               = false
    hostname              = ""
    shareProcessNamespace = false
    securityContext = {
      fsGroup            = null
      runAsGroup         = null
      runAsNonRoot       = null
      runAsUser          = null
      supplementalGroups = []
    }
    hostAliases = {
      #"127.0.0.1" = [
      #  "local"
      #]
    }
  }
}