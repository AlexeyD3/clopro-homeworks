output "network_id" {
  value = yandex_vpc_network.develop.id
}

output "availability_zone" {
  value = "${yandex_vpc_subnet.develop.*.zone}"
}

output "subnet_ids" {
  value = "${yandex_vpc_subnet.develop.*.id}"
}

output "yandex_vpc_subnet" {
  value = yandex_vpc_subnet.develop
}