vnet_transit_object                                        = {
    vnet                                                   = {
        name                                               = "transit"
        address_space                                      = ["10.0.0.0/21"]
        dns                                                = ["10.0.0.11", "10.0.0.12"]
        enable_ddos_std                                    = false
        ddos_id                                            = "placeholder"
    }
    specialsubnets                                         = {
        AzureFirewallSubnet                                = {
            name                                           = "AzureFirewallSubnet"
            cidr                                           = "10.0.0.0/26"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            route                                          = "asdf"
            service_endpoints                              = []
        }
        GatewaySubnet                                      = {
            name                                           = "GatewaySubnet"
            cidr                                           = "10.0.0.11/26"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            route                                          = "asdf"
            service_endpoints                              = []
        }
    }
    subnets                                                = {
        qwer1                                              = {
            name                                           = "qwer1"
            cidr                                           = "10.0.0.12/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwer2                                              = {
            name                                           = "qwer2"
            cidr                                           = "10.0.0.13/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwer3                                              = {
            name                                           = "qwer3"
            cidr                                           = "10.0.0.14/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "fw_mgmt"
            service_endpoints                              = ["Microsoft.Storage"]
        }
        qwer4                                              = {
            name                                           = "qwer4"
            cidr                                           = "10.0.0.15/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwer5                                              = {
            name                                           = "qwer5"
            cidr                                           = "10.0.0.16/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
    }
}

vnet_shared_services_object                                = {
    vnet                                                   = {
        name                                               = "shared-services"
        address_space                                      = ["10.0.111.0/21"]
        dns                                                = ["10.0.0.132", "10.0.0.133"]
        enable_ddos_std                                    = false
        ddos_id                                            = "placeholder"
    }
    specialsubnets                                         = {}
    subnets                                                = {
        qwer6                                              = {
            name                                           = "qwer6"
            cidr                                           = "10.0.111.12/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwer7                                              = {
            name                                           = "qwer7"
            cidr                                           = "10.0.111.13/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            delegation                                     = {
                name                                       = "delegation"
                service_delegation                         = {
                    name                                   = "Microsoft.Web/serverFarms"
                    actions                                = ["Microsoft.Network/virtualNetworks/subnets/action"]
                }
            }
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwer8                                              = {
            name                                           = "qwer8"
            cidr                                           = "10.0.111.14/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = ["Microsoft.Sql"]
        }
        qwer9                                              = {
            name                                           = "qwer9"
            cidr                                           = "10.0.111.15/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        zxcv1                                              = {
            name                                           = "zxcv1"
            cidr                                           = "10.0.111.16/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "egress_azfw"
            service_endpoints                              = []
        }
        zxcv2                                              = {
            name                                           = "zxcv2"
            cidr                                           = "10.0.111.17/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "shared_services"
            service_endpoints                              = ["Microsoft.EventHub"]
        }
        zxcv3                                              = {
            name                                           = "zxcv3"
            cidr                                           = "10.0.111.18/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "shared_services"
            service_endpoints                              = ["Microsoft.EventHub"]
        }
    }
}


route_tables                                               = {
    asdf                                                   = {
        name                                               = "asdf"
        disable_bgp_route_propagation                      = false
        resource_group_name                                = "transit"
        route_entries                                      = {
            rt-default                                     = {
                name                                       = "rt-default"
                prefix                                     = "0.0.0.0/0"
                next_hop_type                              = "Internet"
            }
            rt-asdf1                                       = {
                name                                       = "rt-asdf1"
                prefix                                     = "10.152.0.0/16"
                next_hop_type                              = "VirtualAppliance"
                next_hop_in_ip_address                     = "10.0.0.1"
            }
            rt-asdf2                                       = {
                name                                       = "rt-asdf2"
                prefix                                     = "10.152.246.0/24"
                next_hop_type                              = "VirtualAppliance"
                next_hop_in_ip_address                     = "10.0.0.1"
            }
        }
    }
}