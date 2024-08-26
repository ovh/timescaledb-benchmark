variable "haproxy_servers" {}

resource "openstack_compute_instance_v2" "haproxy-vm" {
  count       = var.haproxy_servers
  provider    = openstack
  name        = "haproxy-${count.index + 1}"
  image_name  = var.image_name
  flavor_name = "b2-60"
  key_pair    = openstack_compute_keypair_v2.sshkey.name
  network {
    name = "Ext-Net"
  }
}
