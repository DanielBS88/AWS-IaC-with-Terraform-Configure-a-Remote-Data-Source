output "ec2_instance_id" {
  description = "ID of the EC2 instance created"
  value       = aws_instance.ec2.id
}
