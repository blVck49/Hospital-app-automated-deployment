# Create Resource Group containing the application resources
resource "azurerm_resource_group" "deploy" {
 name     = "rg-deployment"
 location = var.Location
}

# Create Load Balancer
resource "azurerm_lb" "deploylb" {
 name                = "prod-loadBalancer"
 location            = var.Location
 resource_group_name = azurerm_resource_group.deploy.name

 frontend_ip_configuration {
   name                 = "publicIP"
   public_ip_address_id = azurerm_public_ip.pib.id
 }
}

# Create LB Backend address pool
resource "azurerm_lb_backend_address_pool" "lbbackend" {
 resource_group_name = azurerm_resource_group.deploy.name
 loadbalancer_id     = azurerm_lb.deploylb.id
 name                = "BackEndAddressPool"
}

# Create LB Rules
resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = azurerm_resource_group.deploy.name
  loadbalancer_id                = azurerm_lb.deploylb.id
  name                           = "lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "publicIP"
  probe_id                       = azurerm_lb_probe.http.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbbackend.id
}

resource "azurerm_lb_probe" "http" {
  resource_group_name = azurerm_resource_group.deploy.name
  loadbalancer_id     = azurerm_lb.deploylb.id
  name                = "http-probe"
  port                = 80
}

