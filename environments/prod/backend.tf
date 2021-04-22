terraform {
  required_version = ">=0.14.9"
  required_providers {
    aws = ">=3.0.0"
  }
  backend "s3" {
    region  = "<region>"
    key     = "<path_to_state>"
    bucket  = "<bucket>"
  }
}
