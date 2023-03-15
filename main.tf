terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }

backend "remote" {
    organization = "mhardingsnow"

    workspaces {
      name = "github-actions-demo"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_database" "tf_devops_demo_db" {
  name    = "TF_DEVOPS_DEMO_DB"
  comment = "Database for Snowflake Terraform demo"
}

