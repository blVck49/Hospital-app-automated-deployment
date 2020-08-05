resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmss"
  location            = var.Location
  resource_group_name = azurerm_resource_group.deploy.name
 
  upgrade_policy_mode = "Manual"  
 
  sku {
    name     = "Standard_B1ls"
    capacity = 2
  }

  os_profile {
    computer_name_prefix = "prod-scale-instace"
    admin_username       = var.username
    admin_password       = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  storage_profile_image_reference {
     id = "${data.azurerm_image.Linux_web.id}"
  } 
  
  storage_profile_os_disk {
     name = ""
     managed_disk_type = "Standard_LRS"
     caching = "ReadWrite"
     create_option = "FromImage"
   } 
  network_profile {
    name    = "vmss_net"
    primary = true

    ip_configuration {
      name      = "vmss_ip"
      primary   = true
      subnet_id = azurerm_subnet.prod.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lbbackend.id]
    }

   }

}  






#Auto-Scaling Rule for VMs
resource "azurerm_monitor_autoscale_setting" "scale_rule" {
  name                = "DeployAutoscaleSetting"
  resource_group_name = azurerm_resource_group.deploy.name
  location            = var.Location
  target_resource_id  = azurerm_virtual_machine_scale_set.vmss.id
  
  #Time is in ISO 8601 format
  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = [var.admin_mail]
    }
  }
}
