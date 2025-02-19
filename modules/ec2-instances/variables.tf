// Variables for modules ec2-instances

variable "server_port" {
    description = "Port where the server is listening"
    type = number
    default = 8080

    validation {
        condition = var.server_port > 0 && var.server_port < 65535
        error_message = "The port must be between 1024 and 65535"
    }
}

variable "instance_type" {
    description = "Instance type"
    type = string
}

variable "ami_id" {
    description = "AMI ID for the instance"
    type = string

}

variable "servers" {
    type = map(object({
        name = string
        subnet_id = string
    }))

}   