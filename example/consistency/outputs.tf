output "all" {
  value = {
    hard = {
      clusterUniqueName   = "${var.instance}-${local.name}-${var.namespace}"
      namespaceUniqueName = "${var.instance}-${local.name}"
      namespace           = var.namespace
      clusterName         = var.clusterName
    }

    soft = {
      matchLabels  = merge(var.additionalLabels, local.matchLabels)
      labels       = merge(var.additionalLabels, local.labels)
      nodeSelector = merge(var.additionalNodeSelectorLabels, local.nodeSelectorLabels)
    }

  }
}