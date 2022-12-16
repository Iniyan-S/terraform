# Create LAUNCH CONFIGURATION

resource "aws_launch_configuration" "myapp-lc" {
  name_prefix = "myapp-"
  image_id = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  ebs_optimized = false
  iam_instance_profile = data.terraform_remote_state.iam-s3.outputs.iam-profile-s3-access
  key_name = "in-user"
  security_groups = [ data.terraform_remote_state.myvpc.outputs.app-sg-id ]
  user_data = file("./bootstrap.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# Create AUTO SCALING GROUP

resource "aws_autoscaling_group" "myapp-asg" {
  name = "myapp-asg"
  launch_configuration = aws_launch_configuration.myapp-lc.name
  vpc_zone_identifier = [data.terraform_remote_state.myvpc.outputs.private-subnet-1-id, data.terraform_remote_state.myvpc.outputs.private-subnet-1-id ]
  target_group_arns = [ aws_lb_target_group.myapp-tg.arn ]
  health_check_type = "ELB"
  health_check_grace_period = 300
  enabled_metrics = [ "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances" ]
  metrics_granularity = "1Minute" # If you specify Granularity and don't specify any metrics, all metrics are enabled.
  default_instance_warmup = 180
  min_size = 2
  max_size = 4

#   tags = {
#     "Name" = "MyAPP ASG"
#     "CreatedBy" = "Terraform"
#     "propagate_at_launch" = true
#   }
}

# Create AUTO SCALING POLICY

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
# Ref: https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html#target-tracking-choose-metrics

resource "aws_autoscaling_policy" "myapp-target-tracking-policy" {
  name = "myapp-targe-target-policy"
  autoscaling_group_name = aws_autoscaling_group.myapp-asg.name
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 240

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"   
    }
    target_value = 30
    disable_scale_in = false
  }
}

# Create AUTO SCALING NOTIFICATION & ASSOCIATE WITH EXISTING SNS TOPIC

resource "aws_autoscaling_notification" "myapp-asg-notification" {
  group_names = [ aws_autoscaling_group.myapp-asg.name ]

  notifications = [ 
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
   ]
   
   topic_arn = aws_sns_topic.cpu-alerts-topic.arn
}