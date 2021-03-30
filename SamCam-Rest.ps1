$c = Get-Credential admin #if password is set, must be -le 8 chars
Function Update-CameraConfig ($IP){
If (!($IP)) {$IP = "192.168.123.100"} #Set Default EthIP

$global:deviceinfo        = "http://$IP/stw-cgi-rest/system/deviceinfo"
$global:date              = "http://$IP/stw-cgi-rest/system/date"
$global:timezonelist      = "http://$IP/stw-cgi-rest/system/date/timezonelist"
$global:factoryreset      = "http://$IP/stw-cgi-rest/system/factoryreset"
$global:power             = "http://$IP/stw-cgi-rest/system/power"
$global:firmwareupdate    = "http://$IP/stw-cgi-rest/system/firmwareupdate"
$global:interface         = "http://$IP/stw-cgi-rest/network/interface"
$global:wifi              = "http://$IP/stw-cgi-rest/network/wifi"
$global:scan              = "http://$IP/stw-cgi-rest/network/wifi/scan"
$global:connect           = "http://$IP/stw-cgi-rest/network/wifi/connect"
$global:users             = "http://$IP/stw-cgi-rest/security/users"
$global:ssl               = "http://$IP/stw-cgi-rest/security/ssl"
$global:smtp              = "http://$IP/stw-cgi-rest/transfer/smtp"
$global:subscription      = "http://$IP/stw-cgi-rest/transfer/subscription"
$global:videoanalysis     = "http://$IP/stw-cgi-rest/eventsources/videoanalysis"
$global:audiodetection    = "http://$IP/stw-cgi-rest/eventsources/audiodetection"
$global:camera            = "http://$IP/stw-cgi-rest/image/camera"
$global:imageenhancements = "http://$IP/stw-cgi-rest/image/imageenhancements"
$global:flip              = "http://$IP/stw-cgi-rest/image/flip"
$global:overlay           = "http://$IP/stw-cgi-rest/image/overlay"
$global:otheroutputs      = "http://$IP/stw-cgi-rest/io/otheroutputs"
$global:lullaby           = "http://$IP/stw-cgi-rest/io/lullaby"
$global:audioinput        = "http://$IP/stw-cgi-rest/media/audioinput"
$global:audiooutput       = "http://$IP/stw-cgi-rest/media/audiooutput"
}
Update-CameraConfig $IP
$d = {
Subject : "Living Event Alarm"
} | ConvertTo-Json
Invoke-RestMethod -Method Put -Uri (http://{$IP}/stw-cgi-rest/transfer/smtp) -Credential $c -Verbose -Body $d

$d = @{
DetectionType = “Off";
} | ConvertTo-JSon
Invoke-RestMethod -Method Put -Uri (“http://"+($IP)+"/stw-cgi-rest/eventsources/videoanalysis") -Body $d -Credential $c

#To turn back on:
$d = @{
DetectionType = “MotionDetection";
} | ConvertTo-JSon
Invoke-RestMethod -Method Put -Uri (“http://"+($IP)+"/stw-cgi-rest/eventsources/videoanalysis") -Body $d -Credential $c

#add Subscription
$d = {
NotificationURL : "http://{hubip}",
EventType : "All“,
SubscriptionID : "1"
} | ConvertTo-Json

#And remove it:
$d = {
SubscriptionID : "1";
} | ConvertTo-Json

#get settings
Function Get-CameraSettings ($URI,$Credential){
Invoke-RestMethod -Method Get -Uri $URI -Credential $Credential -Verbose}
#get settings
Function Set-CameraSettings ($URI,$Credential,$Method,$Request){
Invoke-RestMethod -Method $Method -Uri $URI -Credential $Credential -Body $Request -Verbose
}
#$APList = (Get-CameraSettings -Credential $c -URI "http://$IP/device/network/aplist").Network.APList
$Information = (Get-CameraSettings -Credential $c -URI "http://$IP/information").Information
$Network = (Get-CameraSettings -Credential $c -URI "http://$IP/device/network").Network
$WiredNetwork = $Network.wired
$WirelessNetwork = $Network.wireless
$WiredNetwork
$WirelessNetwork
Get-CameraSettings -Credential $c -URI $deviceinfo 
Get-CameraSettings -Credential $c -URI $date
Get-CameraSettings -Credential $c -URI $timezonelist | Select TimeZoneList
Get-CameraSettings -Credential $c -URI $factoryreset
Get-CameraSettings -Credential $c -URI $power
Get-CameraSettings -Credential $c -URI $firmwareupdate #need to watch legit request in fiddler
Get-CameraSettings -Credential $c -URI $interface 
Get-CameraSettings -Credential $c -URI $wifi
Get-CameraSettings -Credential $c -URI $scan
Get-CameraSettings -Credential $c -URI $connect
Get-CameraSettings -Credential $c -URI $users
Get-CameraSettings -Credential $c -URI $ssl
Get-CameraSettings -Credential $c -URI $smtp
Get-CameraSettings -Credential $c -URI $subscription
Get-CameraSettings -Credential $c -URI $videoanalysis
Get-CameraSettings -Credential $c -URI $audiodetection
Get-CameraSettings -Credential $c -URI $camera
Get-CameraSettings -Credential $c -URI $imageenhancements
Get-CameraSettings -Credential $c -URI $flip
Get-CameraSettings -Credential $c -URI $overlay
Get-CameraSettings -Credential $c -URI $otheroutputs
Get-CameraSettings -Credential $c -URI $lullaby
Get-CameraSettings -Credential $c -URI $audioinput
Get-CameraSettings -Credential $c -URI $audiooutput

$VerticalFlipEnable = @{
    Credential = $c
    Uri        = $flip
    Method     = "Put"
    Request    = @{VerticalFlipEnable = $true} | ConvertTo-Json
    }
$VerticalFlipDisable = @{
    Credential = $c
    Uri        = $flip
    Method     = "Put"
    Request    = @{VerticalFlipEnable = $false} | ConvertTo-Json
    }
$HorizontalFlipEnable = @{
    Credential = $c
    Uri        = $flip
    Method     = "Put"
    Request    = @{HorizontalFlipEnable = $true} | ConvertTo-Json
    }
$HorizontalFlipDisable = @{
    Credential = $c
    Uri        = $flip
    Method     = "Put"
    Request    = @{HorizontalFlipEnable = $false} | ConvertTo-Json
    }
$StatusLEDStateOn = @{
    Credential = $c
    Uri        = $otheroutputs
    Method     = "Put"
    Request    = @{"StatusLED.State" = "On"} | ConvertTo-Json
    }
$StatusLEDStateOff = @{
    Credential = $c
    Uri        = $otheroutputs
    Method     = "Put"
    Request    = @{"StatusLED.State" = "Off"} | ConvertTo-Json
    }
$OverLayOn = @{
    Credential = $c
    Uri        = $overlay
    Method     = "Put"
    Request    = @{TimeEnable = $true} | ConvertTo-Json
    }
$OverlayOff    = @{
    Credential = $c
    Uri        = $overlay
    Method     = "Put"
    Request    = @{TimeEnable = $false} | ConvertTo-Json
    }
$SetTimeSyncType = @{
    Credential = $c
    Uri        = $date
    Method     = "Put"
    Request    = @{SyncType = "NTP"} | ConvertTo-Json  ###don't know the other choices
    }
$PerformFactoryReset = @{
    Credential = $c
    Uri        = $factoryreset
    Method     = "Put"
    }
$PerformRestart = @{
    Credential = $c
    Uri        = $power
    Method     = "Put"
    }
$NetInterfaceType = @{
    Credential = $c
    Uri        = $interface
    Method     = "Put"
    Request    = @{
        IPv4Type         = "DHCP" #Manual
        #IPv4Address      = "192.168.123.100"
        #IPv4PrefixLength = "20"
        #IPv4Gateway      = "192.168.123.1"
        } | ConvertTo-Json
    } ;Set-CameraSettings @NetInterfaceType;
    Update-CameraConfig -IP ($NetInterfaceType.Request|ConvertFrom-Json).IPv4Address;
    Get-CameraSettings @NetInterfaceType
$WifiOn = @{
    Credential = $c
    Uri        = $wifi
    Method     = "Put"
    Request    = @{Enable = $true} | ConvertTo-Json
    }
$WifiOff = @{
    Credential = $c
    Uri        = $wifi
    Method     = "Put"
    Request    = @{Enable = $false} | ConvertTo-Json
    }
$WifiConnect = @{
    Credential = $c
    Uri        = $connect
    Method     = "Put"
    Request    = @{
        SSID = "Wifi"
        Password = "PSK-enter here"
        SecurityMode = "PSK"
    } | ConvertTo-Json
    }
$SetPassword = @{
    Credential = $c
    Uri        = $users
    Method     = "Put"
    Request    = @{
        UserID = 'admin';Password = 'test'
        } | ConvertTo-Json
    }


Set-CameraSettings @VerticalFlipEnable
Set-CameraSettings @VerticalFlipDisable
Set-CameraSettings @HorizontalFlipEnable
Set-CameraSettings @HorizontalFlipDisable
Set-CameraSettings @StatusLEDStateOn
Set-CameraSettings @StatusLEDStateOff
Set-CameraSettings @OverLayOn
Set-CameraSettings @OverlayOff
Set-CameraSettings @SetTimeSyncType
Set-CameraSettings @PerformFactoryReset
Set-CameraSettings @PerformRestart
Set-CameraSettings @NetInterfaceType
Set-CameraSettings @WifiOn
Set-CameraSettings @WifiOff
Set-CameraSettings @WifiConnect
Set-CameraSettings @SetPassword

Set-CameraSettings @WifiConnect



