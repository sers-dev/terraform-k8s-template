locals {
  additionalAnnotations = {
    podResourceType = {}
    pod             = {}
    service         = {}
  }
  additionalLabels             = {}
  additionalNodeSelectorLabels = {}
  clusterName                  = "cluster.local"

  namePrefix = ""
  instance   = "replaceMe"
  namespace  = "replaceMe"
  owner      = "replaceMe"

  tfWaitForRollout = false

  infrastructureSize = "S"

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
      ingressClassName = "replaceMe"
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
