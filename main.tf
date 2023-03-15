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

resource "snowflake_schema" "schema" {
  database            = "TF_DEVOPS_DEMO_DB"
  name                = "DEMO"
  data_retention_days = 1
}

resource "snowflake_table" "table" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "table"
  comment             = "A table."
  cluster_by          = ["to_date(DATE)"]
  data_retention_days = snowflake_schema.schema.data_retention_days
  change_tracking     = false

  column {
    name     = "id"
    type     = "int"
    nullable = true

  }

  column {
    name     = "identity"
    type     = "NUMBER(38,0)"
    nullable = true

    identity {
      start_num = 1
      step_num  = 3
    }
  }


  column {
    name = "DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name    = "extra"
    type    = "VARIANT"
    comment = "extra data"
  }

  primary_key {
    name = "my_key"
    keys = ["data"]
  }
}
