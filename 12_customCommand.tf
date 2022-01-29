locals {
  customCommandFileNameSuffix = "CustomCommand.sh"
  customCommandMountPath      = "/custom-command"
  customCommandsHashData      = [for k, v in merge(var.initContainers, var.containers) : var.applicationConfig.triggerRollingUpdate.customCommands ? v.customCommand.data : ""]
  customCommandFileNames = compact([
    for k, v in merge(var.initContainers, var.containers) : v.customCommand.enabled ? "${k}${local.customCommandFileNameSuffix}" : ""
  ])
  customCommandFileData = compact([
    for k, v in merge(var.initContainers, var.containers) : v.customCommand.enabled ? v.customCommand.data : ""
  ])
  customCommands       = zipmap(local.customCommandFileNames, local.customCommandFileData)
  customCommandEnabled = length(local.customCommands) > 0
}

resource "kubernetes_secret_v1" "customCommand" {
  count = local.customCommandEnabled ? 1 : 0

  metadata {
    name      = "${var.consistency.hard.namespaceUniqueName}-cmd"
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  data = local.customCommands
}