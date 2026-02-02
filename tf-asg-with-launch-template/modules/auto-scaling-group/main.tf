resource "aws_launch_template" "this" {
  name = "asg-launch-template"
  image_id = "ami-0ff5003538b60d5ec"
  instance_type = "t3.micro"
  key_name = "linux-key"
  vpc_security_group_ids = var.sg_ids

  block_device_mappings {
    ebs {
      volume_size = 8
    }
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