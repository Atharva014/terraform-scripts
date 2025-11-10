output "vpc_id" {
  value = aws_vpc.aws_vpc_label.id
}

output "vpc_tag" {
  value = var.vpc_tag
}

output "vpc_region" {
  value = aws_vpc.aws_vpc_label.region
}

output "vpc_web_sub_ids" {
  value = aws_subnet.vpc_web_pub_sub_label[*].id
}

output "vpc_app_sub_ids" {
  value = aws_subnet.vpc_app_priv_sub_label[*].id
}

output "vpc_db_sub_ids" {
  value = aws_subnet.vpc_db_priv_sub_label[*].id
}