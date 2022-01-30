

#TEMLATE: v4.0 6-24-2021 ironcat
################################################Global Settings and Variables#############################################
###Standard PS AWS Setup REQUIRED TO USE US-WEST-2
variable "region" {
  default = "us-east-1"

}

provider "aws" {
  region = var.region
  # REMOVE THIS KEY BEFORE UPLOADING TO PS AUTHOR PLATFORM
  #access_key = ""
  #secret_key = ""
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

###############################################################################################
/*
 ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
 ▐░▌           ▐░▌ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
  ▐░▌         ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
   ▐░▌       ▐░▌   ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
    ▐░▌     ▐░▌    ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
     ▐░▌   ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀█░█▀▀  ▀▀▀▀▀▀▀▀▀█░▌
      ▐░▌ ▐░▌      ▐░▌       ▐░▌▐░▌     ▐░▌            ▐░▌
       ▐░▐░▌       ▐░▌       ▐░▌▐░▌      ▐░▌  ▄▄▄▄▄▄▄▄▄█░▌
        ▐░▌        ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
         ▀          ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀
*/

### Requires the Random Provider- creats a random string thank can server a variety of ues, s3 buckets and passwords alike.
resource "random_string" "version" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "random_string" "user_name" {
  length  = 4
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "random_string" "password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!"
}

##################################################################START PKI KEY CONFIGURATION##########################################
resource "tls_private_key" "pki" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

output "private_key_pem" {
  value     = tls_private_key.pki.private_key_pem
  sensitive = true
}

resource "local_file" "pki" {
  content         = tls_private_key.pki.private_key_pem
  filename        = ".ssh/redscan-key"
  file_permission = "0600"
}

resource "aws_key_pair" "terrakey" {
  key_name   = "redscan-key"
  public_key = tls_private_key.pki.public_key_openssh
}

#creating s3 instance resource 0.
resource "aws_s3_bucket" "securitylab" {
  bucket        = "securitylab-${random_string.version.result}"
  request_payer = "BucketOwner"
  tags          = {}

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket_object" "privatekey" {
  key    = "redscan-key"
  bucket = aws_s3_bucket.securitylab.id
  source = ".ssh/redscan-key"
  acl    = "public-read"
  depends_on = [
    local_file.pki
  ]
}
##################################################################END PKI KEY CONFIGURATION##########################################
#
#
#
/*
 ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄    ▄
▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌
▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▐░▌
▐░▌▐░▌    ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌
▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌   ▄   ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌
▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░▌
▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░▌ ▐░▌░▌ ▐░▌▐░▌       ▐░▌▐░█▀▀▀▀█░█▀▀ ▐░▌░▌
▐░▌    ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌     ▐░▌  ▐░▌▐░▌
▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌░▌   ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌ ▐░▌ ▐░▌
▐░▌      ▐░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌  ▐░▌
 ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀       ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀    ▀


*/

##################################################################Networking Configurations##########################################
#
# Creating Security Groups with DNS resolution
#
#####################################################################################################################################
# Variable used in the creation of the `lab_vpc_internet_access` resource
variable "cidr_block" {
  default = "0.0.0.0/0"
}

# Custom VPC shows the use of tags to name resources
# Instance Tenancy set to `default` is not to be confused with the concept of a Default VPC
###NETWORKING----> add subnets here within vpc scope
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "172.19.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "Lab VPC"
  }
}
# Custom VPC shows the use of tags to name resources
#external security groupingfor vpc global scope
###Pair this with commented out activity in SSH and RDP security groups.  Use the proper security group ONLY on the device you want to have access to the pinhole.
###SEE SG COMMENT CODE
########################################################################################################################

#Currently allowing all ssh in to any device...all ec2 instances are using the generated keypair.

resource "aws_security_group" "ssh_console" {
  name   = "ssh_console"
  vpc_id = aws_vpc.lab_vpc.id
  #lock down to egress only to internal subnets generated in this lab! ~add to automation.
  #EGRESS allowed to all other devices created by default, restrict as you see fit.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #EGRESS ONLY ALLOWED TO FORWARD PROXY
  ######################################
  ###SG COMMENT CODE TO ALLOW DNS RESOLVED IPS IN SECURITY GROUP ONLY ALLOW 1 PORT
  ##Do this for each security group that requires this capability, then use this security group on the appropriate EC2 Instance BELOW.
  ### CAREFUL Not only can this be as security risk it is unstable with some content that uses CDNs. Preffered action is not to use this for installs but to pre-install or pre stage/download packages instead.
  ###########################################################################
  # For Tudor Cluster & internal guac capability--> REQUIRED!

}

resource "aws_security_group" "proxy" {
  name   = "proxy_rules"
  vpc_id = aws_vpc.lab_vpc.id

  #lock down to egress only to internal subnets generated in this lab! ~add to automation.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Custom Internet Gateway - not created as part of the initialization of a VPC

resource "aws_internet_gateway" "lab_vpc_gateway" {
  vpc_id = aws_vpc.lab_vpc.id
}

# Create a Route in the Main Routing Table - no need to create a Custom Routing Table
# Use `main_route_table_id` to pull the ID of the main routing table

resource "aws_route" "lab_vpc_internet_access" {
  route_table_id         = aws_vpc.lab_vpc.main_route_table_id
  destination_cidr_block = var.cidr_block
  gateway_id             = aws_internet_gateway.lab_vpc_gateway.id
}

#proxy subnet
resource "aws_subnet" "subnet_proxy" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "172.19.245.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

}

# Add a consoles subnet unless specifically required otherwise.  172.31.37-47.0
# VPC Subnet B - endpoint subnet  172.31.24.0/24
resource "aws_subnet" "subnet_consoles" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "172.19.24.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# VPC Subnet B - endpoint subnet  172.31.64-74.0/24
resource "aws_subnet" "subnet_enva" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "172.19.37.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

#Console Subnet. Where the user engages on console or directly to the EC2. Separated from other resources intentionally.
resource "aws_subnet" "subnet_envb" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "172.19.64.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

##############################SSM IAM ROLE STUFF##############################
/*
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌     ▐░▌     ▐░▌
▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▐░▌ ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▀   ▐░▌     ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌               ▐░▌
▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄  ▄▄▄▄▄▄▄▄▄█░▌
▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
 ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀

*/
##############################################################EC2 Endpoint Configurations#####################################################################################################
#######################finding CURRENT AMI's for supported operating systems, does not hurt anything to leave in #############################################################################
##############################################################################################################################################################################################
#RHEL 7.8
data "aws_ami" "rhel8" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-7.8_HVM_GA-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["309956199498"]
}


#Ubuntu 20.04

data "aws_ami" "u20" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}


###############################Define EC2 INstances#####################################################
#Include templates and then create matching template files#
#console box script
###### All template files mapped with required variables################D
/*
##########SAME FOR EVERY LAB############################################################################

*/


/*

*/

####################Conoles for user access through guacamole and main interface for lab###############################
##### Ubuntu SSH Console ##############################################################################################
#creating EC2 instance resource 0. # SCANNER INSTANCE - scanner subnet...scanner security group.

data "template_file" "nmap_loader" {
  template = file("nmap_loader.sh")
  vars = {
    # micro_webapp_ip = aws_instance.ps-t2micro-webapp.private_ip
  }
}

resource "aws_instance" "nmap_scanner" {
  #change the ubuntu AMI to suite your needs u18 and u20 have been heavily tested but not all services work the same in each.
  ami                         = data.aws_ami.u20.id
  count                       = 5
  associate_public_ip_address = true
  disable_api_termination     = false
  ebs_optimized               = false
  get_password_data           = false
  hibernation                 = false
  instance_type               = "t2.micro"
  ipv6_address_count          = 0
  ipv6_addresses              = []
  monitoring                  = false
  #SUBNET IS FOR CONFIGURED IN THE NETWORK SECTION
  subnet_id = aws_subnet.subnet_consoles.id
  key_name  = aws_key_pair.terrakey.key_name
  #CONSIDER THE SECURITY GROUP REQUIREMENTS FOR CHANGING SUBNETS, SG's DEFINED IN NETWORK SECTION
  vpc_security_group_ids = [aws_security_group.ssh_console.id]
  #iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  tags = {
    Name = "NMAP-SCANNER"
  }
  user_data = data.template_file.nmap_loader.rendered
  timeouts {}
}

#########################################################################################
####EOL FOR SSH UBUNTU CONSOLE##############################################################
#########################################################################################

################################################### Dump file or information #######################################
/*

 __   ___   ___ ___   _   ___ _    ___    ___  _   _ _____ ___ _   _ _____
 \ \ / /_\ | _ \_ _| /_\ | _ ) |  | __|  / _ \| | | |_   _| _ \ | | |_   _|
  \ V / _ \|   /| | / _ \| _ \ |__| _|  | (_) | |_| | | | |  _/ |_| | | |
   \_/_/ \_\_|_\___/_/ \_\___/____|___|  \___/ \___/  |_| |_|  \___/  |_|

*/
# REQUIRED TO HAVE THESE EXACT VARIALBES IN FOLDERS INSIDE THE "CONNECTIONS" FOLDER WILL CAUSE GENERAL RELEASE ERRORS  GUACAMOLE CONNECTIONED DEVICES ONLY.
################################################### Dump file or information #######################################

output "exec_time" {
  value = timestamp()
}

output "rdp-pw" {
  value = "${random_string.password.result}"
  }

#EOL
