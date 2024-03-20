locals {
  serviceClusterIpEnabled = length(local.serviceClusterIpPorts) > 0

  serviceHeadlessEnabled = length(local.serviceHeadlessPorts) > 0

  serviceLoadBalancerTcpRequired = length(local.serviceLoadBalancerPortsTcp) > 0
  serviceLoadBalancerTcpEnabled  = local.serviceLoadBalancerTcpRequired && length(var.service.loadBalancer) > 0

  serviceLoadBalancerUdpRequired = length(local.serviceLoadBalancerPortsUdp) > 0
  serviceLoadBalancerUdpEnabled  = local.serviceLoadBalancerUdpRequired && length(var.service.loadBalancer) > 0

  serviceLoadBalancerEnabled = local.serviceLoadBalancerTcpEnabled || local.serviceLoadBalancerUdpEnabled

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


  serviceName         = var.consistency.hard.namespaceUniqueName
  headlessServiceName = "${var.consistency.hard.namespaceUniqueName}-headless"

}

variable "service" {
  type = object({
    clusterIp = optional(object({
      ip                       = optional(string, null)
      publishNotReadyAddresses = optional(bool, false)
      sessionAffinity          = optional(string, "None")
      annotations              = optional(map(string), {})
      remapPorts               = optional(map(string), {})
    }), {})
    headless = optional(object({
      publishNotReadyAddresses = optional(bool, false)
      sessionAffinity          = optional(string, "None")
      annotations              = optional(map(string), {})
      remapPorts               = optional(map(string), {})
    }), {})
    loadBalancer = optional(list(object({
      publishNotReadyAddresses      = optional(bool, false)
      allocateLoadBalancerNodePorts = optional(bool, false)
      sessionAffinity               = optional(string, "None")
      externalTrafficPolicy         = optional(string, "Cluster")
      sourceRanges                  = optional(list(string), [])
      annotations                   = optional(map(string), {})
      remapPorts                    = optional(map(string), {})
      forceNodePortType             = optional(bool, false)
    })), [])
  })

  default = {}
}

resource "kubernetes_service_v1" "clusterIp" {
  count = local.serviceClusterIpEnabled ? 1 : 0

  metadata {
    name        = local.serviceName
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
        port        = lookup(var.service.clusterIp.remapPorts, port.value.name, port.value.port)
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }

}

resource "kubernetes_service_v1" "headless" {
  count = local.serviceHeadlessEnabled ? 1 : 0

  metadata {
    name        = local.headlessServiceName
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
        port        = lookup(var.service.headless.remapPorts, port.value.name, port.value.port)
        protocol    = port.value.protocol
      }
    }

    selector = var.consistency.soft.matchLabels
  }

}

resource "kubernetes_service_v1" "loadBalancer" {
  count = local.serviceLoadBalancerEnabled ? length(var.service.loadBalancer) : 0

  wait_for_load_balancer = var.tfWaitForRollout

  metadata {
    name        = "${local.serviceName}-${count.index}"
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.service.loadBalancer[count.index].annotations
  }

  spec {
    type                              = var.service.loadBalancer[count.index].forceNodePortType ? "NodePort" : "LoadBalancer"
    publish_not_ready_addresses       = var.service.loadBalancer[count.index].publishNotReadyAddresses
    allocate_load_balancer_node_ports = var.service.loadBalancer[count.index].allocateLoadBalancerNodePorts
    session_affinity                  = var.service.loadBalancer[count.index].sessionAffinity
    external_traffic_policy           = var.service.loadBalancer[count.index].externalTrafficPolicy
    load_balancer_source_ranges       = var.service.loadBalancer[count.index].sourceRanges

    dynamic "port" {
      for_each = local.serviceLoadBalancerPortsTcp
      content {
        name        = port.value.name
        target_port = port.value.name
        port        = lookup(var.service.loadBalancer[count.index].remapPorts, port.value.name, port.value.port)
        protocol    = port.value.protocol
      }
    }

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