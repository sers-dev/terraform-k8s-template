terraform {
  backend "kubernetes" {
    load_config_file = true
    secret_suffix    = "ubuntu"
    namespace        = "tfstate-test"
  }
}