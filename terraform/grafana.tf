variable "grafana_servers" {}

resource "openstack_compute_instance_v2" "grafana-vm" {
  count       = var.grafana_servers
  provider    = openstack
  name        = "grafana-${count.index + 1}"
  image_name  = var.image_name
  flavor_name = "c2-15"
  key_pair    = openstack_compute_keypair_v2.sshkey.name
  network {
    name = "Ext-Net"
  }
}
