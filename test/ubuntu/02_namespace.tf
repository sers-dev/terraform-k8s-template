resource "kubernetes_namespace" "namespace" {
  count = var.createNamespace ? 1 : 0

  metadata {
    name   = var.namespace
    labels = var.additionalLabels
  }
}

locals {
  namespace = var.createNamespace ? kubernetes_namespace.namespace[0].id : var.namespace
}