# local variables
locals {
  virtual_machine_name_1 = "prod-kafka-confluent-1"
  virtual_machine_name_2 = "prod-kafka-confluent-2"
  virtual_machine_name_3 = "prod-kafka-confluent-3"
  admin_username         = "luanmoreno"
  admin_password         = "Q1w2e3r4!"
}

############
# public ip
############

# public ip = 1
resource "azurerm_public_ip" "pi_1" {
  name                = "${var.prefix}-ip-1"
  domain_name_label   = "${local.virtual_machine_name_1}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Dynamic"
}

# public ip = 2
resource "azurerm_public_ip" "pi_2" {
  name                = "${var.prefix}-ip-2"
  domain_name_label   = "${local.virtual_machine_name_2}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Dynamic"
}

# public ip = 3
resource "azurerm_public_ip" "pi_3" {
  name                = "${var.prefix}-ip-3"
  domain_name_label   = "${local.virtual_machine_name_3}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Dynamic"
}

####################
# network interface
####################

# network interface = 1
resource "azurerm_network_interface" "ni_1" {
  name                      = "${azurerm_resource_group.rg.name}-nic-1"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  # network_security_group_id = "${azurerm_network_security_group.sg1.id}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.sb.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pi_1.id}"
  }
}

# network interface = 2
resource "azurerm_network_interface" "ni_2" {
  name                      = "${azurerm_resource_group.rg.name}-nic-2"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  # network_security_group_id = "${azurerm_network_security_group.sg2.id}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.sb.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pi_2.id}"
  }
}

# network interface = 3
resource "azurerm_network_interface" "ni_3" {
  name                      = "${azurerm_resource_group.rg.name}-nic-3"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  # network_security_group_id = "${azurerm_network_security_group.sg3.id}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.sb.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pi_3.id}"
  }
}

###################
# virtual machines
# count = 3
###################

# VM1
resource "azurerm_virtual_machine" "vm_1" {
  name                  = "${local.virtual_machine_name_1}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ni_1.id}"]
  vm_size               = "Standard_DS3_v2"

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

# VM2
resource "azurerm_virtual_machine" "vm_2" {
  name                  = "${local.virtual_machine_name_2}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ni_2.id}"]
  vm_size               = "Standard_DS3_v2"

  storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
  }

  storage_os_disk {
    name              = "${local.virtual_machine_name_2}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name_2}"
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

# VM3
resource "azurerm_virtual_machine" "vm_3" {
  name                  = "${local.virtual_machine_name_3}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ni_3.id}"]
  vm_size               = "Standard_DS3_v2"

  storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
  }

  storage_os_disk {
    name              = "${local.virtual_machine_name_3}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name_3}"
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
