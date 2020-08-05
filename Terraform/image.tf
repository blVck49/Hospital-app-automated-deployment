data "azurerm_resource_group" "Images" {
name = "Images"
}


data "azurerm_image" "Linux_web" {
name = "Linux-web"
resource_group_name = "Images"
}



data "azurerm_image" "Linux_db" {
name = "Linux-db"
resource_group_name = "Images"
}


