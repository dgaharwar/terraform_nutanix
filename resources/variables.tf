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

#variable "instance_count" {
#  type = string
#}

variable "instance_name" {
  type    = string
  default = "<%=customOptions.Instance_Name%>"
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

variable "t_vm_name" {
  description = "Nutanix VM name van VM in CAPITALS"
  type        = string
  sensitive   = false
}

variable "t_hostname" {
  description = "hostnaam van VM"
  type        = string
  sensitive   = false
}

variable "t_admin_username" {
  description = "Name of domain for VMs"
  type        = string
  sensitive   = false
  default     = "Administrator"
}

variable "t_admin_password" {
  description = "Name of domain for VMs"
  type        = string
  sensitive   = true
}
