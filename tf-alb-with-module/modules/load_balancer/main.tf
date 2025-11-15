# Target Group creation
resource "aws_lb_target_group" "this" {
  name = "alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 10
    timeout = 5
    path = "/"
    protocol = "HTTP"
    matcher = "200"
  }
  tags = merge(var.common_tags, { Name = "ath-alb-tg" })
}

# Instances attachment to TG
resource "aws_lb_target_group_attachment" "this" {
  count = length(var.instances_id)
  target_group_arn = aws_lb_target_group.this.arn
  port = 80
  target_id = var.instances_id[count.index]
}

# ALB creation
resource "aws_lb" "this" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.alb_sg_id ]
  subnets = var.subnet_ids
  tags = merge(var.common_tags, { Name = "ath-alb" })
}

# ALB Listener creation
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}