module "vm" {
  for_each = {
    for k, v in try(var.vm,{}): k=> v if v.delete != true
  }
  source                                = "/home/yellaboyinapavanteja/vm/vm_module" 
  name                                  = each.key
  description                           = each.value.description
  zone                                  = each.value.zone
  project_id                            = each.value.project_id
  machine_type                          = each.value.machine_type
  options                               = each.value.options
  can_ip_forward                        = each.value.can_ip_forward
  desired_status                        = each.value.desired_status
  hostname                              = each.value.hostname
  labels                                = each.value.labels
  metadata                              = each.value.metadata
  min_cpu_platform                      = each.value.min_cpu_platform
  tags                                  = each.value.tags
  enable_display                        = each.value.enable_display
  resource_policies                     = each.value.resource_policies
  key_revocation_action_type            = each.value.key_revocation_action_type
  boot_disk                             = each.value.boot_disk
  network_interface                     = each.value.network_interface
  attached_disk                         = each.value.attached_disk
  guest_accelerator                     = each.value.guest_accelerator
  params                                = each.value.params
  scratch_disk                          = each.value.scratch_disk
  service_account                       = each.value.service_account
  shielded_config                       = each.value.shielded_config
  confidential_instance_config          = each.value.confidential_instance_config
  advanced_machine_features             = each.value.advanced_machine_features
  scheduling                            = each.value.scheduling
}