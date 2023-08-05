locals {
  persistence = merge(var.persistence, {
    enablePersistence = true,
    mounts = [
      {
        containerPath = "/tmp/",
        volumePath    = null
      },
    ]
  })
}