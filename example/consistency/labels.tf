locals {
  labels = merge({
    "app.kubernetes.io/tf-template-version" = var.tfTemplateVersion
    "app.kubernetes.io/tf-module-version"   = var.tfModuleVersion
    "app.kubernetes.io/tf-module"           = var.tfModule
    "app.kubernetes.io/owner"               = var.owner
    "app.kubernetes.io/managed-by"          = "terraform"
  }, local.matchLabels)
  matchLabels = {
    "app.kubernetes.io/name"     = local.name
    "app.kubernetes.io/instance" = var.instance
  }
  nodeSelectorLabels = {
    "kubernetes.io/os"   = var.operatingSystem
    "kubernetes.io/arch" = var.architecture
  }
}

output "matchLabels" {
  value = merge(var.additionalLabels, local.matchLabels)
}

output "labels" {
  value = merge(var.additionalLabels, local.labels)
}

output "nodeSelector" {
  value = merge(var.additionalNodeSelectorLabels, local.nodeSelectorLabels)
}