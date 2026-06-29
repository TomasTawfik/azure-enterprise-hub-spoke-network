param virtualMachines_VM1_name string = 'VM1'
param virtualMachines_VM2_name string = 'VM2'
param loadBalancers_LB_Web_name string = 'LB-Web'
param natGateways_NAT_Spoke_name string = 'NAT-Spoke'
param networkInterfaces_vm1359_name string = 'vm1359'
param networkInterfaces_vm2329_name string = 'vm2329'
param publicIPAddresses_VM1_ip_name string = 'VM1-ip'
param virtualNetworks_Hup_Vnet_name string = 'Hup-Vnet'
param virtualNetworks_Vnet_One_name string = 'Vnet-One'
param publicIPAddresses_nat_pip_name string = 'nat-pip'
param routeTables_RT_Spoke_Egress_name string = 'RT-Spoke-Egress'
param networkSecurityGroups_NSG_DB_name string = 'NSG-DB'
param networkSecurityGroups_NSG_App_name string = 'NSG-App'
param networkSecurityGroups_NSG_Web_name string = 'NSG-Web'
param publicIPAddresses_Firewall_PIP_name string = 'Firewall-PIP'
param firewallPolicies_Hub_Firewall_Policy_name string = 'Hub-Firewall-Policy'

resource firewallPolicies_Hub_Firewall_Policy_name_resource 'Microsoft.Network/firewallPolicies@2024-07-01' = {
  name: firewallPolicies_Hub_Firewall_Policy_name
  location: 'francecentral'
  properties: {
    sku: {
      tier: 'Basic'
    }
    threatIntelMode: 'Alert'
  }
}

resource networkSecurityGroups_NSG_App_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_App_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'Wep-to-app'
        id: networkSecurityGroups_NSG_App_name_Wep_to_app.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3306'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_NSG_DB_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_DB_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'APP-TO-DB'
        id: networkSecurityGroups_NSG_DB_name_APP_TO_DB.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.0.2.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_NSG_Web_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_Web_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        id: networkSecurityGroups_NSG_Web_name_Allow_HTTP.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTPS'
        id: networkSecurityGroups_NSG_Web_name_Allow_HTTPS.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_Firewall_PIP_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_Firewall_PIP_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '3'
    '2'
    '1'
  ]
  properties: {
    ipAddress: '40.66.60.223'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'Disabled'
    }
  }
}

resource publicIPAddresses_VM1_ip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_VM1_ip_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.111.8.118'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource routeTables_RT_Spoke_Egress_name_resource 'Microsoft.Network/routeTables@2024-07-01' = {
  name: routeTables_RT_Spoke_Egress_name
  location: 'francecentral'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'Default-To-Firewall'
        id: routeTables_RT_Spoke_Egress_name_Default_To_Firewall.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.1.0.4'
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource virtualMachines_VM1_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_VM1_name
  location: 'francecentral'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2as_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM1_name}_OsDisk_1_d2a7ecdb34da4bf692a19f23503c7f1a'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_VM1_name}_OsDisk_1_d2a7ecdb34da4bf692a19f23503c7f1a'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM1_name
      adminUsername: 'TomasTawfik'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
          assessmentMode: 'ImageDefault'
          enableHotpatching: true
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm1359_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_VM2_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_VM2_name
  location: 'francecentral'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2as_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM2_name}_OsDisk_1_13ea0cda64274624a56271d001ebec9f'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_VM2_name}_OsDisk_1_13ea0cda64274624a56271d001ebec9f'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM2_name
      adminUsername: 'Tomastawfik'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
          assessmentMode: 'ImageDefault'
          enableHotpatching: true
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm2329_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource firewallPolicies_Hub_Firewall_Policy_name_App_Traffic_Rules 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-07-01' = {
  parent: firewallPolicies_Hub_Firewall_Policy_name_resource
  name: 'App-Traffic-Rules'
  location: 'francecentral'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Allow-Web-Internet'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.0.1.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '*'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '80'
              '443'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Allow-App-Internet2'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.0.2.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '*'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '443'
            ]
          }
        ]
        name: 'Allow-App-Traffic'
        priority: 100
      }
    ]
  }
}

resource loadBalancers_LB_Web_name_resource 'Microsoft.Network/loadBalancers@2024-07-01' = {
  name: loadBalancers_LB_Web_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LB-Frontend'
        id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_Firewall_PIP_name_resource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'Web-Backend'
        id: loadBalancers_LB_Web_name_Web_Backend.id
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: 'Network-FraceCenter-Network_vm2329ipconfig1'
              properties: {}
            }
            {
              name: 'Network-FraceCenter-Network_vm1359ipconfig1'
              properties: {}
            }
          ]
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'load-balancer-rule1'
        id: '${loadBalancers_LB_Web_name_resource.id}/loadBalancingRules/load-balancer-rule1'
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          enableConnectionTracking: false
          backendAddressPool: {
            id: loadBalancers_LB_Web_name_Web_Backend.id
          }
          backendAddressPools: [
            {
              id: loadBalancers_LB_Web_name_Web_Backend.id
            }
          ]
          probe: {
            id: '${loadBalancers_LB_Web_name_resource.id}/probes/Health1'
          }
        }
      }
    ]
    probes: [
      {
        name: 'Health1'
        id: '${loadBalancers_LB_Web_name_resource.id}/probes/Health1'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
          noHealthyBackendsBehavior: 'AllProbedDown'
        }
      }
    ]
    inboundNatRules: [
      {
        name: 'InboundRule'
        id: loadBalancers_LB_Web_name_InboundRule.id
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
          }
          frontendPort: 50001
          backendPort: 3389
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
        }
      }
      {
        name: 'InboundRule2'
        id: loadBalancers_LB_Web_name_InboundRule2.id
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
          }
          frontendPort: 50002
          backendPort: 3389
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
        }
      }
    ]
    outboundRules: []
    inboundNatPools: []
  }
}

resource loadBalancers_LB_Web_name_Web_Backend 'Microsoft.Network/loadBalancers/backendAddressPools@2024-07-01' = {
  name: '${loadBalancers_LB_Web_name}/Web-Backend'
  properties: {
    loadBalancerBackendAddresses: [
      {
        name: 'Network-FraceCenter-Network_vm2329ipconfig1'
        properties: {}
      }
      {
        name: 'Network-FraceCenter-Network_vm1359ipconfig1'
        properties: {}
      }
    ]
  }
  dependsOn: [
    loadBalancers_LB_Web_name_resource
  ]
}

resource loadBalancers_LB_Web_name_InboundRule 'Microsoft.Network/loadBalancers/inboundNatRules@2024-07-01' = {
  name: '${loadBalancers_LB_Web_name}/InboundRule'
  properties: {
    frontendIPConfiguration: {
      id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
    }
    frontendPort: 50001
    backendPort: 3389
    enableFloatingIP: false
    idleTimeoutInMinutes: 4
    protocol: 'Tcp'
    enableTcpReset: false
  }
}

resource loadBalancers_LB_Web_name_InboundRule2 'Microsoft.Network/loadBalancers/inboundNatRules@2024-07-01' = {
  name: '${loadBalancers_LB_Web_name}/InboundRule2'
  properties: {
    frontendIPConfiguration: {
      id: '${loadBalancers_LB_Web_name_resource.id}/frontendIPConfigurations/LB-Frontend'
    }
    frontendPort: 50002
    backendPort: 3389
    enableFloatingIP: false
    idleTimeoutInMinutes: 4
    protocol: 'Tcp'
    enableTcpReset: false
  }
}

resource natGateways_NAT_Spoke_name_resource 'Microsoft.Network/natGateways@2024-07-01' = {
  name: natGateways_NAT_Spoke_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_nat_pip_name_resource.id
      }
    ]
  }
}

resource networkSecurityGroups_NSG_Web_name_Allow_HTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_Web_name}/Allow-HTTP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Web_name_resource
  ]
}

resource networkSecurityGroups_NSG_Web_name_Allow_HTTPS 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_Web_name}/Allow-HTTPS'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Web_name_resource
  ]
}

resource networkSecurityGroups_NSG_DB_name_APP_TO_DB 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DB_name}/APP-TO-DB'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '1433'
    sourceAddressPrefix: '10.0.2.0/24'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DB_name_resource
  ]
}

resource networkSecurityGroups_NSG_App_name_Wep_to_app 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_App_name}/Wep-to-app'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3306'
    sourceAddressPrefix: '10.0.1.0/24'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_App_name_resource
  ]
}

resource publicIPAddresses_nat_pip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_nat_pip_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    natGateway: {
      id: natGateways_NAT_Spoke_name_resource.id
    }
    ipAddress: '51.103.27.234'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource routeTables_RT_Spoke_Egress_name_Default_To_Firewall 'Microsoft.Network/routeTables/routes@2024-07-01' = {
  name: '${routeTables_RT_Spoke_Egress_name}/Default-To-Firewall'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.1.0.4'
  }
  dependsOn: [
    routeTables_RT_Spoke_Egress_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_Hup_Vnet_name
  location: 'francecentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_Hup_Vnet_name_AzureFirewallSubnet.id
        properties: {
          addressPrefixes: [
            '10.1.0.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_Hup_Vnet_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.1.2.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureFirewallManagementSubnet'
        id: virtualNetworks_Hup_Vnet_name_AzureFirewallManagementSubnet.id
        properties: {
          addressPrefixes: [
            '10.1.1.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Spoke-to-Hub'
        id: virtualNetworks_Hup_Vnet_name_Spoke_to_Hub.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Vnet_One_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_Hup_Vnet_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefixes: [
      '10.1.1.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/AzureFirewallSubnet'
  properties: {
    addressPrefixes: [
      '10.1.0.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.1.2.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_DB 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/DB'
  properties: {
    addressPrefixes: [
      '10.0.3.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_DB_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_Hub_to_Spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/Hub-to-Spoke'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Hup_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_Spoke_to_Hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/Spoke-to-Hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Vnet_One_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource networkInterfaces_vm2329_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_vm2329_name
  location: 'francecentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm2329_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.0.1.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_One_name_Web.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          loadBalancerBackendAddressPools: [
            {
              id: loadBalancers_LB_Web_name_Web_Backend.id
            }
          ]
          loadBalancerInboundNatRules: [
            {
              id: loadBalancers_LB_Web_name_InboundRule2.id
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm1359_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_vm1359_name
  location: 'francecentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm1359_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.0.1.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_VM1_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_Vnet_One_name_Web.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          loadBalancerBackendAddressPools: [
            {
              id: loadBalancers_LB_Web_name_Web_Backend.id
            }
          ]
          loadBalancerInboundNatRules: [
            {
              id: loadBalancers_LB_Web_name_InboundRule.id
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworks_Vnet_One_name_App 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/App'
  properties: {
    addressPrefixes: [
      '10.0.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_App_name_resource.id
    }
    routeTable: {
      id: routeTables_RT_Spoke_Egress_name_resource.id
    }
    natGateway: {
      id: natGateways_NAT_Spoke_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_Web 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/Web'
  properties: {
    addressPrefixes: [
      '10.0.1.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_Web_name_resource.id
    }
    routeTable: {
      id: routeTables_RT_Spoke_Egress_name_resource.id
    }
    natGateway: {
      id: natGateways_NAT_Spoke_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_Vnet_One_name
  location: 'francecentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'DB'
        id: virtualNetworks_Vnet_One_name_DB.id
        properties: {
          addressPrefixes: [
            '10.0.3.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_DB_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'Web'
        id: virtualNetworks_Vnet_One_name_Web.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_Web_name_resource.id
          }
          routeTable: {
            id: routeTables_RT_Spoke_Egress_name_resource.id
          }
          natGateway: {
            id: natGateways_NAT_Spoke_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'App'
        id: virtualNetworks_Vnet_One_name_App.id
        properties: {
          addressPrefixes: [
            '10.0.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_App_name_resource.id
          }
          routeTable: {
            id: routeTables_RT_Spoke_Egress_name_resource.id
          }
          natGateway: {
            id: natGateways_NAT_Spoke_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Hub-to-Spoke'
        id: virtualNetworks_Vnet_One_name_Hub_to_Spoke.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Hup_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}
