locals {
  enableSelfSignedWebhooks = false
  terraformTlsMountPath    = null
}

locals {
  tlsIngress = distinct(flatten([for k, v in var.ingress : v.fqdns]))

  enableTerraformIngressTls = module.template.ingressEnabled ? var.tlsConfig.enableSelfSignedIngress : false
  enableTerraformTlsMount   = local.terraformTlsMountPath != null
  enableTerraformTls        = local.enableTerraformTlsMount ? true : local.enableValidatingWebhook || local.enableMutatingWebhook ? local.enableSelfSignedWebhooks : false

  tlsMount = local.enableTerraformTlsMount ? {
    tf-tls = {
      defaultMode = "0600"
      path        = local.terraformTlsMountPath
      data        = module.tls.0.all
      binaryData  = {}
    }
  } : {}

}

module "tls" {
  source = "git::https://github.com/sers-dev/terraform-easy-tls.git?ref=tags/1.0.0"

  count = local.enableTerraformTls ? 1 : 0

  commonName = module.template.serviceName
  additionalNames = concat([
    "${module.template.serviceName}.${module.consistency.all.hard.namespace}",
    "${module.template.serviceName}.${module.consistency.all.hard.namespace}.svc",
    "${module.template.serviceName}.${module.consistency.all.hard.namespace}.svc.${module.consistency.all.hard.clusterName}",
  ], local.tlsIngress)
  ca                  = var.ca
  validityPeriodHours = var.tlsConfig.validityPeriodHours
  earlyRenewalHours   = var.tlsConfig.earlyRenewalHours
  rsaBits             = var.tlsConfig.rsaBits
}

module "ingressCa" {
  source = "git::https://github.com/sers-dev/terraform-easy-tls.git?ref=tags/1.0.0"

  count = local.enableTerraformIngressTls && var.ca == null ? 1 : 0

  commonName          = "ingress-ca"
  additionalNames     = []
  ca                  = var.ca
  validityPeriodHours = var.tlsConfig.validityPeriodHours
  earlyRenewalHours   = var.tlsConfig.earlyRenewalHours
  rsaBits             = var.tlsConfig.rsaBits
}

module "ingressTls" {
  source = "git::https://github.com/sers-dev/terraform-easy-tls.git?ref=tags/1.0.0"

  for_each = local.enableTerraformIngressTls ? zipmap(local.tlsIngress, local.tlsIngress) : {}

  commonName          = each.value
  additionalNames     = []
  ca                  = var.ca == null ? module.ingressCa.0.ca : var.ca
  validityPeriodHours = var.tlsConfig.validityPeriodHours
  earlyRenewalHours   = var.tlsConfig.earlyRenewalHours
  rsaBits             = var.tlsConfig.rsaBits
}

resource "kubernetes_secret_v1" "ingressTlsSecret" {
  for_each = module.ingressTls

  metadata {
    name      = "tls-${each.key}"
    namespace = module.consistency.all.hard.namespace
    labels    = module.consistency.all.soft.labels
  }

  data = each.value.all
}