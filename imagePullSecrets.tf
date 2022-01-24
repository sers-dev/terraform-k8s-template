data "kubernetes_secret_v1" "imagePullSecret" {
  count = length(var.imagePullSecretNames)

  metadata {
    namespace = var.consistency.hard.namespace
    name      = var.imagePullSecretNames[count.index]
  }
}