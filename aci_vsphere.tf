provider "aci" {
  username = var.apic_username
  password = var.apic_password
  url      = var.apic_server
  insecure = true
}



####################
### CREATION VRF ###
####################


resource "aci_vrf" "VRF_TF" {
  tenant_dn          = aci_tenant.Tenant_TF.id
  name               = var.aci_vrf
  description        = "VRF created by TF"
  #bd_enforced_enable = false
  pc_enf_pref            = "unenforced"
}


########################
### CREATION TENANT ####
########################

resource "aci_tenant" "Tenant_TF" {
  name        = var.aci_tenant
  description = "Tenant created by TF"
}



###################
### CREATION BD ###
###################


resource "aci_bridge_domain" "BD1_TF" {
  tenant_dn          = aci_tenant.Tenant_TF.id
  relation_fv_rs_ctx       = aci_vrf.VRF_TF.id
  name               = var.aci_bd_1
  description        = "BD created by TF"
  #relation_fv_rs_ctx = aci_vrf.VRF_TF.name
}

resource "aci_bridge_domain" "BD2_TF" {
  tenant_dn          = aci_tenant.Tenant_TF.id
  relation_fv_rs_ctx       = aci_vrf.VRF_TF.id
  name               = var.aci_bd_2
  description        = "BD created by TF"
  #relation_fv_rs_ctx = aci_vrf.VRF_TF.name
}

##########################
### CREATION BD SUBNET ###
##########################

resource "aci_subnet" "Subnet_BD1" {
  parent_dn = aci_bridge_domain.BD1_TF.id
  #name             = "Subnet"
  ip = var.aci_bd1_subnet
}

resource "aci_subnet" "Subnet_BD2" {
  parent_dn = aci_bridge_domain.BD2_TF.id

  #name             = "Subnet"
  ip = var.aci_bd2_subnet
}

####################################
### CREATION APPLICATION PROFILE ###
####################################

resource "aci_application_profile" "AppProfile_TF" {
  tenant_dn   = aci_tenant.Tenant_TF.id
  name        = var.aci_app_profile
  description = "App profile created by TF"
}

####################
### CREATION VMM ###
####################

data "aci_vmm_domain" "vds" {
  provider_profile_dn = var.provider_profile_dn
  name                = var.vmm_domain
}

#######################################
### CREATION EPG1 + ASSOCIATION VMM ###
#######################################

resource "aci_application_epg" "EPG_TF_1" {
  application_profile_dn = aci_application_profile.AppProfile_TF.id
  name                   = var.aci_epg_1
  description            = "EPG created by TF"
  relation_fv_rs_bd      = aci_bridge_domain.BD1_TF.id
  #CONTRACT ATTACHEMENT
  #relation_fv_rs_cons    = [aci_contract.Contract_EPG1_EPG2.id]
  #ATTACHEMENT VMM DOMAIN
  #relation_fv_rs_dom_att = [var.vmm_domain]
}

resource "aci_epg_to_domain" "VMM_TF_EPG_1" {

  application_epg_dn    = aci_application_epg.EPG_TF_1.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}


#######################################
### CREATION EPG2 + ASSOCIATION VMM ###
#######################################

resource "aci_application_epg" "EPG_TF_2" {
  application_profile_dn = aci_application_profile.AppProfile_TF.id
  name                   = var.aci_epg_2
  description            = "EPG created by TF"
  relation_fv_rs_bd      = aci_bridge_domain.BD2_TF.id
  #CONTRACT ATTACHEMENT
  #relation_fv_rs_prov    = [aci_contract.Contract_EPG1_EPG2.id]
  #ATTACHEMENT VMM DOMAIN
  #relation_fv_rs_dom_att = [var.vmm_domain]
}

resource "aci_epg_to_domain" "VMM_TF_EPG_2" {

  application_epg_dn    = aci_application_epg.EPG_TF_2.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}


##########################
#### CREATION CONTRACT ###
##########################
#
#resource "aci_contract" "Contract_EPG1_EPG2" {
#  tenant_dn   = aci_tenant.Tenant_TF.id
#  name        = "Contract_EPG1_EPG2"
#  description = "Contract created by TF"
#}
#
##################################
#### CREATION CONTRACT SUBJECT ###
##################################
#
#resource "aci_contract_subject" "Contract_Subject" {
#  contract_dn                  = aci_contract.Contract_EPG1_EPG2.id
#  name                         = var.aci_contract_subject
#  #relation_vz_rs_subj_filt_att = [aci_filter.allow_icmp.id]
#  #relation_vz_rs_subj_filt_att = [aci_filter.Filter_Allow_HTTPS.name, aci_filter.Filter_Allow_ICMP.name]
#  relation_vz_rs_subj_filt_att = [aci_filter.Filter_Allow_ICMP.id]
#}
#
#resource "aci_filter" "Filter_Allow_HTTPS" {
#  tenant_dn = aci_tenant.Tenant_TF.id
#  name      = var.aci_filter_allow_https
#}
#
#################################
#### CREATION CONTRACT FILTER ###
#################################
#
#resource "aci_filter" "Filter_Allow_ICMP" {
#  tenant_dn = aci_tenant.Tenant_TF.id
#  name      = var.aci_filter_allow_icmp
#}
#
#resource "aci_filter_entry" "Filter_Entry_HTTPS" {
#  name        = var.aci_filter_entry_https
#  filter_dn   = aci_filter.Filter_Allow_HTTPS.id
#  ether_t     = "ip"
#  prot        = "tcp"
#  d_from_port = "https"
#  d_to_port   = "https"
#  stateful    = "yes"
#}
#
#resource "aci_filter_entry" "Filter_Entry_ICMP" {
#  name      = var.aci_filter_entry_icmp
#  filter_dn = aci_filter.Filter_Allow_ICMP.id
#  ether_t   = "ip"
#  prot      = "icmp"
#  stateful  = "yes"
#}
#
