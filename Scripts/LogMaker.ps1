$testRoot = "C:\splunk-essentials-master\Chapter01\eventgen"
$logRoot = "C:\XSPLK1ClassFiles\Logs"

$URIS = Import-Csv $testRoot\destinations-uris.sample -Header verb, URI
$codes = Import-Csv $testRoot\destinations-codes.sample -Header code
$extIps = Import-Csv $testRoot\external_ips.sample -Header IPAddr
$servers = Import-Csv $testRoot\servers.sample -Header serverName
$userAgentsDtop = Import-Csv $testRoot\useragents_desktop.sample -Header agtHeader -Delimiter "|"
$userAgentsMobile = Import-Csv $testRoot\useragents_mobile.sample -Header agtHeader -Delimiter "|"
$webHosts = Import-Csv $testRoot\webhosts.sample -Header hostName

$userAgents = $userAgentsDtop + $userAgentsMobile

function WriteLine{
    param([DateTime]$time,[string]$logPath)
    
    $URIWithVerb = $URIS | Get-Random

    $theLine = "{0},{1},{2},{3},-,80,-,{4},{5},{6},0,0,468,{7}" -f $(Get-Date -Date $time -Format "yyyy-MM-dd HH:mm:ss:fff"),$($webHosts.hostName | Get-Random),$($URIWithVerb.verb), $($URIWithVerb.URI),$($extIps.IPAddr | Get-Random),$($userAgents.agtHeader | Get-Random),$($codes.code | Get-Random),$(Get-Random -Minimum 900 -Maximum 2000)

    Write-Host $theLine
    $theLine | Out-File $logPath -Append

}


# Create the logfile

# "192.168.4.25 - - [22/Dec/2016:16:29:05 +0300] "POST /index.php/component/search/ HTTP/1.1" 500 2011 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.21""
# "2012-09-14 17:29:11:000,5.5.5.5,Method-And-URI,-,80,-,10.2.1.35,User-Agent,200,0,0,468,1488"

If($(Get-ChildItem $logRoot).Count -lt (((60/5) * 60 * 24)/1000)){

    #Initialize, starting 24 hours ago...
    Write-Host "Initializing log directory..."

    $yesterday = New-TimeSpan -Days -1 -Hours 0 -Minutes 0
    $interval = New-TimeSpan -Days 0 -Hours 0 -Minutes 0 -Seconds 5
    $theTime = $(Get-Date) + $yesterday

    Do{

    $logFile = "$logRoot\$(Get-Date -Date $theTime -Format "yyyyMMdd_HHmm")_testLog.log"

    for(($i = 0), ($j = 0); $i -lt 1000; $i++){
    
        $theTime = $theTime + $interval
        WriteLine $theTime $logFile
        }

    } While($theTime -lt $(Get-Date))

}

# Run current times
Write-Host "Generating log files..."
Do{

$logFile = "$logRoot\$(Get-Date -Format "yyyyMMdd_HHmm")_testLog.log"

Write-Host "***"
Write-Host "New logfile: $logFile"
Write-Host "***"

for(($i = 0), ($j = 0); $i -lt 1000; $i++){

    WriteLine $(Get-Date) $logFile
    Start-Sleep 1
    }

} While($true)