locals {
  persistence = {
    enablePersistence = false,
    mounts = [
      {
        containerPath = "/replaceMe",
        volumePath    = null
      },
    ]
  }
}