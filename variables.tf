variable "environment" {
  type        = string
  description = "Environnement de déploiement des ressources"
}

variable "name" {
  type        = string
  description = "Nom du serveur MySQL flexible"
}

variable "resource_group_name" {
  type        = string
  description = "Nom du Resource Group"
}

variable "location" {
  type        = string
  description = "Localisation"
  default     = "westeurope"
}

variable "db_version" {
  type        = string
  description = "Version MySQL"
}

variable "administrator_login" {
  type        = string
  description = "Login admin"
  default     = "mysqladmin"
}

variable "administrator_password" {
  type        = string
  description = "Mot de passe admin (ou à récupérer dans KeyVault)"
}

variable "zone" {
  type        = string
  description = "Zone (Ex: '3')"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "SKU MySQL (Ex: GP_Standard_D2ads_v5)"
  default     = "GP_Standard_D2ds_v4"
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Auto grow storage ?"
  default     = false
}

variable "storage_gb" {
  type        = string
  description = "Taille du storage en GB"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "ID de l'UAI"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map de tags"
  default     = {}
}

variable "subnet_ids_to_allow" {
  type        = list(string)
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet !
  DESCRIPTION
  default     = []
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Autoriser l'accès public ?"
  default     = false
}

variable "private_endpoint_subnet_name" {
  type        = string
  description = "Subnet ou sera déployé le private endpoint"
  default     = null
}

variable "private_endpoint_virtual_network_name" {
  type        = string
  description = "VNET ou sera déployé le private endpoint"
  default     = null
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint"
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "Key vault ou sera stocké le secret de MySQL"
  default     = null
}


variable "identity_type" {
  type        = string
  description = "Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées)"
  default     = "SystemAssigned"
}

variable "register_mysqlinfos_to_key_vault" {
  type        = bool
  description = "Définis si les infos du serveur MySQL (mot de passe administrateur, login, url) sont enregistrés dans un key vault ou non"
  default     = false
}

variable "databases" {
  type = map(object({
    name      = string
    charset   = optional(string, "utf8mb4")
    collation = optional(string, "utf8mb4_general_ci")
  }))
  description = "Map de bdd à créer avec le server MySQL"
  default     = {}
}

variable "delegated_subnet_id" {
  type        = string
  description = "The ID of the virtual network subnet to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
  default     = null
}

variable "firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au MySQL Flexible server (non recommandé),
    AJoutez l'objet suivant :
    "Azure_Services" = {
      start_ip_address = 'O.O.O.O/O'
      end_ip_address   = 'O.O.O.O/O'
    }
  DESCRIPTION
  default     = {}
}


variable "tenant_id" {
  type        = string
  description = "Tenant ID variable"
  default     = "f30ac191-b8b4-45f2-9a9b-e5466cb90c2f"
}

variable "enable_entra_id_authentication" {
  type        = bool
  description = "active ou non l'authentiication Entra ID sur le MySQL Flexible server"
  default     = false
}

variable "entra_id_admin_object_id" {
  type        = string
  description = <<DESCRIPTION
    Object ID de lobjet entra ID qui autre les droits admin sur le MySQL server si
    l'authentification entra ID est activée
    Peut être un utilisateur seulement.
  DESCRIPTION
  default     = null
}

variable "entra_id_admin_user_principal_name" {
  type        = string
  description = <<DESCRIPTION
    User Principal Name de lobjet entra ID qui autre les droits admin sur le MySQL server si
    l'authentification entra ID est activée
    Peut être un utilisateur (User Principal Name)
  DESCRIPTION
  default     = null
}