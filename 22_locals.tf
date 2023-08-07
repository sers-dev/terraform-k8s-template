locals {

  infrastructureSizeRegex = "^(.*?)\\.(\\d*)"
  infrastructureSize      = regex(local.infrastructureSizeRegex, "${var.infrastructureSize}.1")[0]

  // if no multiplier is provided it defaults to 1 because of the string concat
  resourceMultiplier = parseint(regex(local.infrastructureSizeRegex, "${var.infrastructureSize}.1")[1], 10)

  // splits resource value from resource type
  // used together with resourceMultiplier to adjust requests/limits
  resourceMultiplierRegex = "^(0?\\.?\\d*)(.*)"


}

locals {
  configVolumeMounts = { for k,v in var.applicationConfig.configVolumes: k => v if v.enableSubpathMount == false}
  tmpConfigVolumeSubpathMounts = { for k,v in var.applicationConfig.configVolumes: k => merge(v, { key = k}) if v.enableSubpathMount == true }
  configVolumeSubpathMounts = merge([ for k,v in local.tmpConfigVolumeSubpathMounts: {for f, z in merge(v.data, v.binaryData): "${k}-${f}" => { key = v.key, file = f, path = "${trimsuffix(v.path, "/")}/${f}"}} ]...)

  secretVolumeMounts = { for k,v in var.applicationConfig.secretVolumes: k => v if v.enableSubpathMount == false}
  tmpSecretVolumeSubpathMounts = { for k,v in var.applicationConfig.secretVolumes: k => merge(v, { key = k}) if v.enableSubpathMount == true }
  secretVolumeSubpathMounts = merge([ for k,v in local.tmpSecretVolumeSubpathMounts: {for f, z in merge(v.data, v.binaryData): "${k}-${f}" => { key = v.key, file = f, path = "${trimsuffix(v.path, "/")}/${f}"}} ]...)
}