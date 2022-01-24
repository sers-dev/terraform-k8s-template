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
    }

    externalConfigEnvs = [
    ]
    externalSecretEnvs = [
    ]

    externalConfigVolumes = {
    }
    externalSecretVolumes = {
    }

    configEnv = {
      HELLO = "WORLD"
    }
    configVolumes = {
      important = {
        defaultMode = "0644"
        path        = "/test-config/"
        data = {
          "config.txt" = "This could also be a templatefile() in terraform, filled through additional variables"
        }
        binaryData = {}
      }
    }

    secretEnv = {
      FOO = "BAR"
    }
    secretVolumes = {
    }
  }
}