locals {
  topologySpread = [
    {
      maxSkew           = 1
      topologyKey       = "kubernetes.io/hostname"
      whenUnsatisfiable = "DoNotSchedule"
    }
    #{
    #  maxSkew           = 1
    #  topologyKey       = "topology.kubernetes.io/zone"
    #  whenUnsatisfiable = "DoNotSchedule"
    #},
    #{
    #  maxSkew           = 1
    #  topologyKey       = "topology.kubernetes.io/region"
    #  whenUnsatisfiable = "ScheduleAnyway"
    #}
  ]
}