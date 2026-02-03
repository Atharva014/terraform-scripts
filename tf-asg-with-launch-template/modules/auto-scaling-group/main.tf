resource "aws_launch_template" "this" {
  name = "asg-launch-template"
  image_id = "ami-0ff5003538b60d5ec"
  instance_type = "t3.micro"
  key_name = "linux-key"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = var.sg_ids
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ASG Instance - $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
  )

  tags = merge(var.common_tags, { "Name" = "asg-launch-template" } )
}

resource "aws_autoscaling_group" "this" {
  desired_capacity = 1
  min_size = 1
  max_size = 4
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }
}

