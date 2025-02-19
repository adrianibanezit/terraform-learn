// Outputs for ec2-instances modules

output "instances_ids" {
    value = [ for server in aws_instance.server : server.id ]
    description = "IDs of the instances"
}