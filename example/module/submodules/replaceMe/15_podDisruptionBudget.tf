locals {
  podDisruptionBudget = {
    enabled        = false
    maxUnavailable = null
    minAvailable   = 1
  }
}