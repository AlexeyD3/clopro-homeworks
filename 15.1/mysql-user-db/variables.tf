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

###Mysql db
variable "cluster_id" {
  type = string
}

variable "db_name" {
  type = string
}

### Mysql user
variable "user_name" {
  type = string
}

variable "user_password" {
  type = string
  default = "netology1"
  sensitive   = true
}

variable "user_roles" {
  type = list(string)
  default = ["ALL"]
}