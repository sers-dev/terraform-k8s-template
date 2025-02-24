locals {
  templateLabels = merge(var.consistency.soft.labels, {
    hash = sha1(base64encode(join("", concat(local.configVolumeHashData, local.configEnvHashData, local.secretVolumeHashData, local.secretEnvHashData, local.customCommandsHashData))))
    images = sha1(base64encode(join("", concat([for k, v in var.containers: v.image], [for k, v in var.initContainers: v.image]))))
  })
}
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

  schedule = var.podResourceType == "cronjob" ? var.podResourceTypeConfig.schedule != null ? var.podResourceTypeConfig.schedule : "${random_integer.cronjobMinute.0.result} ${random_integer.cronjobHour.0.result} * * ${random_integer.cronjobDayOfWeek.0.result}" : ""
}

resource "random_integer" "cronjobMinute" {
  count = var.podResourceType == "cronjob" && var.podResourceTypeConfig.schedule == null ? 1 : 0
  min   = 0
  max   = 59
}

resource "random_integer" "cronjobHour" {
  count = var.podResourceType == "cronjob" && var.podResourceTypeConfig.schedule == null ? 1 : 0
  min   = 0
  max   = 23
}

resource "random_integer" "cronjobDayOfWeek" {
  count = var.podResourceType == "cronjob" && var.podResourceTypeConfig.schedule == null ? 1 : 0
  min   = 0
  max   = 6
}
