resource "kubernetes_pod_disruption_budget_v1" "podDisruptionBudget" {
  count = contains(["statefulset", "deployment"], var.podResourceType) && var.podDisruptionBudget.enabled ? 1 : 0

  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }


  spec {
    selector {
      match_labels = var.consistency.soft.matchLabels
    }
    min_available = var.podDisruptionBudget.minAvailable
  }
}