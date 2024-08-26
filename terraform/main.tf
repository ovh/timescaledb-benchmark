variable "image_name" {}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      haproxy_instances       = openstack_compute_instance_v2.haproxy-vm.*,
      prometheus_instances    = openstack_compute_instance_v2.prometheus-vm.*,
      promscale_instances     = openstack_compute_instance_v2.promscale-vm.*,
      grafana_instances       = openstack_compute_instance_v2.grafana-vm.*,
      node-exporter_instances = openstack_compute_instance_v2.node-exporter-vm.*,
    }
  )
  filename             = "../ansible/inventories/terraform"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "openstack_compute_keypair_v2" "sshkey" {
  provider   = openstack
  name       = "timescaledb-benchmark"
  public_key = file("../id_rsa.pub")
}
