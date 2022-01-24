locals {
  secretEnvEnabled  = length(var.applicationConfig.secretEnv) != 0
  secretEnvHashData = var.applicationConfig.triggerRollingUpdate.secretEnv ? concat(keys(var.applicationConfig.secretEnv), values(var.applicationConfig.secretEnv)) : []
}

resource "kubernetes_secret_v1" "secretEnv" {
  count = local.secretEnvEnabled ? 1 : 0

  metadata {
    name      = "${var.consistency.hard.namespaceUniqueName}-env"
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  data = var.applicationConfig.secretEnv
}

