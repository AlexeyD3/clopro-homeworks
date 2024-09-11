1locals {
    current_timestamp = timestamp()
    formatted_date = formatdate("DD-MM-YYYY", local.current_timestamp)
    bucket_name = "dubrovin-${local.formatted_date}"
}

// Создаем сервисный аккаунт для backet
resource "yandex_iam_service_account" "service-s3" {
  folder_id = var.folder_id
  name      = "bucket-sa"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-uploader" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.service-s3.id}"
  depends_on = [yandex_iam_service_account.service-s3]
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.service-s3.id
  description        = "static access key for s3"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "dubrovin" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = local.bucket_name
  acl    = "public-read"
}

// Загружаем изображение в бакет
resource "yandex_storage_object" "gif_cat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = local.bucket_name
  key    = "cat.gif"
  source = "/mnt/cat.gif"
  acl = "public-read"
  depends_on = [yandex_storage_bucket.dubrovin]
}
