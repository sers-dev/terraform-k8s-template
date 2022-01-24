locals {
  applicationConfig = {
    triggerRollingUpdate = {
      configEnv      = true
      configVolumes  = true
      secretEnv      = true
      secretVolumes  = true
      customCommands = true
    }

    envFieldRef = {
      #"HOSTNAME" = {
      #  version = "v1"
      #  field = "spec.nodeName"
      #}
    }

    externalConfigEnvs = [
      #"replaceMe"
    ]
    externalSecretEnvs = [
      #"replaceMe"
    ]

    externalConfigVolumes = {
      #replaceMe = {
      #  defaultMode = "0755"
      #  path = "/replaceMe"
      #}
    }
    externalSecretVolumes = {
      #replaceMe = {
      #  defaultMode = "0600"
      #  path = "/replaceMe"
      #}
    }

    configEnv = {
      #replaceMe = "replaceMe"
    }
    configVolumes = {
      #replaceMe = {
      #  defaultMode = "0644"
      #  path        = "/replaceMe/"
      #  data = {
      #    "replaceMe" = "replaceMe"
      #  }
      #  binaryData = {}
      #}
    }

    secretEnv = {
      #replaceMe = "replaceMe"
    }
    secretVolumes = {
      #replaceMe = {
      #  defaultMode = "0644"
      #  path        = "/replaceMe/"
      #  data = {
      #    "replaceMe" = "replaceMe"
      #  }
      #  binaryData = {}
      #}
    }
  }
}