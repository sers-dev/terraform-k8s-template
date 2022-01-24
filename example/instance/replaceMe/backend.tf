terraform {
  backend "kubernetes" {
    load_config_file = true
    secret_suffix    = "replaceMe"
    namespace        = "tfstate"
  }
}