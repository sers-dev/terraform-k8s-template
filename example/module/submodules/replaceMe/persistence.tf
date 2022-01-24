locals {
  persistence = merge(var.persistence, {
    enablePersistence = false,
    mounts = [
      {
        containerPath = "/replaceMe",
        volumePath    = null
      },
    ]
  })
}