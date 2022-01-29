variable "replaceMeImage" {
  default = "ubuntu:21.04"
}

module "replaceMe" {
  source = "./submodules/replaceMe"

  name = "replaceMe"

  tfModule        = local.tfModule
  tfModuleVersion = local.tfModuleVersion

  additionalLabels             = var.additionalLabels
  additionalNodeSelectorLabels = var.additionalNodeSelectorLabels
  clusterName                  = var.clusterName
  namePrefix                   = var.namePrefix
  instance                     = var.instance
  namespace                    = var.namespace
  owner                        = var.owner

  persistence          = var.persistence
  imagePullSecretNames = var.imagePullSecretNames
  infrastructureSize   = var.infrastructureSize
  tfWaitForRollout     = var.tfWaitForRollout

  architecture    = var.architecture
  operatingSystem = var.operatingSystem
  image           = var.replaceMeImage


  additionalAnnotations = var.additionalAnnotations
  ingress               = var.ingress
}

