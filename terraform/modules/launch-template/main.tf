resource "aws_launch_template" "app" {
  name          = "app-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  network_interfaces {
    security_groups             = [var.security_group_id]
    associate_public_ip_address = false
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "app-instance"
      Environment = var.environment
    }
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config \
      -m ec2 \
      -s \
      -c ssm:/cloudwatch/config
    EOF
  )
}
