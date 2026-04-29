output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "web_port" {
  value = var.http_port
}

output "grafana_url" {
  value = "http://${aws_instance.app_server.public_ip}:${var.grafana_port}"
}

output "prometheus_url" {
  value = "http://${aws_instance.app_server.public_ip}:${var.prometheus_port}"
}
