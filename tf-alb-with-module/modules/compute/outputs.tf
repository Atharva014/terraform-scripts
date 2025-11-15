output "instances_ids" {
  value = aws_instance.this[*].id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}