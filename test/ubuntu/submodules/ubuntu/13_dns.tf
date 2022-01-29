locals {
  dns = {
    policy = "ClusterFirst"
    config = {
      nameservers = []
      searches    = []
      options = {
        "ndots" = "2"
      }
    }
  }
}