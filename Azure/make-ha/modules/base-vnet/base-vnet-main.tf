resource "azurerm_resource_group" "base_netrg" {
    location = var.location
    name     = "${var.project["prefix_name"]}-vnet-rg"
    tags     = merge(local.common_tags, {"Name" = "${var.project["prefix_name"]}-vnet-rg"})
}

resource "azurerm_virtual_network" "base_net" {
    address_space       = var.vnet_address_space
    location            = var.location
    name                = "${var.project["prefix_name"]}-vnet"
    resource_group_name = azurerm_resource_group.base_netrg.name
    dns_servers         = [cidrhost(var.vnet_address_space[0], 4), cidrhost(var.vnet_address_space[0], 5)]
    tags                = merge(local.common_tags, {"Name" = "${var.project["prefix_name"]}-vnet"})
}

resource "azurerm_resource_group" "netwatcher" {
  count    = var.netwatcher != null ? 1 : 0
  name     = "NetworkWatcherRG"
  location = var.location
}

resource "azurerm_network_watcher" "netwatcher" {
  count               = var.netwatcher != null ? 1 : 0
  name                = "NetworkWatcher_${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.netwatcher.0.name
}
