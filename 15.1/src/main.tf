# Create network and subnets
module "vpc" {
  source       = "./vpc"
  vpc_name     = "public"
  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
  subnets      = [
    { zone = "ru-central1-a", v4_cidr_blocks = "192.168.10.0/24" }
  ]
}

resource "yandex_compute_instance" "lighthouse" {
  name                      = "lighthouse"
  zone                      = "ru-central1-a"
  hostname                  = "lighthouse.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7}"
      name        = "root-lighthouse"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-mnt.id
    nat        = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Network
resource "yandex_vpc_network" "network-mnt" {
  name = "network-mnt"
}

resource "yandex_vpc_subnet" "subnet-mnt" {
  name           = "subnet-mnt"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-mnt.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# # Create VMs for NAT-instance
# module "test-vm" {
#   source          = "git::https://github.com/AlexeyD3/yandex_compute_instance.git?ref=main"
#   env_name        = "netology"
#   instance_name   = "NAT-instance"
#   instance_count  = 2
#   image_id        =  "fd80mrhj8fl2oe87o4e1"
#   public_ip       = true
#   network_id      = module.vpc.network_id
#   subnet_zones    = "${module.vpc.availability_zone}"
#   subnet_ids      = "${module.vpc.subnet_ids}"

#   metadata = {
#       user-data          = data.template_file.cloudinit.rendered
#       serial-port-enable = var.vms_ssh.serial-port-enable
#   }

# }

# # Create VMs for nginx
# module "test-vm" {
#   source          = "git::https://github.com/AlexeyD3/yandex_compute_instance.git?ref=main"
#   env_name        = "develop"
#   instance_name   = "web"
#   instance_count  = 2
#   image_family    = "ubuntu-2004-lts"
#   public_ip       = true
#   network_id      = module.vpc.network_id
#   subnet_zones    = "${module.vpc.availability_zone}"
#   subnet_ids      = "${module.vpc.subnet_ids}"

#   metadata = {
#       user-data          = data.template_file.cloudinit.rendered
#       serial-port-enable = var.vms_ssh.serial-port-enable
#   }

# }



# # Cloud-init install nginx on VMs
# data "template_file" "cloudinit" {
#   template = file("./cloud-init.yml")

#   vars = {
#     username           = var.vms_ssh.user
#     ssh_public_key     = file(var.vms_ssh.pub_key)
#   }
# }
