terraform {
  required_version = "~>1"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3"
    }
  }
}