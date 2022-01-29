## [1.0.1] - TBD

- fix incorrect usage of variables in probes
- renamed variables for consistency
  - volume emptydir: old: `size_limit` new: `sizeLimit`
  - rbac: old: `api_groups` new: `apiGroups`
- add missing probes to statefulset
- fix external config & secret volumes for daemonset, cronjob and job

## [1.0.0] - 24.01.2022
- initial release
- minimum Kubernetes Version required 1.19.X