locals {
  configEnvEnabled  = length(var.applicationConfig.configEnv) != 0
  configEnvHashData = var.applicationConfig.triggerRollingUpdate.configEnv ? concat(keys(var.applicationConfig.configEnv), values(var.applicationConfig.configEnv)) : []
}

resource "kubernetes_config_map_v1" "configEnv" {
  count = local.configEnvEnabled ? 1 : 0

  metadata {
    name      = "${var.consistency.hard.namespaceUniqueName}-env"
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  data = var.applicationConfig.configEnv
}