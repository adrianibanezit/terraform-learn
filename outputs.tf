output "public_dns_server_1" {
    value = "http://${aws_instance.server_1.public_dns}:${var.server_port}"
    description = "Public DNS of the server"
}

output "public_dns_server_2" {
    value = "http://${aws_instance.server_2.public_dns}:${var.server_port}"
    description = "Public DNS of the server"
}

output "public_dns_lb" {
    value = "http://${aws_lb.alb.dns_name}:${var.lb_port}"
    description = "Public DNS of the Load Balancer"
}



