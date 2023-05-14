# Terraform Vault PKI Certificate Issuer

Configure Vault's PKI Engine to distribute Intermediate Certificates from multiple Root CAs.

Issues a PKI Certificate

> This module aligns with [Generate mTLS Certificates for Consul with Vault](https://developer.hashicorp.com/consul/tutorials/vault-secure/vault-pki-consul-secure-tls)
> and [Build Your Own Certificate Authority (CA)](https://developer.hashicorp.com/consul/tutorials/vault-secure/pki-engine)

## Usage
Add the module and assign a PKI hierarchy.

```terraform
module "pki" {
  source = "../.."
  version = "0.0.1"
  pki_map = var.pki_map
}

variable "pki_map" {
  default = {
    consul_root : {
      common_name : "Consul Root CA"
      description : "Consul Root CA"
      default_lease_ttl_seconds : 1209600 # 2 weeks
      max_lease_ttl_seconds : 2419200     # 4 weeks
      #issuing_certificates = [
      #  "https://vault.service.consul:8200/v1/pki/consul_root/ca"
      #]
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
      #issuing_certificates = [
      #  "https://vault.service.consul:8200/v1/pki/nomad_root/ca"
      #]
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
    vault_root : {
      common_name : "Vault Root CA"
      description : "Vault Root CA"
      default_lease_ttl_seconds : 1209600 # 2 weeks
      max_lease_ttl_seconds : 2419200     # 4 weeks
      #issuing_certificates = [
      #  "https://vault.service.consul:8200/v1/pki/vault_root/ca"
      #]
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
  }
}
```

## Contributors Prerequisites

Terraform Code Utilities
```bash
brew tap liamg/tfsec
brew install terraform-docs tflint tfsec checkov
brew install pre-commit gawk coreutils go
```

Add the following to your `~/.profile`, if it is not already there.
You can check if they already exist by executing `env`.
```bash
# Go
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
```

Then reload your profile.
```bash
. ~/.profile
```

Ensure `golint` is properly installed with PATHs set properly from above.
```bash
go get -u golang.org/x/lint/golint
```

To manually run the pre-commit hooks
```bash
pre-commit run -a
```

### Tests
Login to Vault or issue a runner a VAULT_TOKEN environment variable.
```bash
VAULT_HOST=https://vault.service.consul:8200 vault login -method=ldap username=$USER
```

Ensure you have Go >= 1.19.5
[Read more about terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
```bash
cd test/basicpki
go test
```

## TODO

* add tests
