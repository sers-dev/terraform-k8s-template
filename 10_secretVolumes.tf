locals {
  secretVolumeHashData = var.applicationConfig.triggerRollingUpdate.secretVolumes ? [for k, v in var.applicationConfig.secretVolumes : join("", concat(keys(v.data), values(v.data)))] : []
}
resource "kubernetes_secret_v1" "secretVolume" {
  for_each = var.applicationConfig.secretVolumes

  metadata {
    name      = "${var.consistency.hard.namespaceUniqueName}-volume-${each.key}"
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  data        = each.value.data
  binary_data = each.value.binaryData

}
