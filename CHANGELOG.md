## [1.8.0] - 2022-11-20

- added the option to define a toleration within the kubernetes_deployment_v1 resource
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