variable "promscale_servers" {}

resource "openstack_compute_instance_v2" "promscale-vm" {
  count       = var.promscale_servers
  provider    = openstack
  name        = "promscale-${count.index + 1}"
  image_name  = var.image_name
  flavor_name = "b2-60"
  key_pair    = openstack_compute_keypair_v2.sshkey.name
  network {
    name = "Ext-Net"
  }
}
