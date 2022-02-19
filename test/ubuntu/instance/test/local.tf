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
  instance        = "test"
  createNamespace = false
  namespace       = "default"
  owner           = "foobar"

  tfWaitForRollout = false

  infrastructureSize = "S"

  persistence = {
    forceDisable       = true
    storageAccessModes = ["ReadWriteOnce"]
    storageClassName   = "none"
    storageSize        = ""
  }

  imagePullSecretNames = [

  ]


  ingress = {
  }
}
