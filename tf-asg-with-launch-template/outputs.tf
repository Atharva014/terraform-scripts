output "pub_sub_ids" {
  value = module.vpc.pub_sub_ids
}

output "asg_name" {
  value = module.asg.asg_name
}

output "launch_template_id" {
  value = module.asg.launch_template_id
}