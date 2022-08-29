# Configure Datasource to use Remote S3 Backend to read state file output

data "terraform_remote_state" "myvpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-remote-store"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}
