AWS IaC with Terraform: Configure a Remote Data Source

Lab Description
The objective of this lab is to learn how to use Terraform's remote state data source to access outputs from an existing infrastructure. You will connect to a pre-deployed "Landing Zone" infrastructure stored in S3 and create an EC2 instance using the existing VPC, subnet, and security group resources.
Common Task Requirements
•	Do not define the backend in the configuration; Terraform will use the local backend by default.
•	Avoid the usage of the local-exec provisioner.
•	The use of the prevent_destroy lifecycle attribute is prohibited.
•	Use versions.tf to define the required versions of Terraform and its providers.
•	Define the Terraform required_version as >= 1.5.7.
•	All variables must include valid descriptions and type definitions, and they should only be defined in variables.tf.
•	Resource names provided in tasks should be defined via variables or generated dynamically/concatenated (e.g., in locals using Terraform functions). Avoid hardcoding in resource definitions or using the default property for variables.
•	Configure all non-sensitive input parameter values in terraform.tfvars.
•	Outputs must include valid descriptions and should only be defined in outputs.tf.
•	Ensure TF configuration is clean and correctly formatted. Use the terraform fmt command to rewrite Terraform configuration files into canonical format and style.


Task Resources
•	AWS aws_instance resource - allows provisioning and managing EC2 instances in AWS
•	Terraform terraform_remote_state data source - retrieves outputs from existing Terraform state stored remotely
•	Tags – key-value metadata pairs used in AWS to organize resources, track costs, and support automation.
The following tags must be added to the EC2 instance:
•	Terraform=true
•	Project=cmtr-k5vl9gpq
•	Local files:
•	variables.tf - defines variables used across Terraform configurations
•	terraform.tfvars - contains variable values provided by the platform
•	data.tf - contains the remote state data source configuration
•	compute.tf - defines the EC2 instance using remote state outputs
•	Pre-deployed Landing Zone infrastructure:
•	VPC with public and private subnets
•	Security group for EC2 instances (allows SSH and HTTP)
•	All resources stored in remote Terraform state
•	Remote state configuration:
•	S3 Bucket: cmtr-k5vl9gpq-tf-state-1768333470
•	State file key: infra.tfstate
•	AWS Region: us-east-1
•	Project ID: cmtr-k5vl9gpq
•	Available remote state outputs:
•	vpc_id - ID of the VPC
•	public_subnet_id - ID of the public subnet
•	private_subnet_id - ID of the private subnet
•	security_group_id - ID of the EC2 security group

Objectives
1.	Create files variables.tf, terraform.tfvars, data.tf, and compute.tf.
2.	In the variables.tf file, define the following variables with appropriate descriptions and types:
- aws_region - AWS region for resources
- project_id - Project identifier for tagging
- state_bucket - S3 bucket name for remote state
- state_key - S3 key path for remote state file
3.	In the terraform.tfvars file, set the variable values using the platform-provided variables.
4.	In the data.tf file:
- Configure the Terraform remote state data source using S3 backend
- Use variables for bucket, key, and region configuration (do NOT hardcode values)
- Name the data source base_infra for consistency
5.	In the compute.tf file:
- Create an aws_instance resource in public subnet
- Use remote state outputs for subnet and security group configuration
- Do NOT hardcode any AWS resource IDs (vpc-xxx, subnet-xxx, sg-xxx)
- All infrastructure references must come from data.terraform_remote_state.base_infra.outputs
- Add the required tags: Terraform=true and Project=cmtr-k5vl9gpq
6.	Validation and formatting:
- Run terraform fmt to format your code
- Run terraform validate to ensure configurations are correct
- Run terraform plan to preview infrastructure changes
- Run terraform apply to deploy the EC2 instance

Task Verification – Walk me through to check the validation below.
The verification process will test the following:
1.	File Structure: All required files exist (variables.tf, terraform.tfvars, data.tf, compute.tf)
2.	EC2 Instance Creation: EC2 instance is deployed with correct subnet and security group from remote state
3.	Remote State Usage: Configuration properly uses terraform_remote_state data source
4.	No Hardcoded Values: No AWS resource IDs are hardcoded in the configuration
5.	Required Tags: EC2 instance has Terraform=true and Project=cmtr-k5vl9gpq tags

Important Notes:
- Do not hardcode any AWS resource IDs in your Terraform configuration
- All infrastructure references must come from the remote state data source
- Use variables for all remote state connection parameters
- The Landing Zone infrastructure is read-only and cannot be modified
