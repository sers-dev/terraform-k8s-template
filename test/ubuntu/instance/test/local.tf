locals {
  additionalAnnotations = {
    podResourceType = {}
    pod             = {}
    service         = {}
  }
  additionalLabels             = {}
  additionalNodeSelectorLabels = {
    datacenter-provider = "dick"
  }
  clusterName                  = "cluster.local"

  namePrefix      = ""
  instance        = "test"
  createNamespace = false
  namespace       = "default"
  owner           = "foobar"

  tfWaitForRollout = false

  infrastructureSize = "S"

  persistence = {
    forceDisable       = false
    storageAccessModes = ["ReadWriteOnce"]
    storageClassName   = "longhorn"
    storageSize        = "1Gi"
  }

  imagePullSecretNames = [

  ]

  ingress = {
  }

  ca = null
  tlsConfig = {
    enableSelfSignedIngress = false
    rsaBits = 4096
    earlyRenewalHours = 87600 # 10 years
    validityPeriodHours = 876000 # 100 years
  }
  forceDisableCRDs     = false
  forceDisableWebhooks = false

}
