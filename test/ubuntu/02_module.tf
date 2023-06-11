variable "ubuntuImage" {
  default = "docker.io/ubuntu:22.04"
}

module "ubuntu" {
  source = "./submodules/ubuntu"

  name = "ubuntu"

  tfModule        = local.tfModule
  tfModuleVersion = local.tfModuleVersion

  additionalLabels             = var.additionalLabels
  additionalNodeSelectorLabels = var.additionalNodeSelectorLabels
  clusterName                  = var.clusterName
  namePrefix                   = var.namePrefix
  instance                     = var.instance
  namespace                    = local.namespace
  owner                        = var.owner

  persistence          = var.persistence
  imagePullSecretNames = var.imagePullSecretNames
  infrastructureSize   = var.infrastructureSize
  tfWaitForRollout     = var.tfWaitForRollout

  architecture    = var.architecture
  operatingSystem = var.operatingSystem
  image           = var.ubuntuImage

  additionalAnnotations = var.additionalAnnotations
  ingress               = var.ingress
  toleration            = var.toleration
}

