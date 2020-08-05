resource "azurerm_virtual_network" "deploy" {
 name                = "deploy-vnet"
 address_space       = ["10.0.0.0/16"]
 location            = var.Location
 resource_group_name = azurerm_resource_group.deploy.name
}

resource "azurerm_subnet" "prod" {
 name                 = "prod-subnet"
 resource_group_name  = azurerm_resource_group.deploy.name
 virtual_network_name = azurerm_virtual_network.deploy.name
 address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "db" {
 name                 = "db-subnet"
 resource_group_name  = azurerm_resource_group.deploy.name
 virtual_network_name = azurerm_virtual_network.deploy.name
 address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "db_nic" {
 name     =  "db_nic"
 location = var.Location
 resource_group_name = azurerm_resource_group.deploy.name
 
 ip_configuration {
       name = "db_ip"
       subnet_id = azurerm_subnet.db.id
       private_ip_address_allocation = "Static"
       private_ip_address = "10.0.2.10"

  } 
}


resource "azurerm_public_ip" "pib" {
 name                         = "public_ip_lb"
 location                     = var.Location
 resource_group_name          = azurerm_resource_group.deploy.name
 allocation_method            = "Static"
}


resource "azurerm_network_security_group" "deploy_nsg" {
  name                = "App_nsg"
  location            = var.Location
  resource_group_name = azurerm_resource_group.deploy.name

  security_rule {
    name                       = "http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    destination_port_range     = "80"
    }


  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db_nsg"
  location            = var.Location
  resource_group_name = azurerm_resource_group.deploy.name

  security_rule {
    name                       = "mysql"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
    destination_port_range     = "3301"
    }


  tags = {
    environment = "DB"
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.prod.id
  network_security_group_id = azurerm_network_security_group.deploy_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
