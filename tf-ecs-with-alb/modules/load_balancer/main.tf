# ALB security group
resource "aws_security_group" "this" {
  name = "alb-sg"
  description = "Allow inbound traffic on port 80"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks =  [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, { Name = "ecs-alb-sg" })
}

# ALB creation
resource "aws_lb" "this" {
  internal = false
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [ aws_security_group.this.id ]
  tags = merge(var.common_tags, { Name = "ecs-alb" })
}

# TG creation
resource "aws_lb_target_group" "this" {
  name = "alb-tg"
  port = 3000
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"
  tags = merge(var.common_tags, { Name = "ecs-alb-tg" })
}

# ALB listener
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  tags = merge(var.common_tags, { Name = "ecs-alb-listener" })
}