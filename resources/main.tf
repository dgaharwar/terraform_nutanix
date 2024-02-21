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
  description = "Arch-Linux-x86_64-basic.qcow2"
  source_uri  = "https://mirror.pkgbuild.com/images/v20231215.200192/Arch-Linux-x86_64-basic.qcow2"
}

data "template_file" "unattend" {
  template = file("${path.module}/unattend.xml")
  vars = {
    vm_name             = var.t_vm_name
    hostname            = var.t_hostname
    admin_username      = var.t_admin_username
    admin_password      = var.t_admin_password
  }
}

resource "nutanix_virtual_machine" "vm" {
  count                = var.instance_count
  name                 = "hashi-{count.index}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = var.t_num_sockets
  memory_size_mib      = var.t_memory_size_mib

  guest_customization_sysprep = {
    install_type = "PREPARED"
    unattend_xml = base64encode(data.template_file.unattend.rendered)
  }

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

  provisioner "local-exec" {
    command = <<EOT
    echo "not doing anything anymore"
    EOT
  }
}
