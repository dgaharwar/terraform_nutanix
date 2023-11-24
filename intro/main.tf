terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.2.0"
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
  description = "Arch-Linux-x86_64-basic-20210401.18564"
  source_uri  = "https://mirror.pkgbuild.com/images/v20230615.158351/Arch-Linux-x86_64-basic-20230615.158351.qcow2"
}

resource "nutanix_virtual_machine" "vm" {
  name                 = "My VM from the Terraform Nutanix Provider"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = var.t_num_sockets
  memory_size_mib      = var.t_memory_size_mib

  disk_list {
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
