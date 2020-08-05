provider "azurerm" {
  version = "=1.44.0"
  client_id = var.Client_id
  client_secret = var.Client_secret
  tenant_id       = var.Tenant_id
  subscription_id = var.subscription_id
}
