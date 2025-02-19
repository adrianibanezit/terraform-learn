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

variable "instance_type" {
    description = "Instance type"
    type = string
    default = "t2.micro"
}

variable "ubuntu_ami" {
    description = "Ubuntu AMI for region"
    type = map(string)
    default = {
        eu-west-1 = "ami-03fd334507439f4d1"
        us-west-2 = "ami-00c257e12d6828491"
    }
}

variable "servers" {
    type = map(object({
        name = string
        az = string
    }))

    default = {
        server_1 = { name = "server_1", az = "a" }
        server_2 = { name = "server_2", az = "b" }
        server_3 = { name = "server_3", az = "c" }
    }  
}   