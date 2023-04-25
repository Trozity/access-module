/* output "subscription_contributor_groups" {
  value = { for sub_id, group in azuread_group.subscription_contributor : sub_id => group.display_name }
}

output "all_subscriptions_contributor_group" {
  value = azuread_group.all_subscriptions_contributor[0].display_name
}
 */