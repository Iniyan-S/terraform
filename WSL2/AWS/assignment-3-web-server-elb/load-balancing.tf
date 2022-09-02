# Create LOAD BALANCER & Associate with SG & SUBNETS

resource "aws_lb" "myapp-elb" {
  name = "MyAPP-ELB"
  load_balancer_type = "application"
  internal = false
  ip_address_type = "ipv4"
  security_groups = [ data.terraform_remote_state.myvpc.outputs.elb-sg-id ]
  subnets = [ data.terraform_remote_state.myvpc.outputs.public-subnet-1-id, data.terraform_remote_state.myvpc.outputs.public-subnet-2-id ]

  tags = {
    "Name" = "MyApp ELB"
    "CreatedBy" = "Terraform"
  }

}

# Create Target Group for HTTP Protocol

resource "aws_lb_target_group" "myapp-tg" {
  target_type = "instance"
  name = "MyAPP-TG"
  port = "80"
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.myvpc.outputs.vpc-id

  health_check {
    protocol = "HTTP"
    path = "/index.html"
    port = "traffic-port"
    healthy_threshold = 3 # Default
    unhealthy_threshold = 3
    timeout = 6
    matcher = "200" # add value in quotes, type is string as per AWS documentation
  }

  tags = {
    "Name" = "MyAPP Target Group"
    "CreateBy" = "Terraform"
  }
}

# Create Load Balancer Listener

resource "aws_lb_listener" "myap-listener" {
  load_balancer_arn = aws_lb.myapp-elb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.myapp-tg.arn
  }
}






