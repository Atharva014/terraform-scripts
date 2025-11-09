output "vpc_id" {
  value = aws_vpc.aws_vpc_label.id
}

output "vpc_cider" {
  value = aws_vpc.aws_vpc_label.cidr_block
}

output "vpc_web_sub_cidr_block" {
  value = aws_subnet.vpc_web_pub_sub_label[*].cidr_block
}

output "vpc_app_sub_cidr_block" {
  value = aws_subnet.vpc_app_priv_sub_label[*].cidr_block
}

output "vpc_adb_sub_cidr_block" {
  value = aws_subnet.vpc_db_priv_sub_label[*].cidr_block
}
