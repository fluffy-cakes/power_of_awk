# Environment VNET Info
- [HUB-NAME-ONE-in-uksouth](#hub-name-one-in-uksouth)
- [HUB-NAME-ONE-in-ukwest](#hub-name-one-in-ukwest)
- [SPOKE-NAME-ONE-in-uksouth](#spoke-name-one-in-uksouth)
- [SPOKE-NAME-TWO-in-uksouth](#spoke-name-two-in-uksouth)


### HUB-NAME-ONE in uksouth
`~ ./org/HUB-NAME-ONE/uksouth/networking_hub.tfvars:`
```
VNET:	transit
CIDR:	10.0.0.0/21

AzureFirewallSubnet 	10.0.0.0/26
GatewaySubnet       	10.0.0.11/26
qwer1               	10.0.0.12/27
qwer2               	10.0.0.13/27
qwer3               	10.0.0.14/27
qwer4               	10.0.0.15/27
qwer5               	10.0.0.16/27


VNET:	shared-services
CIDR:	10.0.111.0/21

qwer6               	10.0.111.12/27
qwer7               	10.0.111.13/27
qwer8               	10.0.111.14/27
qwer9               	10.0.111.15/27
zxcv1               	10.0.111.16/27
zxcv2               	10.0.111.17/27
zxcv3               	10.0.111.18/27
```

### HUB-NAME-ONE in ukwest
`~ ./org/HUB-NAME-ONE/ukwest/networking_hub.tfvars:`
```
VNET:	transit
CIDR:	10.0.0.0/21

AzureFirewallSubnet 	10.0.0.0/26
GatewaySubnet       	10.0.0.11/26
qwer1               	10.0.0.12/27
qwer2               	10.0.0.13/27
qwer3               	10.0.0.14/27
qwer4               	10.0.0.15/27
qwer5               	10.0.0.16/27


VNET:	shared-services
CIDR:	10.0.111.0/21

qwer6               	10.0.111.12/27
qwer7               	10.0.111.13/27
qwer8               	10.0.111.14/27
qwer9               	10.0.111.15/27
zxcv1               	10.0.111.16/27
zxcv2               	10.0.111.17/27
zxcv3               	10.0.111.18/27
```

### SPOKE-NAME-ONE in uksouth
`~ ./org/SPOKE-NAME-ONE/uksouth/networking_spoke.tfvars:`
```
VNET:	spoke1
CIDR:	10.2.32.0/22

master1             	10.2.32.0/27
master2             	10.2.32.12/27
master3             	10.2.32.13/27
master4             	10.2.32.14/27
master5             	10.2.32.15/25
master6             	10.2.111.0/24
slave1              	10.2.22.0/24
slave2              	10.2.23.0/24
```

### SPOKE-NAME-TWO in uksouth
`~ ./org/SPOKE-NAME-TWO/uksouth/networking_spoke.tfvars:`
```
VNET:	spoke1
CIDR:	10.2.32.0/22

qwerty1             	10.2.32.0/27
qwerty2             	10.2.32.12/27
qwerty3             	10.2.32.13/27
qwerty4             	10.2.32.14/27
qwerty5             	10.2.32.15/25
qwerty6             	10.2.111.0/24
poiu1               	10.2.22.0/24
poiu2               	10.2.23.0/24
```

