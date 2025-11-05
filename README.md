<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.11 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_MySQL_private_endpoint"></a> [MySQL\_private\_endpoint](#module\_MySQL\_private\_endpoint) | ../azure_private_endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.mysql_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_fqdn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mysql_flexible_database.mysql_flexible_server_databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_active_directory_administrator.mysql_entraid_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_active_directory_administrator) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [azurerm_subnet.subnets_to_authorize](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | Mot de passe admin (ou à récupérer dans KeyVault) | `string` | n/a | yes |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | Version MySQL | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environnement de déploiement des ressources | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Nom du serveur MySQL flexible | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nom du Resource Group | `string` | n/a | yes |
| <a name="input_storage_gb"></a> [storage\_gb](#input\_storage\_gb) | Taille du storage en GB | `string` | n/a | yes |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | Login admin | `string` | `"mysqladmin"` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | Auto grow storage ? | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Map de bdd à créer avec le server MySQL | <pre>map(object({<br/>    name      = string<br/>    charset   = optional(string, "utf8mb4")<br/>    collation = optional(string, "utf8mb4_general_ci")<br/>  }))</pre> | `{}` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | The ID of the virtual network subnet to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_enable_entra_id_authentication"></a> [enable\_entra\_id\_authentication](#input\_enable\_entra\_id\_authentication) | active ou non l'authentiication Entra ID sur le MySQL Flexible server | `bool` | `false` | no |
| <a name="input_entra_id_admin_object_id"></a> [entra\_id\_admin\_object\_id](#input\_entra\_id\_admin\_object\_id) | Object ID de lobjet entra ID qui autre les droits admin sur le MySQL server si<br/>    l'authentification entra ID est activée<br/>    Peut être un utilisateur seulement. | `string` | `null` | no |
| <a name="input_entra_id_admin_user_principal_name"></a> [entra\_id\_admin\_user\_principal\_name](#input\_entra\_id\_admin\_user\_principal\_name) | User Principal Name de lobjet entra ID qui autre les droits admin sur le MySQL server si<br/>    l'authentification entra ID est activée<br/>    Peut être un utilisateur (User Principal Name) | `string` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au MySQL Flexible server (non recommandé),<br/>    AJoutez l'objet suivant :<br/>    "Azure\_Services" = {<br/>      start\_ip\_address = 'O.O.O.O/O'<br/>      end\_ip\_address   = 'O.O.O.O/O'<br/>    } | <pre>map(object({<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées) | `string` | `"SystemAssigned"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Key vault ou sera stocké le secret de MySQL | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Localisation | `string` | `"westeurope"` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | The ID of the private DNS zone to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_name"></a> [private\_endpoint\_subnet\_name](#input\_private\_endpoint\_subnet\_name) | Subnet ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_private_endpoint_virtual_network_name"></a> [private\_endpoint\_virtual\_network\_name](#input\_private\_endpoint\_virtual\_network\_name) | VNET ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Autoriser l'accès public ? | `bool` | `false` | no |
| <a name="input_register_mysqlinfos_to_key_vault"></a> [register\_mysqlinfos\_to\_key\_vault](#input\_register\_mysqlinfos\_to\_key\_vault) | Définis si les infos du serveur MySQL (mot de passe administrateur, login, url) sont enregistrés dans un key vault ou non | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU MySQL (Ex: GP\_Standard\_D2ads\_v5) | `string` | `"GP_Standard_D2ds_v4"` | no |
| <a name="input_subnet_ids_to_allow"></a> [subnet\_ids\_to\_allow](#input\_subnet\_ids\_to\_allow) | Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet ! | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map de tags | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID variable | `string` | `"f30ac191-b8b4-45f2-9a9b-e5466cb90c2f"` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | ID de l'UAI | `string` | `null` | no |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone (Ex: '3') | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_flexible_server_id"></a> [mysql\_flexible\_server\_id](#output\_mysql\_flexible\_server\_id) | ID du serveur MySQL flexible |
<!-- END_TF_DOCS -->