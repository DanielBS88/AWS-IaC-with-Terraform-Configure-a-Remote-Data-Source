resource "aws_instance" "ec2" {
  ami           = "ami-0a3c3a20c09d6f377" # Amazon Linux 2023 (us-east-1)
  instance_type = "t2.micro"

  subnet_id = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [
    data.terraform_remote_state.base_infra.outputs.security_group_id
  ]

  tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}
