reg = "us-east-1"
vpc_cidr = "10.0.0.0/16"
route_outbound_cidr = "0.0.0.0/0"
subnet = {
  private-1 = {
    "zone" = "us-east-1a"
    "cidr" = "10.0.20.0/24"
  }
  private-2 = {
    "zone" = "us-east-1b"
    "cidr" = "10.0.40.0/24"
  }
  public-1 = {
    "zone" = "us-east-1a"
    "cidr" = "10.0.10.0/24"
  }
  public-2 = {
    "zone" = "us-east-1b"
    "cidr" = "10.0.30.0/24"
  }
}