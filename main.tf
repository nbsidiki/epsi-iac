terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "test_file" {
  content  = "Hello depuis Terraform, harchicorp !"
  filename = "${path.module}/hello.txt"
}