variable "machine_type" {
  description = "Instance type."
  type        = string
  #default     = "e2-medium"
}
variable "name" {
  description = "Instance name."
  type        = string
  #default = "test-2"
}
variable "zone" {
  description = "Compute zone."
  type        = string
  #default = "us-east1-b"
}
variable "options" {
  description = "Instance options."
  type = object({
    allow_stopping_for_update = bool
    deletion_protection       = bool
  })
}
variable "can_ip_forward" {
  description = "Enable IP forwarding."
  type        = bool
  #default     = false
}
variable "description" {
  description = "Description of a Compute Instance."
  type        = string
}
variable "desired_status" {
  description = "Give Desired State of the machine"
  type = string
}
variable "hostname" {
  description = "Instance FQDN name."
  type        = string
}
variable "labels" {
  description = "Instance labels."
  type        = map(string)
}
variable "metadata" {
  description = "Instance metadata."
  type        = map(string)
}
variable "min_cpu_platform" {
  description = "Minimum CPU platform."
  type        = string
}
variable "project_id" {
  description = "Project id."
  type        = string
  #default     = "pavan-457011"
}
variable "tags" {
  description = "Instance network tags for firewall rule targets."
  type        = list(string)
}
variable "enable_display" {
  description = "Enable virtual display on the instances."
  type        = bool
}
variable "resource_policies" {
  description = ""
  type = list(string)
}
variable "key_revocation_action_type" {
  description = ""
  type = string
}
variable "boot_disk" {
  description = "Boot disk properties."
  type = object({
    auto_delete                     = bool
    device_name                     = string
    mode                            = string
    disk_encryption_key_raw         = string
    kms_key_self_link               = string
    source                          = string
    initialize_params               = object({
      image                         = string
      size                          = number  
      type                          = string
      labels                        = map(string)
      resource_manager_tags         = map(string)
      resource_policies             = list(string)
      provisioned_iops              = number
      provisioned_throughput        = number
      enable_confidential_compute   = bool
      storage_pool                  = string
    })
  })
}
variable "network_interface" {
  description = "Network interfaces configuration. Use self links for Shared VPC, set addresses to null if not needed."
  type = list(object({
    network                             = string
    subnetwork                          = string
    subnetwork_project                  = string
    network_ip                          = string
    nic_type                            = string
    stack_type                          = string
    queue_count                         = number
    access_config = object({
      nat_ip                            = string
      public_ptr_domain_name            = string
      network_tier                      = string 
    })
    alias_ip_range   = map(string)
    ipv6_access_config  = object({
      external_ipv6                     = string
      external_ipv6_prefix_length       = string
      name                              = string
      network_tier                      = string
      public_ptr_domain_name            = string 
    })
  }))
}
variable "attached_disk" {
  description = "value"
  type = list(object({
    source                    = string
    device_name               = string
    mode                      = string
    disk_encryption_key_raw   = string
    kms_key_self_link         = string 
  }))
}
variable "guest_accelerator" {
  description = "value"
  type        = list(object({
    type              = string
    count             = number 
  }))
}
variable "params" {
  description = "value"
  type = list(object({
    resource_manager_tags = map(string)
  }))
}
variable "scratch_disk" {
  description = "value"
  type = object({
    interface = string
    count     = number
  })
}
variable "service_account" {
  description = "Service account email and scopes. If email is null, the default Compute service account will be used unless auto_create is true, in which case a service account will be created. Set the variable to null to avoid attaching a service account."
  type = object({
    email       = string
    scopes      = list(string)
  })
}
variable "shielded_config" {
  description = "Shielded VM configuration of the instances."
  type = object({
    enable_secure_boot          = bool
    enable_vtpm                 = bool
    enable_integrity_monitoring = bool
  })
}
variable "confidential_instance_config" {
  description = "Enable Confidential Compute for these instances."
  type        = list(object({
    enable_confidential_compute  = bool
    confidential_instance_type    = string 
  }))
}
variable "advanced_machine_features" {
  description = "OPTIONAL"
  type              = list(object({
    enable_nested_virtualization  = bool
    threads_per_core              = number
    turbo_mode                    = string
    visible_core_count            = number
    performance_monitoring_unit   = string
    enable_uefi_networking        = bool
  }))
}
variable "reservation_affinity" {
  description = "OPTIONAL"
  type = list(object({
    type = string
    specific_reservation  = list(object({
      key                 = string
      values              = list(string)
    })) 
  }))
  default = [ {
    type = "SPECIFIC_RESERVATION"
    specific_reservation = [ {
      key           = "hey"
      values        = ["hi"]
    } ]
  } ]
}
variable "scheduling" {
  description = ""
  type = object({
    preemptible                             = bool
    on_host_maintenance                     = string
    automatic_restart                       = bool
    min_node_cpus                           = number
    provisioning_model                      = string
    instance_termination_action             = string 
    node_affinities                         = optional(map(object({
      in = optional(bool, true)
      values = list(string) 
    })), {})
    max_run_duration    = object({
      nanos             = number
      seconds           = number 
    })
    on_instance_stop_action = object({
      discard_local_ssd         = bool
    })
    local_ssd_recovery_timeout  = object({
      nanos                     = number
      seconds                   = number 
    })
  })
}


