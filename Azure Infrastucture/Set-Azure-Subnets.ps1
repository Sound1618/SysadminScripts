#Replace parameters Name and Address Fix before running the script
$backendSubnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name ENV-PRD-Subnet `
  -AddressPrefix 172.22.1.0/24

$agSubnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name ENV-PRD-WebLayer `
  -AddressPrefix 172.22.2.0/24

New-AzVirtualNetwork `
  -ResourceGroupName prdresourcegroup `
  -Location eastus `
  -Name ENV-PRD-Vnet `
  -AddressPrefix 172.22.0.0/16 `
  -Subnet $backendSubnetConfig, $agSubnetConfig

New-AzPublicIpAddress `
  -ResourceGroupName myResourceGroupAG `
  -Location eastus `
  -Name ENV-PRD-PubIP `
  -AllocationMethod Static