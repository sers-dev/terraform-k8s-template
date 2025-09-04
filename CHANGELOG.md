## [2.5.0] - 2025-09-x

- added the option to pass a non-auto-generated serviceAccountName via `var.serviceAccountName`

## [2.4.0] - 2025-01-01

- added seccompProfile options for `var.containers` and `var.init_containers`

## [2.3.1] - 2024-05-21

- fix kubernetes_horizontal_pod_autoscaler_v2 not working because of missing apiVersion config
- adjust defaults for hpa

## [2.3.0] - 2024-04-22

- replace kubernetes_horizontal_pod_autoscaler_v2beta2 with kubernetes_horizontal_pod_autoscaler_v2

## [2.2.0] - 2024-03-20

- added boolean `var.service.loadbalancer.forceNodePortType` to allow spawning lb service as type nodeport

## [2.1.0] - 2024-01-24

- add `podResourceTypeConfig.podManagementPolicy`

## [2.0.0] - 2023-10-23

Please be aware that this is a major release. If the LoadBalancer change is handled properly you will not face downtime when upgrading.

- Breaking Change: LoadBalancer no longer split between TCP and UDP, as a result naming changes will occur
  - please ensure to first create new resources and switch dns before deleting the old resources
- renamed `podResourceTypeConfig.toleration` to `podResourceTypeConfig.tolerations` to properly follow naming scheme
- example module changes:
  - renamed a few files for better ordering
  - added self signed tls option
  - added `MutatingWebhookConfiguration` and `ValidatingWebhookConfiguration` and `CustomResourceDefinitions`
- fix init container field_ref config
- allow config of propagation for host mounts
- external secrets and configmaps are now optional
- rework rbac variable to support yamldecode 
- added `applicationConfig.configVolumes.enableSubpathMount` and `applicationConfig.secretVolumes.enableSubpathMount` to allow mounting all files of volume individually through subpath config
- reduce module usage complexity by introducing `optional` fields for most variables and providing sane defaults
  - check `./test/ubuntu/` to see simplifications
  - check `./example/module/` to see all variables in use
- allow configuration of ingress.pathType per ingress; defaults to `Prefix`


## [1.12.0] - 2023-06-12

- add `remapPorts` to `var.service.clusterIp` and `var.service.headless` to allow remapping of ports for all service types

## [1.11.0] - 2023-06-11

- port now supports `hostIp` if `hostNetwork == true`

## [1.10.0] - 2023-05-22

- hostNetwork = true now also sets hostPort 
  - this ensures that subsequent terraform runs do not show any diff, because it'd try to set hostPort to `null`

## [1.9.0] - 2023-02-20

- ingress tls config now configurable through `var.ingress.tlsEnabled`

## [1.8.0] - 2023-01-23

- added the option to define a toleration resources
- formatting

## [1.7.0] - 2022-11-20

- fix order of `env_from`
  - order is now: `envFieldRef` < `externalConfigEnv` < `externalSecretEnv` < `configEnv` < `secretEnv`
- added `18_outputs.tf` to example module
  - includes outputs from `/23_outputs.tf` as default outputs
- added `19_custom.tf` to example module


## [1.6.1] - 2022-10-16

- fix regex for `infrastructureSize` to match strings like 'default.20' as well

## [1.6.0] - 2022-10-13

- `infrastructureSize` now supports additional optional dynamic resource multiplicator
  - simply provide the size followed by `.X` where X us the multiplier that should be applied to requests and limits
  - multiplicator is only applied to requests + limits of `containers` , but not `initContainers`


## [1.5.0] - 2022-10-02

- `statefulset` will now automatically trigger a rolling restart when config is changed based on `triggerRollingUpdate` configuration

## [1.4.0] - 2022-06-05

- remove `wait_for_load_balancer` from ingress resource, as it will never finish if no load balancer is created for the resource
- added `nonResourceUrls` to rbac variables

## [1.3.0] - 2022-02-19

- fix missing role_binding namespace for rbac rules
- add option to create namespace
- add `resourceNames` to rbac rules
- adjust outputs for `service`, so that they can be used in `containers`

## [1.2.2] - 2022-02-17

- fix missing role namespace for rbac rules

## [1.2.1] - 2022-02-17

- fix apiGroup value name
- fix example HTTP scheme values

## [1.2.0] - 2022-02-16

- add `sourceRanges` to `var.service.loadBalancer` to enable configuration of allowed sources

## [1.1.0] - 2022-02-15

- add `remapPorts` to `var.service.loadBalancer` to allow remapping of ports for load balancers

## [1.0.1] - 2022-01-29

- fix incorrect usage of variables in probes
- renamed variables for consistency
  - volume emptydir: old: `size_limit` new: `sizeLimit`
  - rbac: old: `api_groups` new: `apiGroups`
- add missing probes to statefulset
- fix external config & secret volumes for daemonset, cronjob and job
- order tf files

## [1.0.0] - 2022-01-24

- initial release
- minimum Kubernetes Version required 1.19.X
