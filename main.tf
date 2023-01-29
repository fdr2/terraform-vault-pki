## PKI Roots
resource "vault_mount" "root" {
  for_each                  = var.pki_map
  path                      = "${var.pki_path}/${each.key}"
  description               = try(each.value["description"], "Managed by Terraform")
  type                      = "pki"
  default_lease_ttl_seconds = try(each.value["default_lease_ttl_seconds"], null)
  max_lease_ttl_seconds     = try(each.value["max_lease_ttl_seconds"], null)
}

resource "vault_pki_secret_backend_config_urls" "root" {
  for_each             = var.pki_map
  backend              = vault_mount.root[each.key].path
  issuing_certificates = try(each.value["issuing_certificates"], null)
}

resource "vault_pki_secret_backend_root_cert" "root" {
  for_each     = var.pki_map
  backend      = vault_mount.root[each.key].path
  type         = "internal"
  ttl          = try(each.value["ttl"], null)
  common_name  = try(each.value["common_name"], null)
  organization = try(each.value["organization"], null)
  ou           = try(each.value["ou"], null)
  country      = try(each.value["country"], null)
  locality     = try(each.value["locality"], null)
  province     = try(each.value["province"], null)
}

## PKI Intermediates
locals {
  inter_list = merge([for rk, rv in var.pki_map : { for ik, iv in rv.intermediates : ik => merge(iv, { root : rk }) }]...)
}

resource "vault_mount" "intermediate" {
  for_each                  = local.inter_list
  path                      = "${var.pki_path}/${each.key}"
  type                      = vault_mount.root[each.value["root"]].type
  description               = try(each.value["description"], "Managed by Terraform")
  default_lease_ttl_seconds = try(each.value["default_lease_ttl_seconds"], null)
  max_lease_ttl_seconds     = try(each.value["max_lease_ttl_seconds"], null)
}

resource "vault_pki_secret_backend_config_urls" "intermediate" {
  for_each             = local.inter_list
  backend              = vault_mount.intermediate[each.key].path
  issuing_certificates = try(each.value["issuing_certificates"], null)
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  for_each    = local.inter_list
  backend     = vault_mount.intermediate[each.key].path
  type        = vault_pki_secret_backend_root_cert.root[each.value["root"]].type
  common_name = try(each.value["common_name"], null)
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  for_each             = local.inter_list
  backend              = vault_mount.root[each.value["root"]].path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].csr
  common_name          = try(each.value["common_name"], null)
  exclude_cn_from_sans = try(each.value["exclude_cn_from_sans"], null)
  organization         = try(each.value["organization"], null)
  ou                   = try(each.value["ou"], null)
  country              = try(each.value["country"], null)
  locality             = try(each.value["locality"], null)
  province             = try(each.value["province"], null)
  revoke               = try(each.value["revoke"], true)
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  for_each    = local.inter_list
  backend     = vault_mount.intermediate[each.key].path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate[each.key].certificate
}

## PKI Roles
locals {
  roles_list = merge(flatten([for rk, rv in var.pki_map : [for ik, iv in rv.intermediates : { for ok, ov in iv.roles : ok => merge(ov, { inter : ik }) }]])...)
}

resource "vault_pki_secret_backend_role" "intermediate" {
  for_each           = local.roles_list
  backend            = vault_mount.intermediate[each.value["inter"]].path
  name               = each.key
  ttl                = try(each.value["ttl"], null)
  max_ttl            = try(each.value["max_ttl"], null)
  allow_localhost    = try(each.value["allow_localhost"], null)
  allowed_domains    = try(each.value["allowed_domains"], null)
  allow_bare_domains = try(each.value["allow_bare_domains"], null)
  allow_subdomains   = try(each.value["allow_subdomains"], null)
  allow_glob_domains = try(each.value["allow_glob_domains"], null)
  allow_ip_sans      = try(each.value["allow_ip_sans"], null)
  allowed_uri_sans   = try(each.value["allowed_uri_sans"], null)
  allowed_other_sans = try(each.value["allowed_other_sans"], null)
}
