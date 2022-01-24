variable "name" {}

variable "namePrefix" {}

variable "namespace" {}

variable "instance" {}

variable "clusterName" {}

variable "tfTemplateVersion" {}
variable "tfModuleVersion" {}
variable "tfModule" {}

variable "owner" {}

variable "additionalLabels" {
  type = map(string)
}

variable "additionalNodeSelectorLabels" {
  type = map(string)
}

variable "operatingSystem" {}

variable "architecture" {}