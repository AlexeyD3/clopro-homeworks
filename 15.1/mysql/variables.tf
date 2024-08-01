###cloud vars
variable "yc_token" {
  type        = string
  sensitive   = true
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "yc_cloud_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "yc_folder_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "VPC provider zone"
}

### MySQL cluster vars
variable "name" {
  type        = string
}

variable "network_id" {
  type        = string
}

variable "mysql_cluster" {
  default = {
    environment         = "PRESTABLE"
    version             = "8.0"
    security_group_ids  = null
    deletion_protection = false
  }
  type = object({
    environment         = string
    version             = string
    security_group_ids  = list(string)
    deletion_protection = bool
  })
}

variable "resource_cluster" {
  default = {
    preset_id    = "s2.micro"
    disk_type_id = "network-ssd"
    disk_size    = 10
  }
  type = object({
    preset_id    = string
    disk_type_id = string
    disk_size    = number
  })
}

variable "subnet_zones" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "HA" {
  type        = bool
  description = "change to true for cluster with 3 hosts, or false for cluster wit 1 host"
}
