output "VSE-SSH-details-with-Service_ips" {
  description = "AWS VZENs Public and Forwarding IP Addresses"
  value       = [
    for i in range(length(module.vzen_vm.management_ip)) : {
      service_ip  = module.vzen_vm.forwarding_ip[i],
      ssh_command = "ssh -i ./${var.name_prefix}-key-${random_string.suffix.result}.pem zsroot@${module.vzen_vm.management_ip[i]}" 
    }
  ]
}