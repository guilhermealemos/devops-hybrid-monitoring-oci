output "instance_public_ip" {
  description = "IP Público da Instância de Monitoramento"
  value       = oci_core_instance.monitoring_server.public_ip
}

output "instance_id" {
  description = "OCID da Instância Criada"
  value       = oci_core_instance.monitoring_server.id
}

output "ssh_command" {
  description = "Comando rápido para conectar via SSH"
  value       = "ssh ubuntu@${oci_core_instance.monitoring_server.public_ip}"
}
