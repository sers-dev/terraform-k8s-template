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