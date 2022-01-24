locals {
  pvcEnabled = var.persistence.forceDisable == false && contains(["deployment", "cronjob", "statefulset"], var.podResourceType) ? var.persistence.enablePersistence : false
}

resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  count            = local.pvcEnabled && var.podResourceType != "statefulset" ? 1 : 0
  wait_until_bound = var.tfWaitForRollout

  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }


  spec {
    storage_class_name = var.persistence.storageClassName
    access_modes       = var.persistence.storageAccessModes
    resources {
      requests = {
        storage = var.persistence.storageSize
      }
    }

  }

  lifecycle {
    prevent_destroy = true
  }
}
