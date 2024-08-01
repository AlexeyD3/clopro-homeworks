resource "yandex_mdb_mysql_cluster" "netology" {
  name                = var.name
  environment         = var.mysql_cluster.environment
  network_id          = var.network_id
  version             = var.mysql_cluster.version
  security_group_ids  = var.mysql_cluster.security_group_ids
  deletion_protection = var.mysql_cluster.deletion_protection

  resources {
    resource_preset_id = var.resource_cluster.preset_id
    disk_type_id       = var.resource_cluster.disk_type_id
    disk_size          = var.resource_cluster.disk_size
  }

    dynamic "host" {
      for_each = range(local.host_count)
      content {
        zone             = element(var.subnet_zones, "${host.key + 1}")
        subnet_id        = element(var.subnet_ids, "${host.key + 1}")
        assign_public_ip = true
      }
    }

}


