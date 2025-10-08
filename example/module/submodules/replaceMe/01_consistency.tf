module "consistency" {
  source = "../../../consistency"



  additionalLabels             = var.additionalLabels
  additionalNodeSelectorLabels = var.additionalNodeSelectorLabels
  clusterName                  = var.clusterName
  instance                     = var.instance
  name                         = var.name
  namePrefix                   = var.namePrefix
  namespace                    = var.namespace
  owner                        = var.owner
  tfTemplateVersion            = module.template.version
  tfModule                     = var.tfModule
  tfModuleVersion              = var.tfModuleVersion
  operatingSystem              = var.operatingSystem
  architecture                 = var.architecture
}


variable "additionalLabels" {
  type = map(string)
}
variable "additionalNodeSelectorLabels" {
  type = map(string)
}
variable "clusterName" {}
variable "instance" {}
variable "name" {}
variable "namePrefix" {}
variable "namespace" {}
variable "owner" {}
variable "tfModule" {}
variable "tfModuleVersion" {}
variable "architecture" {}
variable "operatingSystem" {}