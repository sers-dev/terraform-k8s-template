locals {
  volumes = {
    emptyDir = {
      #"tmp" = {
      #  path = "/tmp"
      #  medium = "Memory"
      #  size_limit = "10Mi"
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