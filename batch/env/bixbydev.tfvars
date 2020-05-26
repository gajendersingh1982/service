prefix = "tf"
region_name = "virginia"
service = "bixby"
stage = "dev"
vpc_region = "us-east-1" 

tags = {
    "Service" = "bixby"
    "Stage"     = "dev"
}

# Instance Details
instance_type_batch = "t3.medium"
key_name = "bixby_dev"
batch_ami_name = "tf-virginia-dev-bixby-batch*"

# Firewall variables
restrictedIP = ["223.235.161.164/32", "103.81.106.248/30"]
#                      SEA IP,             SRID IP

network_backend_state = "bixby/dev/us-east-1/network/terraform.tfstate"