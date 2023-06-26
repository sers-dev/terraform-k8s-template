locals {
  service = {
    clusterIp = {
      ip                       = null
      publishNotReadyAddresses = false
      sessionAffinity          = "None"
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
    ]
  }
}