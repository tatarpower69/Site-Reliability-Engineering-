output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.main.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.server.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "grafana_url" {
  description = "URL for Grafana dashboard"
  value       = "http://${aws_eip.main.public_ip}:${var.grafana_port}"
}

output "prometheus_url" {
  description = "URL for Prometheus dashboard"
  value       = "http://${aws_eip.main.public_ip}:${var.prometheus_port}"
}

output "app_url" {
  description = "URL for the main application"
  value       = "http://${aws_eip.main.public_ip}:${var.http_port}"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${var.project_name}-key.pem ubuntu@${aws_eip.main.public_ip}"
}
