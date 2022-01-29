locals {
  service = {
    clusterIp = {
      ip                       = null
      publishNotReadyAddresses = false
      sessionAffinity          = "None"
      annotations = merge({

      }, var.additionalAnnotations.service)
    }
    headless = {
      publishNotReadyAddresses = false
      sessionAffinity          = "None"
      annotations = merge({

      }, var.additionalAnnotations.service)
    }
    loadBalancer = [
      #{
      #  externalTrafficPolicy = "Cluster"
      #  publishNotReadyAddresses = false
      #  sessionAffinity = "None"
      #  annotations = merge({
      #
      #  }, var.additionalAnnotations.service)
      #},
    ]
  }
}