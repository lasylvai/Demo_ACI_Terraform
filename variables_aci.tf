variable "apic_server" {
  default = "https://10.60.9.225"
}

variable "apic_username" {
  default = "admin"
}

variable "apic_password" {
  default = "cisco123"
}

variable "aci_tenant" {
  default = "Tenant_Terraform"
}

variable "aci_vrf" {
  default = "Production"
}

variable "aci_bd_1" {
  default = "Production-Segment-230"
}

variable "aci_bd_2" {
  default = "Production-Segment-231"
}

variable "aci_bd1_subnet" {
  default = "10.230.0.254/24"
}

variable "aci_bd2_subnet" {
  default = "10.231.0.254/24"
}

variable "aci_app_profile" {
  default = "Production"
}

variable "aci_epg_1" {
  default = "Segment-230"
}

variable "aci_epg_2" {
  default = "Segment-231"
}

variable "aci_contract_subject" {
  default = "Subject_TF"
}

variable "aci_filter_allow_https" {
  default = "allow_https"
}

variable "aci_filter_allow_icmp" {
  default = "allow_icmp"
}

variable "aci_filter_entry_https" {
  default = "https"
}

variable "aci_filter_entry_icmp" {
  default = "icmp"
}

variable "provider_profile_dn" {
  default = "uni/vmmp-VMware"
}

variable "vmm_domain" {
  default = "DVS_Domain"
}
