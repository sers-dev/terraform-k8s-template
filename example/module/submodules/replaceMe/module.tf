locals {
  #replaceMe "deployment", "statefulset", "daemonset", "cronjob", "job"
  podResourceType = "deployment"
}

module "template" {
  source           = "../../../../"
  podResourceType  = local.podResourceType
  tfWaitForRollout = var.tfWaitForRollout

  consistency = module.consistency.all


  rbac = local.rbac

  persistence = local.persistence

  applicationConfig = local.applicationConfig
  containers        = local.containers

  podResourceTypeConfig = local.podResourceTypeConfig
  initContainers        = local.initContainers
  volumes               = local.volumes
  architecture          = var.architecture
  operatingSystem       = var.operatingSystem

  imagePullSecretNames = var.imagePullSecretNames
  service              = local.service

  ingress             = var.ingress
  podDisruptionBudget = local.podDisruptionBudget

  dns                     = local.dns
  hostConfig              = local.hostConfig
  topologySpread          = local.topologySpread
  infrastructureSize      = var.infrastructureSize
  horizontalPodAutoscaler = local.horizontalPodAutoscaler
}
