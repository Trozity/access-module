data "azurerm_subscriptions" "all" {}

data "azurerm_management_group" "root-mgmt" {
  display_name = "Tenant Root Group"
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}