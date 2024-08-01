# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gm5cnlfgcnmeq4an1v"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1ggvhbs15psoc1vgtkc"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7" {
  default = "fd8nh58q091cqtldf3rr"
}

variable "instance_cores" {
  default = "4"
}

variable "instance_memory" {
  default = "4"
}


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
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###ssh vars

variable "vms_ssh" {

  default = {
    user               = "ubuntu"
    serial-port-enable = 1
    pub_key            = "~/.ssh/id_ed25519.pub"
  }
  type = object({
    user               = string
    serial-port-enable = number
    pub_key            = string
  })
}
