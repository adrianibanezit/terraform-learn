output "public_dns_lb" {
    value = module.loadbalancer.public_dns_lb
    description = "Public DNS of the Load Balancer"
}



