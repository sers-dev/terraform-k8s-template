locals {
  horizontalPodAutoscalerEnabled = contains(["deployment", "statefulset"], var.podResourceType) ? var.podResourceTypeConfig.minReplicas < var.podResourceTypeConfig.maxReplicas ? var.horizontalPodAutoscaler.enabled : false : false
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "horizontalPodAutoscaler" {
  count = local.horizontalPodAutoscalerEnabled ? 1 : 0

  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  spec {
    min_replicas = var.podResourceTypeConfig.minReplicas
    max_replicas = var.podResourceTypeConfig.maxReplicas

    scale_target_ref {
      kind = var.podResourceType == "deployment" ? "Deployment" : "StatefulSet"
      name = var.podResourceType == "deployment" ? kubernetes_deployment_v1.deployment.0.metadata.0.name : kubernetes_stateful_set_v1.statefulset.0.metadata.0.name
      api_version = "apps/v1"
    }

    dynamic "metric" {
      for_each = var.horizontalPodAutoscaler.metrics
      content {
        type = metric.value.type
        dynamic "object" {
          for_each = metric.value.type == "Object" ? [1] : []
          content {
            described_object {
              api_version = metric.value.describedObject.apiVersion
              kind        = metric.value.describedObject.kind
              name        = metric.value.name
            }
            metric {
              name = metric.value.metric.name
              selector {
                match_labels = metric.value.metric.selector.matchLabels
              }
            }
            target {
              type                = metric.value.target.type
              average_value       = metric.value.target.averageValue == 0 ? null : metric.value.target.averageValue
              average_utilization = metric.value.target.averageUtilization == 0 ? null : metric.value.target.averageUtilization
              value               = metric.value.target.value
            }
          }
        }
        dynamic "pods" {
          for_each = metric.value.type == "Pods" ? [1] : []
          content {
            metric {
              name = metric.value.name
              selector {
                match_labels = metric.value.metric.matchLabels
              }
            }
            target {
              type                = metric.value.target.type
              average_value       = metric.value.target.averageValue == 0 ? null : metric.value.target.averageValue
              average_utilization = metric.value.target.averageUtilization == 0 ? null : metric.value.target.averageUtilization
              value               = metric.value.target.value
            }
          }
        }
        dynamic "resource" {
          for_each = metric.value.type == "Resource" ? [1] : []
          content {
            name = metric.value.name
            target {
              type                = metric.value.target.type
              average_value       = metric.value.target.averageValue == 0 ? null : metric.value.target.averageValue
              average_utilization = metric.value.target.averageUtilization == 0 ? null : metric.value.target.averageUtilization
              value               = metric.value.target.value
            }
          }
        }
        dynamic "external" {
          for_each = metric.value.type == "External" ? [1] : []
          content {
            metric {
              name = metric.value.name
              selector {
                match_labels = metric.value.metric.matchLabels
              }
            }
            target {
              type                = metric.value.target.type
              average_value       = metric.value.target.averageValue == 0 ? null : metric.value.target.averageValue
              average_utilization = metric.value.target.averageUtilization == 0 ? null : metric.value.target.averageUtilization
              value               = metric.value.target.value
            }
          }
        }
      }
    }

    behavior {
      scale_up {
        stabilization_window_seconds = var.horizontalPodAutoscaler.behavior.scaleUp.stabilizationWindowSeconds
        select_policy                = var.horizontalPodAutoscaler.behavior.scaleUp.selectPolicy
        dynamic "policy" {
          for_each = var.horizontalPodAutoscaler.behavior.scaleUp.policies
          content {
            period_seconds = policy.value.periodSeconds
            type           = policy.value.type
            value          = policy.value.value
          }
        }
      }

      scale_down {
        stabilization_window_seconds = var.horizontalPodAutoscaler.behavior.scaleDown.stabilizationWindowSeconds
        select_policy                = var.horizontalPodAutoscaler.behavior.scaleDown.selectPolicy
        dynamic "policy" {
          for_each = var.horizontalPodAutoscaler.behavior.scaleDown.policies
          content {
            period_seconds = policy.value.periodSeconds
            type           = policy.value.type
            value          = policy.value.value
          }
        }
      }

    }
  }
}