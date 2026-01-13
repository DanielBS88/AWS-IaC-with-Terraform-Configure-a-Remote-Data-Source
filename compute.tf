resource "aws_instance" "this" {
  ami                    = "ami-0c55b159cbfafe1f0" # Exemplo: Amazon Linux 2, ajuste conforme necessário
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.base_infra.outputs.security_group_id]

  tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}
