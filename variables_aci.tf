variable "apic_server" {}

variable "apic_username" {}

variable "apic_password" {
  sensitive = true
}

variable "aci_tenant" {}

variable "aci_vrf" {}

variable "aci_bd_1" {}

variable "aci_bd_2" {}

variable "aci_bd1_subnet" {}

variable "aci_bd2_subnet" {}

variable "aci_app_profile" {}

variable "aci_epg_1" {}

variable "aci_epg_2" {}

variable "aci_contract_subject" {}

variable "aci_filter_allow_https" {}

variable "aci_filter_allow_icmp" {}

variable "aci_filter_entry_https" {}

variable "aci_filter_entry_icmp" {}

variable "provider_profile_dn" {}

variable "vmm_domain" {}
