locals {
  ingressPort = one(flatten([
    for k, v in local.serviceClusterIpPorts : v.ingressEnabled ? [v] : []
  ]))

  ingressEnabled = local.ingressPort != null ? local.serviceClusterIpEnabled : false

}

resource "kubernetes_ingress_v1" "ingress" {
  for_each = local.ingressEnabled ? var.ingress : {}

  metadata {
    name        = "${var.consistency.hard.namespaceUniqueName}-${each.key}"
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = each.value.annotations
  }
  spec {
    ingress_class_name = each.value.ingressClassName
    dynamic "rule" {
      for_each = length(each.value.overridePaths) == 0 ? each.value.fqdns : []
      content {
        host = rule.value
        http {
          path {
            backend {
              service {
                name = kubernetes_service_v1.clusterIp.0.metadata.0.name
                port {
                  name = local.ingressPort.name
                }
              }
            }
            path = "/"
          }
        }
      }
    }
    dynamic "rule" {
      for_each = length(each.value.overridePaths) != 0 ? each.value.fqdns : []
      content {
        host = rule.value
        http {
          dynamic "path" {
            for_each = each.value.overridePaths
            content {
              backend {
                service {
                  name = kubernetes_service_v1.clusterIp.0.metadata.0.name
                  port {
                    name = local.ingressPort.name
                  }
                }
              }
              path = path.value
            }
          }
        }
      }
    }

    dynamic "tls" {
      for_each = each.value.fqdns
      content {
        hosts       = [tls.value]
        secret_name = "tls-${tls.value}"
      }
    }
  }
}
