# local variables
locals {
  virtual_machine_name_1 = "dev-kafka-confluent"
  admin_username         = "luanmoreno"
  admin_password         = "Q1w2e3r4!"
}

############
# public ip
############

# public ip
resource "azurerm_public_ip" "pi_1" {
  name                = "${var.prefix}-ip"
  domain_name_label   = "${local.virtual_machine_name_1}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Dynamic"
}

####################
# network interface
####################

# network interface
resource "azurerm_network_interface" "ni_1" {
  name                      = "${azurerm_resource_group.rg.name}-nic"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  # azurerm_network_interface_security_group_association = "${azurerm_network_security_group.sg.id}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.sb.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pi_1.id}"
  }
}


###################
# virtual machines
# count = 1
###################

resource "azurerm_virtual_machine" "vm_1" {
  name                  = "${local.virtual_machine_name_1}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ni_1.id}"]
  vm_size               = "Standard_D4S_v3"

  storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
  }

  storage_os_disk {
    name              = "${local.virtual_machine_name_1}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name_1}"
    admin_username = "${local.admin_username}"
    admin_password = "${local.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${local.admin_username}/.ssh/authorized_keys"
      key_data = "${local.public_ssh_key}"
    }
  }
}
