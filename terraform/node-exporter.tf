variable "node-exporter_servers" {}

resource "openstack_compute_instance_v2" "node-exporter-vm" {
  count       = var.node-exporter_servers
  provider    = openstack
  name        = "node-exporter-${count.index + 1}"
  image_name  = var.image_name
  flavor_name = "c2-15"
  key_pair    = openstack_compute_keypair_v2.sshkey.name
  network {
    name = "Ext-Net"
  }
}
