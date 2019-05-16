#===============================================================================
# Declarations
#===============================================================================
$filename = ".\EU_Windows_Scope_Options.csv" #Name of the generated CSV file
$DnsDomain = "*.eu.boehringer.com" #Domain name of the fqdn of the DHCPservers, use * as leading char

#===============================================================================
# Functions
#===============================================================================
function HextoString([string]$hexString){

    $result = ""    
    $hexString = $hexString.Replace("0x0a","") #Remove New Linechar from string
    $hexString = $hexString.Replace("0x0d","") #remove Carriage Return from string 
    $hexString = $hexString.Replace("0x","")
    $hexString.Split(" ") | forEach {[char]([convert]::toint16($_,16))} | forEach {$result = $result + $_}
    return $result

}

#===============================================================================
# Execution
#===============================================================================
Add-Content -Value "SERVER; SCOPE; SCOPE_NAME; DESCRIPTION; OPTIONID; NAME; TYPE; VALUE" -Path $filename

$sSrvs = Get-DhcpServerInDC | ?{$_.dnsname -like $DnsDomain} | select dnsname

foreach($srv in $sSrvs){
$Scopes = @()
$Scopes = Get-DhcpServerv4Scope -ComputerName $srv.dnsname -ErrorAction SilentlyContinue

if($scopes.count -gt 0){
Write-Host "Checking DHCP Server $($srv.dnsname)"

foreach ($Scope in $Scopes) {

    $Options = Get-DhcpServerv4OptionValue -ComputerName $srv.dnsname -ScopeId $Scope.ScopeId.IPAddressToString -All | Sort-Object -Descending -Property OptionId

    for ($i = ($Options.Count -1); $i -gt -1; $i--) {
        [string]$sServer = "$($srv.dnsname)"
        [string]$sScope =  "$($Scope.ScopeId.IPAddressToString)"
        [string]$sScopeName = "$($Scope.name)"
        [string]$sDescription = "$($Scope.description)"
        [string]$sOptionID = "$($Options[$i].OptionId)"
        [string]$sName = "$($Options[$i].Name)"
        [string]$sType = "$($Options[$i].Type)"
        [string]$sValue = "$($Options[$i].Value)"
            
        switch($sname){
            "UCSipServer"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "CertProvRelPath"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                } 
            "WebServerPort"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "UCIdentifier"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "URLScheme"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "WebServerFqdn"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "Provisioning Server 161"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }
            "Provisioning Server"
                {
                    if($sType -eq "BinaryData"){ $sValue = HextoString $sValue } 
                    Add-Content -Value "$sServer;$sScope;$sScopeName;$sDescription;$sOptionID;$sName;$sType;$sValue " -Path $filename
                }         

            }

        }

    }
    }
}
