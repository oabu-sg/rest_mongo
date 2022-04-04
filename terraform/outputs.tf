output "webservers_ip_addresses_output" {
  value = aws_instance.devops106_terraform_osama_webserver_tf[*].public_ip
}