$LocalIP = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}).DefaultIPGateway
$MacAddress = ((Get-NetNeighbor -IPAddress $LocalIP).LinkLayerAddress)
$PublicIP = ((Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress)

$MacFreebox = "F4-CA-E5"
$MacLivebox = "00-37-B7"
$MacApple = "BC-B8-63"
$MacXiaomi = "E0-CC-F8"

$MacSplit = $MacAddress -split "-"
$MacPrefix = $MacSplit[0] + "-" + $MacSplit[1] + "-" + $MacSplit[2]

# Checking if Mac Address is known
if($MacFreebox -contains $MacPrefix) # Check for Freebox
{$Router = "a Freebox"}
elseif($MacLivebox -contains $MacPrefix) # Check for Livebox
{$Router = "a Livebox"}
elseif($MacApple -contains $MacPrefix) # Check for Apple Device
{$Router = "an Apple device"}
elseif($MacXiaomi -contains $MacPrefix) # Check for Xiaomi Device
{$Router = "a Xiaomi device"}
else # If router is unknown
{$Router = "Unknown"}

if ($Router -like 'Unknown') # In the case router is unknown
{Write-Host "Router is unknown ($MacAddress). Maybe a randomized MAC address" ; exit 1} # Router is unknown, it's an error, so error code 1
else # In the case router is known
{Write-Host "Gateway is $Router ($MacAddress). `nLocal IP is $LocalIP. `nPublic IP is $PublicIP." ; exit 0} # Router is known, it's ok, error code 0
