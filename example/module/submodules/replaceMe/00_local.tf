locals {
  forceHostPathEnabled = var.persistence.forceHostPath != null

  preparedPersistence = merge(local.persistence, {
    forceDisable       = (local.forceHostPathEnabled || var.persistence.forceDisable)
    storageSize        = var.persistence.storageSize
    storageClassName   = var.persistence.storageClassName
    storageAccessModes = var.persistence.storageAccessModes
  })

  tmphostPath = var.persistence.forceHostPath == null ? "" : var.persistence.forceHostPath
  preparedHostPath = startswith(local.tmphostPath, "/") ? local.tmphostPath : "/${local.tmphostPath}"
  normalizedHostpath = trimsuffix(local.preparedHostPath, "/")
  preparedVolumes = local.forceHostPathEnabled && local.persistence.enablePersistence ? merge({
    hostPath = { for mount in local.persistence.mounts:
      replace("${local.normalizedHostpath}${mount.volumePath == null ? "" : mount.volumePath}", "/", "") => {
        hostPath    = "${local.normalizedHostpath}/${trimprefix(mount.volumePath == null ? "" : mount.volumePath, "/")}"
        path        = mount.containerPath
        propagation = "None"
        type        = "Directory"
      }
    }
  }, local.volumes) : local.volumes

}