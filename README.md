[![Known Vulnerabilities](https://snyk.io/test/github/sourcefuse/
terraform-module-aws-bootstrap/badge.svg)]

(https://snyk.io/test/github/sourcefuse/
terraform-module-aws-bootstrap)

# terraform-project

Commands used in the Course

initialize

terraform init



preview terraform actions

terraform plan



apply configuration with variables

terraform apply -var-file terraform-dev.tfvars



destroy a single resource

terraform destroy -target aws_vpc.myapp-vpc



destroy everything fromtf files

terraform destroy



show resources and components from current state

terraform state list



show current state of a specific resource/data

terraform state show aws_vpc.myapp-vpc    



set avail_zone as custom tf environment variable - before apply

export TF_VAR_avail_zone="eu-west-3a"



More Information: AWS Services and components we use or create with Terraform

Amazon EC2 - Virtual Server: https://aws.amazon.com/ec2

Amazon VPC - Your Virtual Private Network on AWS: https://aws.amazon.com/vpc

Subnet - Subnetwork, logical subdivision of IP network: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html

Internet Gateway - a VPC component: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

Security Group - Virtual Firewall: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html

Route Table - Configuring Network Traffic: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html

Amazon S3  - Simple Storage: https://aws.amazon.com/s3/ 
