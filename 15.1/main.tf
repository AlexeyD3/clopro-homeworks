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

# Create VMs for NAT-instance
module "test-vm" {
  source          = "git::https://github.com/AlexeyD3/yandex_compute_instance.git?ref=main"
  env_name        = "netology"
  instance_name   = "NAT-instance"
  instance_count  = 2
  image_id        =  "fd80mrhj8fl2oe87o4e1"
  public_ip       = true
  network_id      = module.vpc.network_id
  subnet_zones    = "${module.vpc.availability_zone}"
  subnet_ids      = "${module.vpc.subnet_ids}"

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = var.vms_ssh.serial-port-enable
  }

}

# Create VMs for nginx
module "test-vm" {
  source          = "git::https://github.com/AlexeyD3/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  network_id      = module.vpc.network_id
  subnet_zones    = "${module.vpc.availability_zone}"
  subnet_ids      = "${module.vpc.subnet_ids}"

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = var.vms_ssh.serial-port-enable
  }

}



# Cloud-init install nginx on VMs
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    username           = var.vms_ssh.user
    ssh_public_key     = file(var.vms_ssh.pub_key)
  }
}

# Create MySQL Cluster (task 5.1)
module "mysql" {
  source       = "./mysql"
  name         = "managed"
  HA           = true    # change to <true> for cluster with 3 hosts, or <false> for cluster with 1 host
  network_id   = module.vpc.network_id
  subnet_ids   = "${module.vpc.subnet_ids}"
  subnet_zones = "${module.vpc.availability_zone}"
  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
}

# Create MySQL user & database (task 5.2)
module "mysql-user-db" {
  source       = "./mysql-user-db"
  cluster_id   = module.mysql.cluster_id
  user_name    = "user"
  db_name      = "db1"
  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
}

# Create MySQL Cluster (task 5.3)
module "mysql_example" {
  source       = "./mysql"
  name         = "example"
  HA           = true    # change to <true> for cluster with 3 hosts, or <false> for cluster with 1 host
  network_id   = module.vpc.network_id
  subnet_ids   = "${module.vpc.subnet_ids}"
  subnet_zones = "${module.vpc.availability_zone}"
  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
}

# Create MySQL user & database (task 5.3)
module "mysql-app-test" {
  source       = "./mysql-user-db"
  cluster_id   = module.mysql_example.cluster_id
  db_name      = "test"
  user_name    = "app"
  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
}