variable "pki_path" {
  description = "The Vault PKI Secrets Path. Should not end with a slash, but may contain them. Default is \"pki\""
  type        = string
  default     = "ops/pki"
}

variable "pki_map" {
  type = any
  #  type = map(object({
  #    common_name : string
  #    description : string
  #    default_lease_ttl_seconds : number
  #    max_lease_ttl_seconds : number
  #    issuing_certificates : list(string)
  #    intermediates = map(object({
  #      common_name : string
  #      description : string
  #      default_lease_ttl_seconds : number
  #      max_lease_ttl_seconds : number
  #      issuing_certificates : list(string)
  #      exclude_cn_from_sans : bool
  #      ttl : number
  #      organization : string
  #      ou : string
  #      country : string
  #      locality : string
  #      province : string
  #      roles : map(object({
  #        ttl : number
  #        max_ttl : number
  #        allow_localhost : bool
  #        allowed_domains : list(string)
  #        allow_bare_domains : bool
  #        allow_subdomains : bool
  #        allow_glob_domains : bool
  #        allow_ip_sans : bool
  #      }))
  #    }))
  #  }))
}