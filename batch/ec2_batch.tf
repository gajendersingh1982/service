locals {
  batch_ami = data.aws_ami.batch_ami.id
}

# data "template_file" "setup-cloudwatchAgent" {
#   template = file("../scripts/cloudwatchAgent.sh")
#   vars = {
#     # Any variables to be passed in shell script
#     PACKER_VER = "1.5.6"
#     TERRAFORM_VER = "0.12.24"
#   }
# }
# data "template_file" "setup-batch" {
#   template = file("../scripts/batch.sh")
#   vars = {
#     # Any variables to be passed in shell script
#   }
# }

# data "template_cloudinit_config" "batch_config" {
#   gzip          = true
#   base64_encode = true

#   # get user_data --> Batch Server
#   part {
#     filename     = "batch.cfg"
#     content_type = "text/x-shellscript"
#     content      = "${data.template_file.setup-batch.rendered}"
#   }
  
#   part {
#     filename     = "cloudwatchAgent.cfg"
#     content_type = "text/x-shellscript"
#     content      = "${data.template_file.setup-cloudwatchAgent.rendered}"
#   }  
# }

module "batch" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  
  #essential [required for Infra Governance]
  name                    = format("%s-%s-%s-%s-batch", var.prefix, var.region_name, var.stage, var.service)
  instance_count          = "1"

  ami                     = local.batch_ami
  instance_type           = var.instance_type_batch
  key_name                = var.key_name
  monitoring              = false

  vpc_security_group_ids  = [module.batch_sg.this_security_group_id]
  #subnet_id               = module.vpc.public_subnets[0]
  subnet_id               = data.terraform_remote_state.infra.outputs.public_subnets[0]

  # set instance profile to give EC2 read only permissions
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_batch.name

  # set user data for configuring server  
  # user_data               = data.template_cloudinit_config.batch_config.rendered

  tags                    = var.tags
}

# EIP for Batch server
resource "aws_eip" "eip_batch" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = module.batch.id[0]
  allocation_id = aws_eip.eip_batch.id
}