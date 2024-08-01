resource "yandex_mdb_mysql_database" "db1" {
  cluster_id = var.cluster_id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "client" {
  cluster_id = var.cluster_id
  name       = var.user_name
  password   = var.user_password
  permission {
    database_name = var.db_name
    roles         = var.user_roles
  }
}