provider "aws" {
  shared_credentials_files = [ "/home/sarguni/.aws/credentials" ]
  profile = "ft_admin"
  region = "ap-south-1"
}