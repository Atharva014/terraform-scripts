# Instance creation
resource "aws_instance" "this" {
  count = var.instance_count
  subnet_id = var.pub_sub_ids[count.index]
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = var.instance_key
  vpc_security_group_ids = [ var.web_srv_sg_id ]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd php php-mysqlnd
    systemctl start httpd
    systemctl enable httpd
    
    # Download WordPress
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* .
    rm -rf wordpress latest.tar.gz
    
    # Configure WordPress
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${var.db_name}/" wp-config.php
    sed -i "s/username_here/${var.db_username}/" wp-config.php
    sed -i "s/password_here/${var.db_password}/" wp-config.php
    sed -i "s/localhost/${var.db_endpoint}/" wp-config.php
    
    # Set permissions
    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html
  EOF 

  tags = merge(var.common_tags, { Name = "wordpress-srv-${count.index}" })
}