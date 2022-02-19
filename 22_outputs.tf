output "configEnvName" {
  value = local.configEnvEnabled ? kubernetes_config_map_v1.configEnv.0.metadata.0.name : null
}

output "configVolumeNames" {
  value = [for k, v in kubernetes_config_map_v1.configVolume : k]
}

output "secretEnvName" {
  value = local.secretEnvEnabled ? kubernetes_secret_v1.secretEnv.0.metadata.0.name : null
}

output "secretVolumeNames" {
  value = [for k, v in kubernetes_secret_v1.secretVolume : k]
}

#can't use `kubernetes_service_v1.clusterIp.0.metadata.0.name` because it will be incorrectly detected as loop if output is used in containers
output "internalFqdn" {
  value = "${local.serviceName}.${var.consistency.hard.namespace}.svc.${var.consistency.hard.clusterName}"
}

#can't use `kubernetes_service_v1.clusterIp.0.metadata.0.name` because it will be detected as loop if output is used in containers
output "serviceName" {
  value = local.serviceName
}

#can't use `kubernetes_service_v1.headless.0.metadata.0.name` because it will be detected as loop if output is used in containers
output "headlessServiceName" {
  value = local.headlessServiceName
}

#can't use `kubernetes_service_v1.headless.0.metadata.0.name` because it will be detected as loop if output is used in containers
output "internalHeadlessFqdn" {
  value = "${local.headlessServiceName}.${var.consistency.hard.namespace}.svc.${var.consistency.hard.clusterName}"
}