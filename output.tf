output "vpc_id" {
  value = module.vpc.vpc_id
}
output "Bastion" {
  value = module.Bastion.public_ip
}
output "Ansible" {
  value = module.Ansible.private_ip
}
output "Jenkins" {
  value = module.Jenkins.private_ip
}
output "Master_Node" {
  value = module.Master_Nodes.*.private_ip
}
output "Stage_Master_Nodes" {
  value = module.Stage_Master_Nodes.*.private_ip
}
output "Nodes" {
  value = module.Nodes.*.private_ip
}
output "PROD_HAproxy" {
  value = module.PROD_HAproxy.private_ip
}
output "STAGE_HAproxy" {
  value = module.STAGE_HAproxy.private_ip
}
output "prod_elb_dns" {
  value = module.Prod_elb.prod_elb_dns
}
output "stage_elb_dns" {
  value = module.Stage_elb.stage_elb_dns
}