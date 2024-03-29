###################
# Create Reader   #
# Access group  #
###################
resource "azuread_group" "root_mgmt_readers" {
  display_name     = "root-mgmt-reader"
  description      = "Gives reader access on management level"
  security_enabled = true
}

resource "azurerm_role_assignment" "mgmt_reader_assignment" {
  scope              = data.azurerm_management_group.root-mgmt.id
  role_definition_id = data.azurerm_role_definition.reader.id
  principal_id       = azuread_group.root_mgmt_readers.object_id
   lifecycle {
    ignore_changes = [
      role_definition_id,
    ]
  }
}



######################
# Create contributor #
# Access groups      #
######################


#Creates AD group that will give contributor access to on management group
resource "azuread_group" "root_mgmt_contributor" {
  count               = var.contributor_groups_enabled ? 1 : 0
  display_name        = "root-mgmt-contributor"
  description         = var.contributor_group_description
  security_enabled    = true
}


resource "azurerm_role_assignment" "mgmt_contributor_assignment" {
  for_each = var.contributor_groups_enabled ? { for index, _ in azuread_group.root_mgmt_contributor : index => true } : {}

  scope              = data.azurerm_management_group.root-mgmt.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_group.root_mgmt_contributor[each.key].object_id

  lifecycle {
    ignore_changes = [
      role_definition_id,
    ]
  }
}





resource "azuread_group" "subscription_contributor" {
  for_each = var.contributor_groups_enabled ? { for sub in data.azurerm_subscriptions.all.subscriptions : sub.id => sub } : {}

  display_name     = "contributor-${replace(each.value.display_name, " ", "-")}"
  description      = var.contributor_group_description
  security_enabled = true
}

resource "azurerm_role_assignment" "subscription_contributor_role" {
  for_each = var.contributor_groups_enabled ? { for sub in data.azurerm_subscriptions.all.subscriptions : sub.id => sub } : {}

  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_group.subscription_contributor[each.key].id
  scope              = each.value.id
  # Add lifecycle since tf forces replacement each run
   lifecycle {
    ignore_changes = [
      role_definition_id,
    ]
  } 
}
