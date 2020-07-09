#Replace parameters Name and IP Range before running the script
$backendSubnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name ENV-PRD-Subnet `
  -AddressPrefix XX.XX.XX.XX/24

$agSubnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name ENV-PRD-WebLayer `
  -AddressPrefix XX.XX.XX.XX/24

New-AzVirtualNetwork `
  -ResourceGroupName prdresourcegroup `
  -Location eastus `
  -Name ENV-PRD-Vnet `
  -AddressPrefix XX.XX.XX.XX/16 `
  -Subnet $backendSubnetConfig, $agSubnetConfig

New-AzPublicIpAddress `
  -ResourceGroupName myResourceGroupAG `
  -Location eastus `
  -Name ENV-PRD-PubIP `
  -AllocationMethod Static
