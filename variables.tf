variable "server_port" {
    description = "Port where the server is listening"
    type = number
    default = 8080
}

variable "lb_port" {
    description = "Port where the Load Balancer is listening"
    type = number
    default = 80
}

variable "instance_type" {
    description = "Instance type"
    type = string
    default = "t2.micro"
}