resource "aws_lb" "this" {
  name = "asg-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.http_sg_id ]
  subnets = var.subnet_ids

  tags = merge(var.common_tags, { "Name" = "asg-lb" } )
}

resource "aws_lb_target_group" "this" {
  name = "asg-lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
  tags = merge(var.common_tags, { "Name" = "asg-tg" })
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.this.arn
  }
}