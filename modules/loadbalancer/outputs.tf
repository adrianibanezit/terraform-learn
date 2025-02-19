// Output the load balancer's module

output "public_dns_lb" {
    value = "http://${aws_lb.alb.dns_name}:${var.lb_port}"
    description = "Public DNS of the Load Balancer"
}