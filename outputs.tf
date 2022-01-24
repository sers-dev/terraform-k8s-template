output "version" {
  value = "1.0.0"
}

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

output "internalFqdn" {
  value = local.serviceClusterIpEnabled ? "${kubernetes_service_v1.clusterIp.0.metadata.0.name}.${var.consistency.hard.namespace}.svc.${var.consistency.hard.clusterName}" : null
}

output "serviceName" {
  value = local.serviceClusterIpEnabled ? kubernetes_service_v1.clusterIp.0.metadata.0.name : null
}

output "internalHeadlessFqdn" {
  value = local.serviceHeadlessEnabled ? "${kubernetes_service_v1.headless.0.metadata.0.name}.${var.consistency.hard.namespace}.svc.${var.consistency.hard.clusterName}" : null
}