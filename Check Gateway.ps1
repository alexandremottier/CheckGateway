$ErrorActionPreference= 'silentlycontinue'
$LocalIP = ((Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}).DefaultIPGateway)
$MacAddress = ((Get-NetNeighbor -IPAddress $LocalIP).LinkLayerAddress)
$PublicIP = ((Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress)

$MacFreebox = 'F4-CA-E5*'
$MacLivebox = '00-37-B7*'
$MacApple = 'BC-B8-63*'
$MacXiaomi = 'E0-CC-F8*'

# Checking if Mac Address is known
if($MacAddress -like $MacFreebox) # Check for Freebox
{$Router = "a Freebox"}
elseif($MacAddress -like $MacLivebox) # Check for Livebox
{$Router = "a Livebox"}
elseif($MacAddress -like $MacApple) # Check for Apple Device
{$Router = "an Apple device"}
elseif($MacAddress -like $MacXiaomi) # Check for Xiaomi Device
{$Router = "a Xiaomi device"}
else # If router is unknown
{$Router = "Unknown"}

if ($Router -like 'Unknown') # In the case router is unknown
{Write-Host "Router is unknown ($MacAddress)." ; exit 1}
else
{Write-Host "Gateway is $Router ($MacAddress). `nLocal IP is $LocalIP. `nPublic IP is $PublicIP." ; exit 0} # Router is known, it's ok, error code 0
echo $?