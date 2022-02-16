locals {
  serviceClusterIpEnabled = length(local.serviceClusterIpPorts) > 0

  serviceHeadlessEnabled = length(local.serviceHeadlessPorts) > 0

  serviceLoadBalancerTcpRequired = length(local.serviceLoadBalancerPortsTcp) > 0
  serviceLoadBalancerTcpEnabled  = local.serviceLoadBalancerTcpRequired && length(var.service.loadBalancer) > 0

  serviceLoadBalancerUdpRequired = length(local.serviceLoadBalancerPortsUdp) > 0
  serviceLoadBalancerUdpEnabled  = local.serviceLoadBalancerUdpRequired && length(var.service.loadBalancer) > 0

  ports = flatten([
    for k, v in var.containers : v.ports
  ])

  serviceClusterIpPorts = flatten([
    for k, v in local.ports : contains(v.serviceTypes, "ClusterIP") ? [v] : []
  ])

  serviceHeadlessPorts = flatten([
    for k, v in local.ports : contains(v.serviceTypes, "Headless") ? [v] : []
  ])

  serviceLoadBalancerPorts = flatten([
    for k, v in local.ports : contains(v.serviceTypes, "LoadBalancer") ? [v] : []
  ])

  serviceLoadBalancerPortsTcp = flatten([
    for k, v in local.serviceLoadBalancerPorts : v.protocol == "TCP" ? [v] : []
  ])

  serviceLoadBalancerPortsUdp = flatten([
    for k, v in local.serviceLoadBalancerPorts : v.protocol == "UDP" ? [v] : []
  ])

}

variable "service" {
  type = object({
    clusterIp = object({
      ip                       = string
      publishNotReadyAddresses = bool
      sessionAffinity          = string
      annotations              = map(string)
    })
    headless = object({
      publishNotReadyAddresses = bool
      sessionAffinity          = string
      annotations              = map(string)
    })
    loadBalancer = list(object({
      publishNotReadyAddresses = bool
      sessionAffinity          = string
      externalTrafficPolicy    = string
      sourceRanges             = list(string)
      annotations              = map(string)
      remapPorts               = map(string)
    }))
  })
}

resource "kubernetes_service_v1" "clusterIp" {
  count = local.serviceClusterIpEnabled ? 1 : 0

  metadata {
    name        = var.consistency.hard.namespaceUniqueName
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.service.clusterIp.annotations
  }

  spec {
    type                        = "ClusterIP"
    cluster_ip                  = var.service.clusterIp.ip
    publish_not_ready_addresses = var.service.clusterIp.publishNotReadyAddresses
    session_affinity            = var.service.clusterIp.sessionAffinity

    dynamic "port" {
      for_each = local.serviceClusterIpPorts
      content {
        name        = port.value.name
        target_port = port.value.name
        port        = port.value.port
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }

}

resource "kubernetes_service_v1" "headless" {
  count = local.serviceHeadlessEnabled ? 1 : 0

  metadata {
    name        = "${var.consistency.hard.namespaceUniqueName}-headless"
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.service.headless.annotations
  }

  spec {
    type                        = "ClusterIP"
    cluster_ip                  = "None"
    publish_not_ready_addresses = var.service.headless.publishNotReadyAddresses
    session_affinity            = var.service.headless.sessionAffinity

    dynamic "port" {
      for_each = local.serviceHeadlessPorts
      content {
        name        = port.value.name
        target_port = port.value.name
        port        = port.value.port
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }

}

resource "kubernetes_service_v1" "loadBalancerTcp" {
  count = local.serviceLoadBalancerTcpEnabled ? length(var.service.loadBalancer) : 0

  wait_for_load_balancer = var.tfWaitForRollout

  metadata {
    name        = "${var.consistency.hard.namespaceUniqueName}-tcp-${count.index}"
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.service.loadBalancer[count.index].annotations
  }

  spec {
    type                        = "LoadBalancer"
    publish_not_ready_addresses = var.service.loadBalancer[count.index].publishNotReadyAddresses
    session_affinity            = var.service.loadBalancer[count.index].sessionAffinity
    external_traffic_policy     = var.service.loadBalancer[count.index].externalTrafficPolicy
    load_balancer_source_ranges = var.service.loadBalancer[count.index].sourceRanges

    dynamic "port" {
      for_each = local.serviceLoadBalancerPortsTcp
      content {
        name        = port.value.name
        target_port = port.value.name
        port        = lookup(var.service.loadBalancer[count.index].remapPorts, port.value.name, port.value.port)
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }
}

resource "kubernetes_service_v1" "loadbalancerUdp" {
  count = local.serviceLoadBalancerUdpEnabled ? length(var.service.loadBalancer) : 0

  wait_for_load_balancer = var.tfWaitForRollout

  metadata {
    name        = "${var.consistency.hard.namespaceUniqueName}-udp-${count.index}"
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.service.loadBalancer[count.index].annotations
  }

  spec {
    type                        = "LoadBalancer"
    publish_not_ready_addresses = var.service.loadBalancer[count.index].publishNotReadyAddresses
    session_affinity            = var.service.loadBalancer[count.index].sessionAffinity
    external_traffic_policy     = var.service.loadBalancer[count.index].externalTrafficPolicy
    load_balancer_source_ranges = var.service.loadBalancer[count.index].sourceRanges

    dynamic "port" {
      for_each = local.serviceLoadBalancerPortsUdp
      content {
        name        = port.value.name
        target_port = port.value.name
        port        = lookup(var.service.loadBalancer[count.index].remapPorts, port.value.name, port.value.port)
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }
}