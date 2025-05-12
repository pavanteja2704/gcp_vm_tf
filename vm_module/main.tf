resource "google_compute_instance" "default" {
  machine_type                                                = var.machine_type
  name                                                        = var.name
  zone                                                        = var.zone
  allow_stopping_for_update                                   = var.options.allow_stopping_for_update
  can_ip_forward                                              = var.can_ip_forward
  description                                                 = var.description
  desired_status                                              = var.desired_status
  deletion_protection                                         = var.options.deletion_protection
  hostname                                                    = var.hostname
  labels                                                      = var.labels
  metadata                                                    = var.metadata   
  min_cpu_platform                                            = var.min_cpu_platform
  project                                                     = var.project_id
  tags                                                        = var.tags
  enable_display                                              = var.enable_display
  resource_policies                                           = var.resource_policies
  key_revocation_action_type                                  = var.key_revocation_action_type 

  boot_disk {
    auto_delete                                               = var.boot_disk.auto_delete
    device_name                                               = var.boot_disk.device_name
    mode                                                      = var.boot_disk.mode 
    disk_encryption_key_raw                                   = var.boot_disk.disk_encryption_key_raw
    kms_key_self_link                                         = var.boot_disk.kms_key_self_link
    source                                                    = var.boot_disk.source
    initialize_params {                                        
        image                                                 = var.boot_disk.initialize_params.image
        size                                                  = var.boot_disk.initialize_params.size
        type                                                  = var.boot_disk.initialize_params.type
        labels                                                = var.boot_disk.initialize_params.labels 
        resource_manager_tags                                 = var.boot_disk.initialize_params.resource_manager_tags
        resource_policies                                     = var.boot_disk.initialize_params.resource_policies
        provisioned_iops                                      = var.boot_disk.initialize_params.provisioned_iops
        provisioned_throughput                                = var.boot_disk.initialize_params.provisioned_throughput
        enable_confidential_compute                           = var.boot_disk.initialize_params.enable_confidential_compute
        storage_pool                                          = var.boot_disk.initialize_params.storage_pool
    }
  }
  dynamic "network_interface" {
    for_each = var.network_interface[*]
    content {
      network                                                 = network_interface.value.network
      subnetwork                                              = network_interface.value.subnetwork
      subnetwork_project                                      = network_interface.value.subnetwork_project
      network_ip                                              = network_interface.value.network_ip
      nic_type                                                = network_interface.value.nic_type
      stack_type                                              = network_interface.value.stack_type
      queue_count                                             = network_interface.value.queue_count 
      access_config {
          nat_ip                                              = network_interface.value.access_config.nat_ip
          public_ptr_domain_name                              = network_interface.value.access_config.public_ptr_domain_name
          network_tier                                        = network_interface.value.access_config.network_tier
      }
      dynamic "alias_ip_range" {
        for_each = network_interface.value.alias_ip_range
        iterator = config_alias
        content {
          subnetwork_range_name = config_alias.key
          ip_cidr_range         = config_alias.value
        }
      }
     /*  ipv6_access_config {
          external_ipv6                                       = var.network_interface.ipv6_access_config.external_ipv6
          external_ipv6_prefix_length                         = var.network_interface.ipv6_access_config.external_ipv6
          name                                                = var.network_interface.ipv6_access_config.name
          network_tier                                        = var.network_interface.ipv6_access_config.network_tier
          public_ptr_domain_name                              = var.network_interface.ipv6_access_config.public_ptr_domain_name
      } */
    } 
  }
  dynamic "attached_disk" {
    for_each                                                  = var.attached_disk[*]
    content{
        source                                                = lookup(attached_disk.value, "source")
        device_name                                           = lookup(attached_disk.value, "device_name")
        mode                                                  = lookup(attached_disk.value, "mode")
        disk_encryption_key_raw                               = lookup(attached_disk.value, "disk_encryption_key_raw")
        kms_key_self_link                                     = lookup(attached_disk.value, "kms_key_self_link")
    }
  }
  dynamic "guest_accelerator" {
    for_each = var.guest_accelerator[*]
    content {
      type  = guest_accelerator.value.type
      count = guest_accelerator.value.count
    }
  }
  dynamic "params" {
    for_each = var.params[*]
    content {
      resource_manager_tags = lookup(params.value, "resource_manager_tags")
    }
  }
  # scheduling {
  #   preemptible                 = var.scheduling.preemptible
  #   on_host_maintenance         = var.scheduling.on_host_maintenance
  #   automatic_restart           = var.scheduling.automatic_restart
  #   min_node_cpus               = var.scheduling.min_node_cpus
  #   provisioning_model          = var.scheduling.provisioning_model 
  #   instance_termination_action = var.scheduling.instance_termination_action
  #   dynamic "node_affinities" {
  #     for_each = var.scheduling.node_affinities
  #     iterator = affinity
  #     content {
  #       key      = affinity.key
  #       operator = affinity.value.in ? "IN" : "NOT_IN"
  #       values   = affinity.value.values
  #     }
  #   }
  #   max_run_duration {
  #       nanos   =  var.scheduling.max_run_duration.nanos
  #       seconds =  var.scheduling.max_run_duration.seconds
  #   }
  #   on_instance_stop_action {
  #       discard_local_ssd         = var.scheduling.on_instance_stop_action.discard_local_ssd  
  #   }
  #   local_ssd_recovery_timeout {
  #       nanos   = var.scheduling.local_ssd_recovery_timeout.nanos
  #       seconds = var.scheduling.local_ssd_recovery_timeout.seconds
  #   }
  # }
  dynamic "scratch_disk" {
    for_each = [
      for i in range(0, var.scratch_disk.count) : var.scratch_disk.interface
    ]
    iterator = config
    content {
      interface = config.value
    }
  }
  dynamic "service_account" {
    for_each = var.service_account[*]
    content {
      email  = lookup(service_account.value, "email")
      scopes = lookup(service_account.value, "scopes")
    }
  }
  dynamic "shielded_instance_config" {
    for_each = var.shielded_config != null ? [var.shielded_config] : []
    iterator = config
    content {
      enable_secure_boot          = config.value.enable_secure_boot
      enable_vtpm                 = config.value.enable_vtpm
      enable_integrity_monitoring = config.value.enable_integrity_monitoring
    }
  }
  dynamic "confidential_instance_config" {
    for_each = var.confidential_instance_config[*]
    content {
      enable_confidential_compute = lookup(confidential_instance_config.value, "enable_confidential_compute")
      confidential_instance_type = lookup(confidential_instance_config.value, "confidential_instance_type")
    }
  }
  dynamic "advanced_machine_features" {
    for_each = var.advanced_machine_features[*]
    content {
      enable_nested_virtualization            = lookup(advanced_machine_features.value, "enable_nested_virtualization")
      threads_per_core                        = lookup(advanced_machine_features.value, "threads_per_core")
      turbo_mode                              = lookup(advanced_machine_features.value, "turbo_mode")
      visible_core_count                      = lookup(advanced_machine_features.value, "visible_core_count")
      performance_monitoring_unit             = lookup(advanced_machine_features.value, "performance_monitoring_unit")
      enable_uefi_networking                  = lookup(advanced_machine_features.value, "enable_uefi_networking")   
    }   
  }
  /* dynamic "reservation_affinity" {
    for_each = var.reservation_affinity[*]
    content {
      type                        = lookup(reservation_affinity.value, "type")
      dynamic "specific_reservation" {
        for_each                  = lookup(reservation_affinity.value, "specific_reservation")
        content {
          key                     = lookup(specific_reservation.value, "key")
          values                  = lookup(specific_reservation.value, "values")  
        } 
      } 
    } 
  } */
}


