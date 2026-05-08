locals {
  log_configuration_secret_options = var.log_configuration != null ? lookup(var.log_configuration, "secretOptions", null) : null
  log_configuration_with_null = var.log_configuration == null ? null : {
    logDriver = tostring(lookup(var.log_configuration, "logDriver"))
    options   = tomap(lookup(var.log_configuration, "options"))
    secretOptions = local.log_configuration_secret_options == null ? null : [
      for secret_option in tolist(local.log_configuration_secret_options) : {
        name      = tostring(lookup(secret_option, "name"))
        valueFrom = tostring(lookup(secret_option, "valueFrom"))
      }
    ]
  }
  log_configuration_without_null = local.log_configuration_with_null == null ? null : {
    for k, v in local.log_configuration_with_null :
    k => v
    if v != null
  }

  container_definition = {
    name                   = var.container_name
    image                  = var.container_image
    essential              = var.essential
    readonlyRootFilesystem = false
    portMappings           = var.port_mappings
    memory                 = var.container_memory
    memoryReservation      = var.container_memory_reservation
    cpu                    = var.container_cpu
    logConfiguration       = local.log_configuration_without_null
  }

  container_definition_without_null = {
    for k, v in local.container_definition :
    k => v
    if v != null
  }
  json_map = local.container_definition_without_null
}
