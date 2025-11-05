locals {
  private_endpoint_name = "PEP-EUR-FR-${var.environment}-${upper(var.name)}"


  subnets_to_authorize_in_mysql = data.azurerm_subnet.subnets_to_authorize != null ? {
    for key, subnet in data.azurerm_subnet.subnets_to_authorize :
    "${subnet.name}" => {
      start_ip_address = cidrhost(subnet.address_prefix, 0)
      end_ip_address   = cidrhost(subnet.address_prefix, -1)
    }
  } : null


  firewall_rules = merge(
    local.subnets_to_authorize_in_mysql,
    var.firewall_rules
  )
}

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.db_version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  public_network_access  = var.public_network_access_enabled == false ? "Disabled" : "Enabled"
  delegated_subnet_id    = var.public_network_access_enabled == false ? var.delegated_subnet_id : null
  private_dns_zone_id    = var.public_network_access_enabled == false ? var.private_dns_zone_id : null

  zone                  = var.zone
  backup_retention_days = 7
  sku_name              = var.sku_name

  storage {
    auto_grow_enabled = var.auto_grow_enabled
    iops              = 360
    size_gb           = var.storage_gb
  }

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? toset([1]) : toset([])
    content {
      type         = var.identity_type
      identity_ids = [var.user_assigned_identity_id]
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_mysql_flexible_server_active_directory_administrator" "mysql_entraid_admin" {
  count       = var.enable_entra_id_authentication == true ? 1 : 0
  identity_id = var.user_assigned_identity_id
  object_id   = var.entra_id_admin_object_id
  login       = var.entra_id_admin_user_principal_name
  server_id   = azurerm_mysql_flexible_server.mysql_flexible_server.id
  tenant_id   = var.tenant_id
}
resource "azurerm_mysql_flexible_database" "mysql_flexible_server_databases" {
  for_each            = var.databases
  name                = each.value.name
  server_name         = var.name
  resource_group_name = var.resource_group_name
  charset             = each.value.charset
  collation           = each.value.collation
  depends_on          = [azurerm_mysql_flexible_server.mysql_flexible_server]
}

resource "azurerm_mysql_flexible_server_firewall_rule" "firewall_rule" {
  for_each            = local.firewall_rules != {} && var.public_network_access_enabled == true ? local.firewall_rules : {}
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}

module "MySQL_private_endpoint" {
  count                               = var.public_network_access_enabled == false || (local.subnets_to_authorize_in_mysql != {} && var.public_network_access_enabled == true) ? 1 : 0
  source                              = "../azure_private_endpoint"
  private_endpoint_name               = local.private_endpoint_name
  subnet_name                         = var.private_endpoint_subnet_name
  virtual_network_name                = var.private_endpoint_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  resource_group_name                 = var.resource_group_name
  private_connection_resource_id      = azurerm_mysql_flexible_server.mysql_flexible_server.id
  subresourceType                     = "mysqlServer"
}

resource "azurerm_key_vault_secret" "mysql_admin_password" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-Admin-Password"
  value        = var.administrator_password
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_admin_login" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-Admin-login"
  value        = var.administrator_login
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_fqdn" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-fqdn"
  value        = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_database" {
  for_each     = var.databases != {} && var.register_mysqlinfos_to_key_vault == true ? var.databases : {}
  name         = replace("MySQL-database-${each.value.name}", "_", "-")
  value        = each.value.name
  key_vault_id = var.key_vault_id
}