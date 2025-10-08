locals {
  service = {
    clusterIp = {
      ip                       = null
      publishNotReadyAddresses = false
      sessionAffinity          = "None"
      internalTrafficPolicy    = "Cluster"
      annotations = merge({

      }, var.additionalAnnotations.service)
      remapPorts = {}
    }
    headless = {
      publishNotReadyAddresses = false
      sessionAffinity          = "None"
      annotations = merge({

      }, var.additionalAnnotations.service)
      remapPorts = {}
    }
    loadBalancer = [
      #{
      #  forceNodePortType        = false
      #  externalTrafficPolicy    = "Cluster"
      #  publishNotReadyAddresses = false
      #  sessionAffinity          = "None"
      #  sourceRanges = [
      #  ]
      #  remapPorts = {
      #    "replaceMe" = 80
      #  }
      #  annotations = merge({
      #
      #  }, var.additionalAnnotations.service)
      #},
    ]
  }
}