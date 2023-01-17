module "this" {
  source = "../../"

  additionalLabels             = local.additionalLabels
  additionalNodeSelectorLabels = local.additionalNodeSelectorLabels
  clusterName                  = local.clusterName
  namePrefix                   = local.namePrefix
  instance                     = local.instance
  createNamespace              = local.createNamespace
  namespace                    = local.namespace
  owner                        = local.owner

  imagePullSecretNames = local.imagePullSecretNames
  persistence          = local.persistence
  infrastructureSize   = local.infrastructureSize
  tfWaitForRollout     = local.tfWaitForRollout

  additionalAnnotations = local.additionalAnnotations
  ingress               = local.ingress
  toleration            = local.toleration
}

