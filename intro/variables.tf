variable "cluster_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "password" {
  type      = string
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

variable "t_num_sockets" {
  description = "Nutanix VM vCPUS's"
  type = string
  default = "<%=customOptions.i_vcpu%>"
}

variable "t_memory_size_mib" {
  description = "Nutanix VM MEM"
  type = string
  default = "<%=customOptions.i_mem%>"
}