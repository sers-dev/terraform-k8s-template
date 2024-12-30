resource "kubernetes_job_v1" "job" {
  count               = var.podResourceType == "job" ? 1 : 0
  wait_for_completion = var.tfWaitForRollout

  metadata {
    name        = var.consistency.hard.namespaceUniqueName
    namespace   = var.consistency.hard.namespace
    labels      = var.consistency.soft.labels
    annotations = var.podResourceTypeConfig.annotations
  }

  spec {
    parallelism                = var.podResourceTypeConfig.minReplicas
    backoff_limit              = var.podResourceTypeConfig.backoffLimit
    ttl_seconds_after_finished = var.podResourceTypeConfig.ttlSecondsAfterFinished
    completions                = var.podResourceTypeConfig.completions

    manual_selector = true
    selector {
      match_labels = var.consistency.soft.matchLabels
    }


    template {
      metadata {
        labels = merge(var.consistency.soft.labels, {
          hash = sha1(base64encode(join("", concat(local.configVolumeHashData, local.configEnvHashData, local.secretVolumeHashData, local.secretEnvHashData, local.customCommandsHashData))))
        })
        annotations = var.podResourceTypeConfig.podAnnotations
      }

      spec {
        active_deadline_seconds = var.podResourceTypeConfig.deadlineSeconds
        enable_service_links    = false
        dynamic "host_aliases" {
          for_each = var.hostConfig.hostAliases
          content {
            ip        = host_aliases.key
            hostnames = host_aliases.value
          }
        }
        host_ipc            = var.hostConfig.hostIpc
        host_pid            = var.hostConfig.hostPid
        hostname            = var.hostConfig.hostname
        priority_class_name = var.podResourceTypeConfig.priorityClassName
        restart_policy      = var.podResourceTypeConfig.restartPolicy == "Always" ? "OnFailure" : var.podResourceTypeConfig.restartPolicy
        dynamic "security_context" {
          for_each = local.globalSecurityContextEnabled ? [1] : []
          content {
            fs_group        = var.hostConfig.securityContext.fsGroup
            run_as_group    = var.hostConfig.securityContext.runAsGroup
            run_as_non_root = var.hostConfig.securityContext.runAsNonRoot
            run_as_user     = var.hostConfig.securityContext.runAsUser

            supplemental_groups = var.hostConfig.securityContext.supplementalGroups

          }
        }
        share_process_namespace = var.hostConfig.shareProcessNamespace

        dynamic "toleration" {
          for_each = var.podResourceTypeConfig.tolerations
          content {
            effect             = toleration.value.effect
            key                = toleration.value.key
            operator           = toleration.value.operator
            toleration_seconds = toleration.value.tolerationSeconds
            value              = toleration.value.value
          }
        }

        dynamic "topology_spread_constraint" {
          for_each = var.topologySpread
          content {
            max_skew           = topology_spread_constraint.value.maxSkew
            topology_key       = topology_spread_constraint.value.topologyKey
            when_unsatisfiable = topology_spread_constraint.value.whenUnsatisfiable
            label_selector {
              match_labels = var.consistency.soft.matchLabels
            }
          }
        }

        service_account_name             = kubernetes_service_account_v1.serviceAccount.0.metadata.0.name
        automount_service_account_token  = true
        host_network                     = var.hostConfig.hostNetwork
        termination_grace_period_seconds = var.podResourceTypeConfig.terminationGracePeriodSeconds
        dns_policy                       = var.dns.policy

        dynamic "dns_config" {
          for_each = var.dns.config != null ? [1] : []
          content {
            nameservers = var.dns.config.nameservers
            searches    = var.dns.config.searches

            dynamic "option" {
              for_each = var.dns.config.options
              content {
                name  = option.key
                value = option.value
              }
            }
          }
        }

        dynamic "image_pull_secrets" {
          for_each = var.imagePullSecretNames
          content {
            name = data.kubernetes_secret_v1.imagePullSecret[count.index].metadata.0.name
          }
        }

        node_selector = var.consistency.soft.nodeSelector

        dynamic "volume" {
          for_each = var.applicationConfig.externalConfigVolumes
          content {
            name = volume.key
            config_map {
              optional     = true
              default_mode = volume.value.defaultMode
              name         = volume.key
            }
          }
        }


        dynamic "volume" {
          for_each = var.applicationConfig.externalSecretVolumes
          content {
            name = volume.key
            secret {
              optional     = true
              default_mode = volume.value.defaultMode
              secret_name  = volume.key
            }
          }
        }

        dynamic "volume" {
          for_each = var.applicationConfig.secretVolumes
          content {
            name = kubernetes_secret_v1.secretVolume[volume.key].metadata.0.name
            secret {
              default_mode = volume.value.defaultMode
              secret_name  = kubernetes_secret_v1.secretVolume[volume.key].metadata.0.name
              optional     = false
            }
          }
        }

        dynamic "volume" {
          for_each = var.applicationConfig.configVolumes
          content {
            name = kubernetes_config_map_v1.configVolume[volume.key].metadata.0.name
            config_map {
              default_mode = volume.value.defaultMode
              name         = kubernetes_config_map_v1.configVolume[volume.key].metadata.0.name
            }
          }
        }

        dynamic "volume" {
          for_each = local.customCommandEnabled ? [1] : []
          content {
            name = kubernetes_secret_v1.customCommand.0.metadata.0.name
            secret {
              default_mode = "0755"
              secret_name  = kubernetes_secret_v1.customCommand.0.metadata.0.name
            }
          }
        }

        dynamic "volume" {
          for_each = var.volumes.emptyDir
          content {
            name = volume.key
            empty_dir {
              medium     = volume.value.medium
              size_limit = volume.value.sizeLimit
            }
          }
        }

        dynamic "volume" {
          for_each = var.volumes.hostPath
          content {
            name = volume.key
            host_path {
              path = volume.value.hostPath
              type = volume.value.type
            }
          }
        }

        dynamic "init_container" {
          for_each = var.initContainers
          content {
            image_pull_policy = init_container.value.imagePullPolicy
            security_context {
              allow_privilege_escalation = init_container.value.securityContext.allowPrivilegeEscalation
              capabilities {
                add  = init_container.value.securityContext.capabilities.add
                drop = init_container.value.securityContext.capabilities.drop
              }
              read_only_root_filesystem = init_container.value.securityContext.readOnlyRootFilesystem
              privileged                = init_container.value.securityContext.privileged
              run_as_group              = init_container.value.securityContext.runAsGroup
              run_as_non_root           = init_container.value.securityContext.runAsNonRoot
              run_as_user               = init_container.value.securityContext.runAsUser

              dynamic "seccomp_profile" {
                for_each = init_container.value.securityContext.seccompProfile.type != null ? [init_container.value.securityContext.seccompProfile] : []
                content {
                  localhost_profile = init_container.value.securityContext.seccompProfile.localhostProfile
                  type              = init_container.value.securityContext.seccompProfile.type
                }
              }
            }
            stdin                      = init_container.value.stdin
            stdin_once                 = init_container.value.stdinOnce
            termination_message_path   = init_container.value.terminationMessagePath
            termination_message_policy = init_container.value.terminationMessagePolicy
            tty                        = init_container.value.tty
            working_dir                = init_container.value.workingDir


            dynamic "lifecycle" {
              for_each = init_container.value.preStop.httpGet.enabled || init_container.value.preStop.tcpSocket.enabled || init_container.value.preStop.exec.enabled || init_container.value.postStart.httpGet.enabled || init_container.value.postStart.tcpSocket.enabled || init_container.value.postStart.exec.enabled ? [1] : []

              content {
                dynamic "pre_stop" {
                  for_each = init_container.value.preStop.httpGet.enabled || init_container.value.preStop.tcpSocket.enabled || init_container.value.preStop.exec.enabled ? [1] : []
                  content {
                    dynamic "exec" {
                      for_each = init_container.value.preStop.exec.enabled ? [1] : []
                      content {
                        command = init_container.value.preStop.exec.command
                      }
                    }

                    dynamic "http_get" {
                      for_each = init_container.value.preStop.httpGet.enabled ? [1] : []
                      content {
                        path   = init_container.value.preStop.httpGet.path
                        port   = init_container.value.preStop.httpGet.port
                        host   = init_container.value.preStop.httpGet.host
                        scheme = init_container.value.preStop.httpGet.scheme

                        dynamic "http_header" {
                          for_each = init_container.value.preStop.httpGet.header
                          content {
                            name  = http_header.key
                            value = http_header.value
                          }
                        }
                      }
                    }

                    dynamic "tcp_socket" {
                      for_each = init_container.value.preStop.tcpSocket.enabled ? [1] : []
                      content {
                        port = init_container.value.preStop.tcpSocket.port
                      }
                    }
                  }
                }

                dynamic "post_start" {
                  for_each = init_container.value.postStart.httpGet.enabled || init_container.value.postStart.tcpSocket.enabled || init_container.value.postStart.exec.enabled ? [1] : []
                  content {
                    dynamic "exec" {
                      for_each = init_container.value.postStart.exec.enabled ? [1] : []
                      content {
                        command = init_container.value.postStart.exec.command
                      }
                    }

                    dynamic "http_get" {
                      for_each = init_container.value.postStart.httpGet.enabled ? [1] : []
                      content {
                        path   = init_container.value.postStart.httpGet.path
                        port   = init_container.value.postStart.httpGet.port
                        host   = init_container.value.postStart.httpGet.host
                        scheme = init_container.value.postStart.httpGet.scheme

                        dynamic "http_header" {
                          for_each = init_container.value.postStart.httpGet.header
                          content {
                            name  = http_header.key
                            value = http_header.value
                          }
                        }
                      }
                    }

                    dynamic "tcp_socket" {
                      for_each = init_container.value.postStart.tcpSocket.enabled ? [1] : []
                      content {
                        port = init_container.value.postStart.tcpSocket.port
                      }
                    }
                  }
                }
              }
            }

            name  = init_container.key
            image = init_container.value.image

            command = init_container.value.customCommand.enabled ? ["${local.customCommandMountPath}/${init_container.key}${local.customCommandFileNameSuffix}"] : []

            args = init_container.value.args

            dynamic "env" {
              for_each = var.applicationConfig.envFieldRef
              content {
                name = env.key
                value_from {
                  field_ref {
                    api_version = env.value.version
                    field_path  = env.value.field
                  }
                }
              }
            }

            dynamic "env_from" {
              for_each = var.applicationConfig.externalConfigEnvs
              content {
                config_map_ref {
                  optional = true
                  name     = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = var.applicationConfig.externalSecretEnvs
              content {
                secret_ref {
                  optional = true
                  name     = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = local.configEnvEnabled ? [1] : []
              content {
                config_map_ref {
                  name = kubernetes_config_map_v1.configEnv.0.metadata.0.name
                }
              }
            }

            dynamic "env_from" {
              for_each = local.secretEnvEnabled ? [1] : []
              content {
                secret_ref {
                  name = kubernetes_secret_v1.secretEnv.0.metadata.0.name
                }
              }
            }

            resources {
              requests = init_container.value.resources[local.infrastructureSize].requests
              limits   = init_container.value.resources[local.infrastructureSize].limits
            }

            dynamic "volume_mount" {
              for_each = var.applicationConfig.externalSecretVolumes
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = var.applicationConfig.externalConfigVolumes
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = local.secretVolumeMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_secret_v1.secretVolume[volume_mount.key].metadata.0.name
              }
            }

            dynamic "volume_mount" {
              for_each = local.secretVolumeSubpathMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_secret_v1.secretVolume[volume_mount.value.key].metadata.0.name
                sub_path   = volume_mount.value.file
              }
            }

            dynamic "volume_mount" {
              for_each = local.configVolumeMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_config_map_v1.configVolume[volume_mount.key].metadata.0.name
              }
            }

            dynamic "volume_mount" {
              for_each = local.configVolumeSubpathMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_config_map_v1.configVolume[volume_mount.value.key].metadata.0.name
                sub_path   = volume_mount.value.file
              }
            }

            dynamic "volume_mount" {
              for_each = var.volumes.emptyDir
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = var.volumes.hostPath
              content {
                mount_path        = volume_mount.value.path
                mount_propagation = volume_mount.value.propagation
                name              = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = local.customCommandEnabled ? [1] : []
              content {
                mount_path = local.customCommandMountPath
                name       = kubernetes_secret_v1.customCommand.0.metadata.0.name
              }
            }

          }
        }

        dynamic "container" {
          for_each = var.containers
          content {
            image_pull_policy = container.value.imagePullPolicy
            security_context {
              allow_privilege_escalation = container.value.securityContext.allowPrivilegeEscalation
              capabilities {
                add  = container.value.securityContext.capabilities.add
                drop = container.value.securityContext.capabilities.drop
              }
              read_only_root_filesystem = container.value.securityContext.readOnlyRootFilesystem
              privileged                = container.value.securityContext.privileged
              run_as_group              = container.value.securityContext.runAsGroup
              run_as_non_root           = container.value.securityContext.runAsNonRoot
              run_as_user               = container.value.securityContext.runAsUser

              dynamic "seccomp_profile" {
                for_each = container.value.securityContext.seccompProfile.type != null ? [container.value.securityContext.seccompProfile] : []
                content {
                  localhost_profile = container.value.securityContext.seccompProfile.localhostProfile
                  type              = container.value.securityContext.seccompProfile.type
                }
              }
            }
            stdin                      = container.value.stdin
            stdin_once                 = container.value.stdinOnce
            termination_message_path   = container.value.terminationMessagePath
            termination_message_policy = container.value.terminationMessagePolicy
            tty                        = container.value.tty
            working_dir                = container.value.workingDir

            dynamic "lifecycle" {
              for_each = container.value.preStop.httpGet.enabled || container.value.preStop.tcpSocket.enabled || container.value.preStop.exec.enabled || container.value.postStart.httpGet.enabled || container.value.postStart.tcpSocket.enabled || container.value.postStart.exec.enabled ? [1] : []

              content {
                dynamic "pre_stop" {
                  for_each = container.value.preStop.httpGet.enabled || container.value.preStop.tcpSocket.enabled || container.value.preStop.exec.enabled ? [1] : []
                  content {
                    dynamic "exec" {
                      for_each = container.value.preStop.exec.enabled ? [1] : []
                      content {
                        command = container.value.preStop.exec.command
                      }
                    }

                    dynamic "http_get" {
                      for_each = container.value.preStop.httpGet.enabled ? [1] : []
                      content {
                        path   = container.value.preStop.httpGet.path
                        port   = container.value.preStop.httpGet.port
                        host   = container.value.preStop.httpGet.host
                        scheme = container.value.preStop.httpGet.scheme

                        dynamic "http_header" {
                          for_each = container.value.preStop.httpGet.header
                          content {
                            name  = http_header.key
                            value = http_header.value
                          }
                        }
                      }
                    }

                    dynamic "tcp_socket" {
                      for_each = container.value.preStop.tcpSocket.enabled ? [1] : []
                      content {
                        port = container.value.preStop.tcpSocket.port
                      }
                    }
                  }
                }

                dynamic "post_start" {
                  for_each = container.value.postStart.httpGet.enabled || container.value.postStart.tcpSocket.enabled || container.value.postStart.exec.enabled ? [1] : []
                  content {
                    dynamic "exec" {
                      for_each = container.value.postStart.exec.enabled ? [1] : []
                      content {
                        command = container.value.postStart.exec.command
                      }
                    }

                    dynamic "http_get" {
                      for_each = container.value.postStart.httpGet.enabled ? [1] : []
                      content {
                        path   = container.value.postStart.httpGet.path
                        port   = container.value.postStart.httpGet.port
                        host   = container.value.postStart.httpGet.host
                        scheme = container.value.postStart.httpGet.scheme

                        dynamic "http_header" {
                          for_each = container.value.postStart.httpGet.header
                          content {
                            name  = http_header.key
                            value = http_header.value
                          }
                        }
                      }
                    }

                    dynamic "tcp_socket" {
                      for_each = container.value.postStart.tcpSocket.enabled ? [1] : []
                      content {
                        port = container.value.postStart.tcpSocket.port
                      }
                    }
                  }
                }
              }
            }
            name  = container.key
            image = container.value.image

            command = container.value.customCommand.enabled ? ["${local.customCommandMountPath}/${container.key}${local.customCommandFileNameSuffix}"] : []

            args = container.value.args


            dynamic "port" {
              for_each = container.value.ports
              content {
                name           = port.value.name
                host_ip        = var.hostConfig.hostNetwork ? port.value.hostIp : null
                protocol       = port.value.protocol
                container_port = port.value.port
                host_port      = var.hostConfig.hostNetwork ? port.value.port : null
              }
            }

            dynamic "env" {
              for_each = var.applicationConfig.envFieldRef
              content {
                name = env.key
                value_from {
                  field_ref {
                    api_version = env.value.version
                    field_path  = env.value.field
                  }
                }
              }
            }

            dynamic "env_from" {
              for_each = var.applicationConfig.externalConfigEnvs
              content {
                config_map_ref {
                  optional = true
                  name     = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = var.applicationConfig.externalSecretEnvs
              content {
                secret_ref {
                  optional = true
                  name     = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = local.configEnvEnabled ? [1] : []
              content {
                config_map_ref {
                  name = kubernetes_config_map_v1.configEnv.0.metadata.0.name
                }
              }
            }

            dynamic "env_from" {
              for_each = local.secretEnvEnabled ? [1] : []
              content {
                secret_ref {
                  name = kubernetes_secret_v1.secretEnv.0.metadata.0.name
                }
              }
            }

            resources {
              requests = { for k, v in container.value.resources[local.infrastructureSize].requests : k => v == null ? null : "${regex(local.resourceMultiplierRegex, v)[0] * local.resourceMultiplier}${regex(local.resourceMultiplierRegex, v)[1]}" }
              limits   = { for k, v in container.value.resources[local.infrastructureSize].limits : k => v == null ? null : "${regex(local.resourceMultiplierRegex, v)[0] * local.resourceMultiplier}${regex(local.resourceMultiplierRegex, v)[1]}" }
            }

            dynamic "volume_mount" {
              for_each = var.applicationConfig.externalSecretVolumes
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = var.applicationConfig.externalConfigVolumes
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = local.secretVolumeMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_secret_v1.secretVolume[volume_mount.key].metadata.0.name
              }
            }

            dynamic "volume_mount" {
              for_each = local.secretVolumeSubpathMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_secret_v1.secretVolume[volume_mount.value.key].metadata.0.name
                sub_path   = volume_mount.value.file
              }
            }

            dynamic "volume_mount" {
              for_each = local.configVolumeMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_config_map_v1.configVolume[volume_mount.key].metadata.0.name
              }
            }

            dynamic "volume_mount" {
              for_each = local.configVolumeSubpathMounts
              content {
                mount_path = volume_mount.value.path
                name       = kubernetes_config_map_v1.configVolume[volume_mount.value.key].metadata.0.name
                sub_path   = volume_mount.value.file
              }
            }

            dynamic "volume_mount" {
              for_each = var.volumes.emptyDir
              content {
                mount_path = volume_mount.value.path
                name       = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = var.volumes.hostPath
              content {
                mount_path        = volume_mount.value.path
                mount_propagation = volume_mount.value.propagation
                name              = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = local.customCommandEnabled ? [1] : []
              content {
                mount_path = local.customCommandMountPath
                name       = kubernetes_secret_v1.customCommand.0.metadata.0.name
              }
            }

          }
        }
      }
    }
  }
}
