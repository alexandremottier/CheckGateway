# PowerShell_Scripts
Some useful PowerShell scripts

## Check Gateway

### How it works ?

First, the script gets the gateway's IP address :

`$LocalIP = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}).DefaultIPGateway`

Then, with the IP address, the script gets the MAC address of the gateway :

`$MacAddress = ((Get-NetNeighbor -IPAddress $LocalIP).LinkLayerAddress)`

And the public IP address with opendns.com :

`$PublicIP = ((Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress)`

Next, we got arrays containing the MAC addresses by manufacturer :

```
$MacFreebox = "F4-CA-E5"
$MacLivebox = "00-37-B7"
$MacApple = "BC-B8-63"
$MacXiaomi = "E0-CC-F8"
```

The script cuts the MAC address of the gateway by 3 groups (bytes) :

```
$MacSplit = $MacAddress -split "-"
$MacPrefix = $MacSplit[0] + "-" + $MacSplit[1] + "-" + $MacSplit[2]
```

Next, compares the MAC addresses with arrays :

```
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
```

And give the result of the comparison :

```
if ($Router -like 'Unknown') # In the case router is unknown
{Write-Host "Router is unknown ($MacAddress). Maybe a randomized MAC address" ; exit 1}
else
{Write-Host "Gateway is $Router ($MacAddress). `nLocal IP is $LocalIP. `nPublic IP is $PublicIP." ; exit 0}
```
