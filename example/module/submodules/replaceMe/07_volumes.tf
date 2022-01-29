locals {
  volumes = {
    emptyDir = {
      #"tmp" = {
      #  path = "/tmp"
      #  medium = "Memory"
      #  sizeLimit = "10Mi"
      #}
    }
    hostPath = {
      #"tmp" = {
      #  hostPath = "/tmp"
      #  path = "/tmp"
      #  type = ""
      #}
    }
  }
}