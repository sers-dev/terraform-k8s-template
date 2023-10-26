locals {
  podResourceTypeConfig = {
    annotations                   = merge({}, var.additionalAnnotations.podResourceType)
    podAnnotations                = merge({}, var.additionalAnnotations.pod)
    minReplicas                   = local.replicas[module.template.infrastructureSize].min
    maxReplicas                   = local.replicas[module.template.infrastructureSize].max
    terminationGracePeriodSeconds = 10
    minReadySeconds               = 0
    deadlineSeconds               = 120
    revisionHistoryLimit          = 3

    rollingUpdate = {
      maxSurge       = "25%"
      maxUnavailable = "25%"
    }

    priorityClassName = ""
    restartPolicy     = "Always"

    // cronjob only
    schedule                   = local.podResourceType == "cronjob" ? "${random_integer.cronjobMinute.0.result} ${random_integer.cronjobHour.0.result} ${random_integer.cronjobDayOfMonth.0.result} ${random_integer.cronjobMonth.0.result} ${random_integer.cronjobDayOfWeek.0.result}" : ""
    concurrencyPolicy          = "Forbid"
    failedJobsHistoryLimit     = 3
    successfulJobsHistoryLimit = 3
    suspend                    = false

    // job only
    backoffLimit            = 6
    ttlSecondsAfterFinished = null
    completions             = null

    tolerations = {}
  }

}

resource "random_integer" "cronjobMinute" {
  count = local.podResourceType == "cronjob" ? 1 : 0
  min   = 0
  max   = 59
}

resource "random_integer" "cronjobHour" {
  count = local.podResourceType == "cronjob" ? 1 : 0
  min   = 0
  max   = 23
}

resource "random_integer" "cronjobDayOfMonth" {
  count = local.podResourceType == "cronjob" ? 1 : 0
  min   = 1
  max   = 31
}

resource "random_integer" "cronjobMonth" {
  count = local.podResourceType == "cronjob" ? 1 : 0
  min   = 1
  max   = 12
}

resource "random_integer" "cronjobDayOfWeek" {
  count = local.podResourceType == "cronjob" ? 1 : 0
  min   = 0
  max   = 6
}