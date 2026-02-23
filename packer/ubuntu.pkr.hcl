packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.0"
    }
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

# ----------------------------
# VirtualBox Builder
# ----------------------------

source "virtualbox-iso" "ubuntu" {
  iso_url      = "ubuntu-24.04.4-live-server-amd64.iso"
  iso_checksum = "sha256:e907d92eeec9df64163a7e454cbc8d7755e8ddc7ed42f99dbc80c40f1a138433"

  vm_name       = "ubuntu-golden-{{timestamp}}"
  guest_os_type = "Ubuntu_64"
  firmware      = "bios"

  memory   = 4096
  cpus     = 2
  headless = true

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout  = "30m"

  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"

  cd_files = [
    "http/meta-data",
    "http/user-data"
  ]

  cd_label = "cidata"

  boot_wait = "10s"

  boot_command = [
    "<wait10s>",
    "<esc>",
    "<wait1s>",
    "e",
    "<wait1s>",
    "<down><down><down>",
    "<end>",
    " autoinstall ds=nocloud;s=/cdrom/ ---",
    "<f10>"
  ]
}

# ----------------------------
# AWS AMI Builder
# ----------------------------

source "amazon-ebs" "ubuntu-aws" {
  region           = "us-east-2"
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  ami_name         = "ubuntu-golden-{{timestamp}}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

# ----------------------------
# Build Block
# ----------------------------

build {

  sources = [
    "source.virtualbox-iso.ubuntu",
    "source.amazon-ebs.ubuntu-aws"
  ]

  provisioner "ansible" {
    playbook_file = "../ansible/site.yml"
    user          = "packer"
    use_proxy     = false
  }
}
