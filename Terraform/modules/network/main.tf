resource "azurerm_virtual_network" "main" {
  name                = "${var.project}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_network_security_group" "aks" {
  name                = "${var.project}-${var.environment}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet" "postgres" {
  name                 = "postgres-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.postgres_subnet_cidr]

  delegation {
    name = "postgres-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "${var.project}-${var.environment}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

}
