# Packer required plugins configuration for building golden AMI images.
packer {
  required_plugins {
    amazon = {
      version = ">= 0.1.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = formatdate("YYYYMMDD-HHmmss", timestamp())
}

data "amazon-ami" "source_ami" {

  region = var.aws_region
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    virtualization-type = "hvm"
    root-device-type    = "ebs"
  }

  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID
}

source "amazon-ebs" "ubuntu" {
  region                      = var.aws_region
  instance_type               = var.instance_type
  source_ami                  = data.amazon-ami.source_ami.id
  ami_name                    = "${var.ami_name}-${var.environment}-${local.timestamp}"
  ssh_username                = "ubuntu"
  associate_public_ip_address = true
}

build {
  name = "golden-ami-build"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "echo 'Updating package lists...'",
      "sudo apt-get update -y",
      "echo 'Installing security updates...'",
      "sudo apt-get upgrade -y --with-new-pkgs",
      "echo 'Cleaning up...'",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
      "sudo apt install apache2 -y",
      "sudo apt install git -y",
      "sudo apt install wget -y",
      "wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb",
      "sudo dpkg -i amazon-cloudwatch-agent.deb",
      "rm amazon-cloudwatch-agent.deb",
      "sudo systemctl enable amazon-cloudwatch-agent",
      "sudo systemctl enable apache2",
    ]
  }
}