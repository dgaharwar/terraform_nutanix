variable "cluster_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "password" {
  type = string
}

variable "endpoint" {
  type = string
}

variable "username" {
  type = string
}

variable "port" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "t_num_sockets" {
  description = "Nutanix VM vCPUS's"
  type = string
  default = "<%=customOptions.i_vcpu%>"
}

variable "t_memory_size_mib" {
  description = "Nutanix VM MEM"
  type = string
  default = "<%=customOptions.i_vmem%>"
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}