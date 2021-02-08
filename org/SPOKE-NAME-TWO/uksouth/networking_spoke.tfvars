vnet_spoke_object                                          = {
    vnet                                                   = {
        name                                               = "spoke1"
        address_space                                      = ["10.2.32.0/22"]
        dns                                                = ["10.2.240.132", "10.2.240.133"]
        enable_ddos_std                                    = false
        ddos_id                                            = "placeholder"
    }
    specialsubnets                                         = {}
    subnets                                                = {
        qwerty1                                            = {
            name                                           = "qwerty1"
            cidr                                           = "10.2.32.0/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwerty2                                            = {
            name                                           = "qwerty2"
            cidr                                           = "10.2.32.12/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwerty3                                            = {
            name                                           = "qwerty3"
            cidr                                           = "10.2.32.13/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        qwerty4                                            = {
            name                                           = "qwerty4"
            cidr                                           = "10.2.32.14/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = ["Microsoft.EventHub"]
        }
        qwerty5                                            = {
            name                                           = "qwerty5"
            cidr                                           = "10.2.32.15/25"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = null
            service_endpoints                              = []
        }
        qwerty6                                            = {
            name                                           = "qwerty6"
            cidr                                           = "10.2.111.0/24"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = ["Microsoft.Storage"]
        }
        poiu1                                              = {
            name                                           = "poiu1"
            cidr                                           = "10.2.22.0/24"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        poiu2                                              = {
            name                                           = "poiu2"
            cidr                                           = "10.2.23.0/24"
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

route_tables                                               = {
    asdf                                                   = {
        name                                               = "asdf"
        disable_bgp_route_propagation                      = true
        resource_group_name                                = "vnet-spoke"
        route_entries                                      = {
            re1                                            = {
                name                                       = "rt-rfc-10-8"
                prefix                                     = "10.0.0.0/8"
                next_hop_type                              = "VirtualAppliance"
                next_hop_in_ip_address                     = "10.1.1.1"
            },
            re2                                            = {
                name                                       = "rt-rfc-172-12"
                prefix                                     = "172.16.0.0/12"
                next_hop_type                              = "VirtualAppliance"
                next_hop_in_ip_address                     = "10.1.1.1"
            }
        }
    }
}
