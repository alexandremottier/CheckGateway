$IP = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}).DefaultIPGateway
$MACAddressList = (Get-NetNeighbor -State Reachable)
foreach ($item in $MACAddressList) {
$AdresseIP = $item.IPAddress
$AdresseMAC = $item.LinkLayerAddress
if ($IP -contains $AdresseIP){$GatewayMac = $AdresseMAC ; $GatewayIP = $AdresseIP}
}


$PublicIP = ((Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress)

$MacFreebox = "F4-CA-E5","00-07-CB","00-24-D4","14-0C-76","34-27-92","68-A3-78","70-FC-8F","8C-97-EA","E4-9E-12"
$MacLivebox = "00-37-B7"
$MacApple = "BC-B8-63"
$MacXiaomi = "E0-CC-F8"
$MacFortinet = "08-5B-0E"

$MacSplit = $GatewayMac -split "-"
$MacPrefix = $MacSplit[0] + "-" + $MacSplit[1] + "-" + $MacSplit[2]

$Router = (Invoke-WebRequest -Uri "https://api.macvendors.com/$MacPrefix").Content

$ShodanLink = "https://api.shodan.io/shodan/host/" + $PublicIP + "?key=9r6vVczYqYGR9F3WADASttMPt6fqK2Mm"
$Shodan = Invoke-RestMethod -uri $ShodanLink
$ISP = $Shodan.isp
if ($Router -eq ""){"Gateway vendor is unknown ($GatewayMac). `nLocal IP is $AdresseIP. `nPublic IP is $PublicIP."}
else{
Write-Host "Gateway vendor is $Router ($GatewayMac). `nLocal IP is $AdresseIP. `nPublic IP is $PublicIP ($ISP)."}
