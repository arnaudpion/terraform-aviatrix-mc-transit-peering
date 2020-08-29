locals {

  #Create all peerings based on list of all gateways
  peerings = flatten([
    for gw in var.transit_gateways : [
      for peer_gw in slice(var.transit_gateways, index(var.transit_gateways, gw) + 1, length(var.transit_gateways)) : {
        gw1 = gw
        gw2 = peer_gw
      }
    ]
  ])

  #Create map for consumption in for_each.
  peerings_map = {
    for peering in local.peerings : "${peering.gw1}:${peering.gw2}" => peering
  }

}

resource "aviatrix_transit_gateway_peering" "peering" {
  for_each              = local.peerings_map
  transit_gateway_name1 = each.value.gw1
  transit_gateway_name2 = each.value.gw2
}