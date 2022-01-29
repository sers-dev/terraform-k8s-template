locals {
  configVolumeHashData = var.applicationConfig.triggerRollingUpdate.configVolumes ? [for k, v in var.applicationConfig.configVolumes : join("", concat(keys(v.data), values(v.data)))] : []
}

resource "kubernetes_config_map_v1" "configVolume" {
  for_each = var.applicationConfig.configVolumes

  metadata {
    name      = "${var.consistency.hard.namespaceUniqueName}-volume-${each.key}"
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  data        = each.value.data
  binary_data = each.value.binaryData


}