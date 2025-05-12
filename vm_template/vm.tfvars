vm = {
  "tfteam-testvm-01" = {
    delete          = false
    description     = "Testing VM for Tf team"
    zone            = "us-east1-b"
    project_id      = "pavan-457011"
    machine_type    = "e2-medium"
    options = {
      allow_stopping_for_update   = true
      deletion_protection         = false
    }
    can_ip_forward  = false
    desired_status  = "RUNNING"
    hostname        = null
    labels          = {}

    metadata        = {}

    min_cpu_platform = null
    tags            = []
    enable_display  = false
    resource_policies = []
    key_revocation_action_type = ""

    boot_disk = {
      auto_delete         = true
      device_name         = "boot-disk"
      mode                = "READ_WRITE"
      disk_encryption_key_raw = null
      kms_key_self_link       = null
      source              = ""
      initialize_params = {
        image             = "projects/debian-cloud/global/images/family/debian-11"
        size              = 50
        type              = "pd-standard"
        labels            = {}
        resource_manager_tags = {}
        resource_policies = []
        provisioned_iops  = null
        provisioned_throughput = null
        enable_confidential_compute = false
        storage_pool      = null
      }
    }

    network_interface = [{
      network           = "default"
      subnetwork        = "default"
      subnetwork_project = "pavan-457011"
      network_ip        = null
      nic_type          = null
      stack_type        = "IPV4_ONLY"
      queue_count       = 0
      access_config = {
        nat_ip          = null
        network_tier    = "STANDARD"
        public_ptr_domain_name = null
      }
      alias_ip_range = {}
      ipv6_access_config = {
        external_ipv6   = null
        external_ipv6_prefix_length = null
        name            = null
        network_tier    = null
        public_ptr_domain_name = null
      }
    }]

    attached_disk = []

    guest_accelerator = []

    params = [{
      resource_manager_tags = {}
    }]

    scratch_disk = {
      interface = null
      count     = 0
    }

    service_account = {
      email  = "default"
      scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_config = {
      enable_secure_boot          = true
      enable_vtpm                 = true
      enable_integrity_monitoring = true
    }

    confidential_instance_config = [{
      enable_confidential_compute = false
      confidential_instance_type  = ""
    }]

    advanced_machine_features = [{
      enable_nested_virtualization = false
      threads_per_core             = 1
      turbo_mode                   = null
      visible_core_count           = null
      performance_monitoring_unit = null
      enable_uefi_networking       = false
    }]

    scheduling = {
      automatic_restart           = true
      instance_termination_action = "STOP"
      local_ssd_recovery_timeout = {
        nanos   = 0
        seconds = 0
      }
      max_run_duration = {
        nanos   = 0
        seconds = 600  # <-- Set to 10 minutes (valid range)
      }
      min_node_cpus               = null
      on_host_maintenance         = "MIGRATE"
      on_instance_stop_action = {
        discard_local_ssd         = false
      }
      preemptible                 = false
      provisioning_model          = "STANDARD"
    }
  }
}
