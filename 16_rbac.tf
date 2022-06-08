resource "kubernetes_service_account_v1" "serviceAccount" {
  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding_v1" "clusterRoleBinding" {
  count = length(var.rbac.clusterRoleRules) > 0 ? 1 : 0

  metadata {
    name   = var.consistency.hard.clusterUniqueName
    labels = var.consistency.soft.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.clusterRole.0.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    api_group = ""
    name      = kubernetes_service_account_v1.serviceAccount.metadata.0.name
    namespace = var.consistency.hard.namespace
  }
}

resource "kubernetes_cluster_role_v1" "clusterRole" {
  count = length(var.rbac.clusterRoleRules) > 0 ? 1 : 0

  metadata {
    name   = var.consistency.hard.clusterUniqueName
    labels = var.consistency.soft.labels
  }

  dynamic "rule" {
    for_each = var.rbac.clusterRoleRules
    content {
      api_groups        = rule.value.apiGroups
      resources         = rule.value.resources
      verbs             = rule.value.verbs
      resource_names    = rule.value.resourceNames
      non_resource_urls = rule.value.nonResourceUrls
    }
  }

}

###

resource "kubernetes_role_binding_v1" "roleBinding" {
  count = length(var.rbac.roleRules) > 0 ? 1 : 0

  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    namespace = var.consistency.hard.namespace
    labels    = var.consistency.soft.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.role.0.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    api_group = ""
    name      = kubernetes_service_account_v1.serviceAccount.metadata.0.name
    namespace = var.consistency.hard.namespace
  }
}

resource "kubernetes_role_v1" "role" {
  count = length(var.rbac.roleRules) > 0 ? 1 : 0

  metadata {
    name      = var.consistency.hard.namespaceUniqueName
    labels    = var.consistency.soft.labels
    namespace = var.consistency.hard.namespace
  }

  dynamic "rule" {
    for_each = var.rbac.roleRules
    content {
      api_groups        = rule.value.apiGroups
      resources         = rule.value.resources
      verbs             = rule.value.verbs
      resource_names    = rule.value.resourceNames
    }
  }

}
