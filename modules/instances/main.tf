terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8"
    }
  }
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu22.qcow2"
  pool   = "default"
  source = var.base_volume_path
  format = "qcow2"
}

resource "libvirt_volume" "master_disk" {
  name           = "master.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10737418240
}

resource "libvirt_volume" "worker_disk" {
  name           = "worker.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10737418240
}

resource "libvirt_cloudinit_disk" "master_cloudinit" {
  name           = "master-cloudinit.iso"
  pool           = "default"
  user_data      = file("${path.module}/../../cloud-init/user-data.yml")
  network_config = file("${path.module}/../../cloud-init/network-config-master.yml")

  lifecycle {
    create_before_destroy = true
  }
}

resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  name           = "worker-cloudinit.iso"
  pool           = "default"
  user_data      = file("${path.module}/../../cloud-init/user-data.yml")
  network_config = file("${path.module}/../../cloud-init/network-config-worker.yml")
}

resource "libvirt_domain" "master" {
  name   = "master"
  memory = "2048"
  vcpu   = 2

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_id   = var.network_id
    addresses    = [var.master_ip]
  }

  disk {
    volume_id = libvirt_volume.master_disk.id
  }

  cloudinit = libvirt_cloudinit_disk.master_cloudinit.id
}

resource "libvirt_domain" "worker" {
  name   = "worker"
  memory = "2048"
  vcpu   = 2

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_id   = var.network_id
    addresses    = [var.worker_ip]
  }

  disk {
    volume_id = libvirt_volume.worker_disk.id
  }

  cloudinit = libvirt_cloudinit_disk.worker_cloudinit.id
}

