variable "prometheus_servers" {}

resource "openstack_compute_instance_v2" "prometheus-vm" {
  count       = var.prometheus_servers
  provider    = openstack
  name        = "prometheus-${count.index + 1}"
  image_name  = var.image_name
  flavor_name = "c2-30"
  key_pair    = openstack_compute_keypair_v2.sshkey.name
  network {
    name = "Ext-Net"
  }
}
