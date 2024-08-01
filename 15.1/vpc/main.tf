resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  count       = length(var.subnets)
  name           = "${var.vpc_name}-${count.index}"
  zone           = var.subnets[count.index].zone
  v4_cidr_blocks = ["${(var.subnets[count.index].v4_cidr_blocks)}"]
  network_id     = "${yandex_vpc_network.develop.id}"
}
