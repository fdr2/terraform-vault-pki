variable "vault_address" {
  type    = string
  default = "https://vault.service.consul:8200"
}

variable "pki_path" {
  type    = string
  default = "__test_pki"
}

variable "pki_map" {
  default = {
    consul_root : {
      common_name : "Consul Root CA"
      description : "Consul Root CA"
      default_lease_ttl_seconds : 1209600 # 2 weeks
      max_lease_ttl_seconds : 2419200     # 4 weeks
      issuing_certificates = [
        "https://vault.service.consul:8200/v1/pki/consul_root/ca"
      ]
      crl_distribution_points = [
        "https://vault.service.consul:8200/v1/pki/consul_root/crl"
      ]
      intermediates : {
        consul_inter : {
          common_name : "Consul Intermediate CA"
          description : "Consul Intermediate CA"
          default_lease_ttl_seconds : 1209600 # 2 weeks
          max_lease_ttl_seconds : 2419200     # 4 weeks
          #issuing_certificates = [
          #  "https://vault.service.consul:8200/v1/pki/consul_inter/ca"
          #]
          # exclude_cn_from_sans : true
          #ttl : 1209600
          organization : "DiRoccos"
          #ou : "MyOrgUnit"
          country : "US"
          locality : "Miami"
          province : "FL"
          roles : {
            consul : {
              ttl : 86400       # 1 day
              max_ttl : 1209600 # 2 weeks
              allow_localhost : true
              allowed_domains : [
                "service.consul",
                "service.op1.consul",
                "node.consul",
                "node.op1.consul",
              ]
              allow_bare_domains : false
              allow_subdomains : true
              allow_glob_domains : true
              allow_ip_sans : true
            }
          }
        }
      }
    }
    nomad_root : {
      common_name : "Nomad Root CA"
      description : "Nomad Root CA"
      default_lease_ttl_seconds : 1209600 # 2 weeks
      max_lease_ttl_seconds : 2419200     # 4 weeks
      issuing_certificates = [
        "https://vault.service.consul:8200/v1/pki/nomad_root/ca"
      ]
      crl_distribution_points = [
        "https://vault.service.consul:8200/v1/pki/nomad_root/crl"
      ]
      intermediates : {
        nomad_inter : {
          common_name : "Nomad Intermediate CA"
          description : "Nomad Intermediate CA"
          default_lease_ttl_seconds : 1209600 # 2 weeks
          max_lease_ttl_seconds : 2419200     # 4 weeks
          #issuing_certificates = [
          #  "https://vault.service.consul:8200/v1/pki/nomad_inter/ca"
          #]
          # exclude_cn_from_sans : true
          #ttl : 1209600
          organization : "DiRoccos"
          #ou : "MyOrgUnit"
          country : "US"
          locality : "Miami"
          province : "FL"
          roles : {
            nomad : {
              ttl : 86400       # 1 day
              max_ttl : 1209600 # 2 weeks
              allow_localhost : true
              allowed_domains : [
                "service.consul",
                "service.op1.consul",
              ]
              allow_bare_domains : false
              allow_subdomains : true
              allow_glob_domains : true
              allow_ip_sans : true
            }
          }
        }
      }
    }
    vault_root : {
      common_name : "Vault Root CA"
      description : "Vault Root CA"
      default_lease_ttl_seconds : 1209600 # 2 weeks
      max_lease_ttl_seconds : 2419200     # 4 weeks
      issuing_certificates = [
        "https://vault.service.consul:8200/v1/pki/vault_root/ca"
      ]
      crl_distribution_points = [
        "https://vault.service.consul:8200/v1/pki/vault_root/crl"
      ]
      intermediates : {
        vault_inter : {
          common_name : "Vault Intermediate CA"
          description : "Vault Intermediate CA"
          default_lease_ttl_seconds : 1209600 # 2 weeks
          max_lease_ttl_seconds : 2419200     # 4 weeks
          # revoke : true
          #issuing_certificates = [
          #  "https://vault.service.consul:8200/v1/pki/vault_inter/ca"
          #]
          # exclude_cn_from_sans : true
          #ttl : 1209600
          organization : "DiRoccos"
          #ou : "MyOrgUnit"
          country : "US"
          locality : "Miami"
          province : "FL"
          roles : {
            vault : {
              ttl : 86400       # 1 day
              max_ttl : 1209600 # 2 weeks
              allow_localhost : true
              allowed_domains : [
                "service.consul",
                "service.op1.consul",
              ]
              allow_bare_domains : false
              allow_subdomains : true
              allow_glob_domains : true
              allow_ip_sans : true
            }
          }
        }
      }
    }
  }
}
