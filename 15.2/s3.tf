locals {
  service_acc_name     = "s3-acc"
  bucket_name = "netology-s3"
  bucket_max_size = "10240"
  storage_class = "COLD"
  image_s3     = "cat"
  source_image_s3 ="/mnt/cat.gif"
}

// Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = var.service_acc_name
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.bucket_name
  max_size              = var.bucket_max_size
  default_storage_class = var.storage_class
  anonymous_access_flags {
    read        = true
    list        = true
    config_read = false
  }
  tags = {
    netology = "image"
  }
}

// Загрузка изображения в бакет
resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket_name
  key        = var.image_s3
  source     = var.source_image_s3
}