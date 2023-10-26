locals {
  podResourceTypeConfig = {
    annotations    = merge({}, var.additionalAnnotations.podResourceType)
    podAnnotations = merge({}, var.additionalAnnotations.pod)
    minReplicas    = local.replicas[module.template.infrastructureSize].min
    maxReplicas    = local.replicas[module.template.infrastructureSize].max
  }

}