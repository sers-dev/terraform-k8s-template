locals {
  crds = [
  ]
}

resource "kubernetes_manifest" "crds" {
  for_each = var.forceDisableCRDs ? {} : zipmap(local.crds, local.crds)

  manifest = yamldecode(file("${path.module}/files/crds/${each.value}"))

  computed_fields = [
  ]
}