locals {
  additionalAnnotations = {
    podResourceType = {}
    pod             = {}
    service         = {}
  }
  additionalLabels             = {}
  additionalNodeSelectorLabels = {}
  clusterName                  = "cluster.local"

  namePrefix      = ""
  instance        = "replaceMe"
  createNamespace = false
  namespace       = "replaceMe"
  owner           = "replaceMe"

  tfWaitForRollout = false

  infrastructureSize = "S"
  infraOverrideConfig = {}

  persistence = {
    forceDisable       = false
    storageAccessModes = ["ReadWriteOnce"]
    storageClassName   = "replaceMe"
    storageSize        = "replaceMe"
  }

  imagePullSecretNames = [

  ]


  ingress = {
    replaceMe = {
      tlsEnabled       = true
      ingressClassName = "replaceMe"
      pathType         = "Prefix"
      annotations = {

      }
      overridePaths = [
      ]
      fqdns = [
        "replaceMe",
      ]
    }
  }
}
