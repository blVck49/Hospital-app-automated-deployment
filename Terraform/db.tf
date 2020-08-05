resource "azurerm_virtual_machine" "db" {
  name                  = "db"
  location              = var.Location
  resource_group_name   = azurerm_resource_group.deploy.name
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  vm_size               = "Standard_DS1_v2"


  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.Linux_db.id}"
  }
  storage_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    name              = "db_os_disk"
  }
  os_profile {
    computer_name  = "DB"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Role = "Database"
  }
}
