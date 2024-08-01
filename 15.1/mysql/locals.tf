locals {
  host_count = "${var.HA == true ? 3 : 1}"
}