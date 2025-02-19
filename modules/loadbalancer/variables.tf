// Variables for modules loadbalancer

variable "subnet_ids" {
    description = "Subnet IDs"
    type = set(string)   
}

variable "instances_ids" {
    description = "IDs of the instances"
    type = set(string)
}

variable "server_port" {
    description = "Port where the server is listening"
    type = number
    default = 8080

    validation {
        condition = var.server_port > 0 && var.server_port < 65535
        error_message = "The port must be between 1024 and 65535"
    }
}

variable "lb_port" {
    description = "Port where the Load Balancer is listening"
    type = number
    default = 80
}

