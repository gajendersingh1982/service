prefix = "tf"
region_name = "virginia"
service = "bixby"
stage = "stg"
vpc_region = "us-east-1" 

tags = {
    "Service" = "bixby"
    "Stage"     = "stg"
}

# Instance Details
instance_type_admin = "t3.micro"
instance_type_openapi = "t3.micro"
key_name = "bixby_dev"
# was_ami_name = "tf-virginia-stg-bixby-was*"

# Firewall variables
restrictedIP = ["223.235.161.164/32", "103.81.106.248/30"]
#                      SEA IP,             SRID IP

network_backend_state = "bixby/stg/us-east-1/network/terraform.tfstate"