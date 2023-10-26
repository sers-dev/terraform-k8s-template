locals {
  requireMutatingWebhook = false
}

locals {
  enableMutatingWebhook = var.forceDisableWebhooks ? false : local.requireMutatingWebhook
}

resource "kubernetes_mutating_webhook_configuration_v1" "webhook" {
  count = local.enableMutatingWebhook ? 1 : 0

  metadata {
    name        = module.consistency.all.hard.clusterUniqueName
    labels      = module.consistency.all.soft.labels
    annotations = {}
  }
  webhook {
    name = ""
    client_config {
      service {
        name      = module.template.serviceName
        namespace = module.consistency.all.hard.namespace
        path      = "/"
        port      = 443
      }
      ca_bundle = local.enableSelfSignedWebhooks ? module.tls.0.caBundle : null
    }
  }

}