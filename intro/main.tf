terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">=1.7.1"
    }
  }
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}
data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

provider "nutanix" {
  username     = var.username
  password     = var.password
  endpoint     = var.endpoint
  port         = var.port
  insecure     = true
  wait_timeout = 60
}

resource "nutanix_image" "image" {
  name        = "Arch Linux"
  description = "Arch-Linux-x86_64-basic-20230901.175781.qcow2"
  source_uri  = "https://mirror.pkgbuild.com/images/v20230901.175781/Arch-Linux-x86_64-basic-20230901.175781.qcow2"
}

resource "nutanix_virtual_machine" "vm" {
  count                = "${var.instance_count}"
  name                 = "hashi-${count.index}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = var.t_num_sockets
  memory_size_mib      = var.t_memory_size_mib

  guest_customization_cloud_init_user_data = base64encode(templatefile("${path.module}/resources/cloud-init/generic_pw.tpl", { hostname = "hashi-${count.index}" }))

  disk_list {
    disk_size_bytes = 104857600000
    disk_size_mib   = 100000
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.image.id
    }
  }

  disk_list {
    disk_size_bytes = 10 * 1024 * 1024 * 1024
    device_properties {
      device_type = "DISK"
      disk_address = {
        "adapter_type" = "SCSI"
        "device_index" = "1"
      }
    }
  }
  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }
}
