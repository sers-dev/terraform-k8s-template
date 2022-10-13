locals {

  infrastructureSizeRegex = "^(.*?)\\.(\\d)"
  infrastructureSize = regex(local.infrastructureSizeRegex, "${var.infrastructureSize}.1")[0]

  // if no multiplier is provided it defaults to 1 because of the string concat
  resourceMultiplier = parseint(regex(local.infrastructureSizeRegex, "${var.infrastructureSize}.1")[1], 10)

  // splits resource value from resource type
  // used together with resourceMultiplier to adjust requests/limits
  resourceMultiplierRegex = "^(0?\\.?\\d*)(.*)"


}