output "web_instance_public_ips" {
  value = module.ec2_mod_label.web_instance_public_ips
  description = "Public IPs of web servers"
}