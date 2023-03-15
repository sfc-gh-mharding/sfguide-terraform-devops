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

resource "snowflake_schema" "demo" {
  database            = snowflake_database.tf_devops_demo_db.name
  name                = "DEMO"
  data_retention_days = 1
}

resource "snowflake_table" "tab1" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "TABLE1"
  comment             = "A table."
  cluster_by          = ["to_date(DATE)"]
  data_retention_days = snowflake_schema.schema.data_retention_days
  change_tracking     = false

  column {
    name     = "ID"
    type     = "int"
    nullable = true

  }
  
  column {
    name = "FIRST_NAME"
    type = "VARCHAR"
    nullable = true
  }

  column {
    name = "DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name    = "V"
    type    = "VARIANT"
    comment = "A column of Variant type"
  }

  primary_key {
    name = "TAB1_KEY"
    keys = ["ID"]
  }
}
