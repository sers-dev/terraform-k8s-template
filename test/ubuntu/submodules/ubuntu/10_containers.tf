locals {
  containers = {
    "ubuntu" = {
      image = var.image
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
      stdin = true
      tty   = true
    }
  }
}