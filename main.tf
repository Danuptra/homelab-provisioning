terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "homelab" {
  name      = "homelab"
  mode      = "nat"
  domain    = "homelab.local"
  addresses = ["192.168.120.0/24"]
}

module "instances" {
  source            = "./modules/instances"
  network_id        = libvirt_network.homelab.id
  base_volume_path  = "/var/lib/libvirt/images/ubuntu22.qcow2"
  master_ip         = "192.168.120.10"
  worker_ip         = "192.168.120.11"
}
