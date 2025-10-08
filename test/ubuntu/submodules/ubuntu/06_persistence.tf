locals {
  persistence = {
    enablePersistence = true,
    mounts = [
      {
        containerPath = "/tmp/",
        volumePath    = null
      },
    ]
  }
}