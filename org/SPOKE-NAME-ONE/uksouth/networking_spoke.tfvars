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
        master1                                            = {
            name                                           = "master1"
            cidr                                           = "10.2.32.0/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        master2                                            = {
            name                                           = "master2"
            cidr                                           = "10.2.32.12/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        master3                                            = {
            name                                           = "master3"
            cidr                                           = "10.2.32.13/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        master4                                            = {
            name                                           = "master4"
            cidr                                           = "10.2.32.14/27"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = ["Microsoft.EventHub"]
        }
        master5                                            = {
            name                                           = "master5"
            cidr                                           = "10.2.32.15/25"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = null
            service_endpoints                              = []
        }
        master6                                            = {
            name                                           = "master6"
            cidr                                           = "10.2.111.0/24"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = ["Microsoft.Storage"]
        }
        slave1                                             = {
            name                                           = "slave1"
            cidr                                           = "10.2.22.0/24"
            enforce_private_link_endpoint_network_policies = false
            enforce_private_link_service_network_policies  = false
            nsg_creation                                   = true
            nsg_inbound                                    = []
            nsg_outbound                                   = []
            route                                          = "asdf"
            service_endpoints                              = []
        }
        slave2                                             = {
            name                                           = "slave2"
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
