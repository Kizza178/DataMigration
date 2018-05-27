## HK3000 to HK4000 Script
##Author Kieren
## SN = Short Name

clear-host

$Source = "SVINT001.Smith.lan"
$Destination = "SVINT002.Smith.lan"
$SourceSN = "SVINT001"
$DestinationSN = "SVINT002"
$LogServer = "Int.Smith.lan"
$LogFileLocation = "\\Int.Smith.lan\Logs\DataMigration\"
$LogName = "DataMigration.log"


Write-Host "Data Migration from HK3000 to HK4000"
$LogLocationAvailable = Test-Connection -ComputerName $LogServer -Quiet
if ($($LogLocationAvailable) -like "*False*") {
    Write-Host "!!WARNING!! Log Server Not available, Please Check Log Server exists before continuing" -ForegroundColor Red
    Break
}
Write-Host "Logfile located at $($LogFileLocation)$($LogName)" -ForegroundColor Yellow

Write-Host "Testing Connection to $($SourceSN) and $($DestinationSN)" -ForegroundColor Yellow
$Result1 = Test-Connection -ComputerName $Source -Count "5" -Quiet
$Result2 = Test-Connection -ComputerName $Destination -Count "5" -Quiet

Write-host "Results $($SourceSN) = $($Result1) & $($DestinationSN) = $($Result2)" -ForegroundColor Yellow

if (($Result1) -and ($Result2) -eq "True") {
    Write-Host "Connection to both servers are successful"
    
    $PreStartStatus = Import-Csv -Path "$($LogFileLocation)Status.csv" 
    
    foreach ($Share in $PreStartStatus) {
        if ($Share.Status -ne "Complete") {
            #Write-Host "$($Share.ShareName) ... $($Share.Status)"
            $Share.Status = "Complete"
            
        }

    }

    $Share1 = New-Object System.Object
    $Share1 | Add-Member -type NoteProperty -Name ShareName -Value "Kieren"
    $Share1 | Add-Member -type NoteProperty -Name Status -Value "Not Complete"

    $Share2 = New-Object System.Object
    $Share2 | Add-Member -type NoteProperty -Name ShareName -Value "MediaStreaming"
    $Share2 | Add-Member -type NoteProperty -Name Status -Value "Not Complete"

    $Share3 = New-Object System.Object
    $Share3 | Add-Member -Type NoteProperty -Name ShareName -Value "ProjectRepository"
    $Share3 | Add-Member -type NoteProperty -Name Status -Value "Not Complete"

    $SharesArray  = @()
    $SharesArray += $Share1
    $SharesArray += $Share2, $Share3

    $SharesArray | Export-Csv -Path "$($LogFileLocation)Status.csv" -NoTypeInformation










}elseif ($($Result1) -ne "True" -and $($Result2) -ne "True") {
    Write-Host  "$($SourceSN) and $($DestinationSN) are Unavailable, please check connection to Servers" -ForegroundColor Red
    Break    
}elseif ($Result1 -ne "True") {
    Write-Host "$($SourceSN) is Unavailable, please check connection to Servers" -ForegroundColor Red
    Break
}elseif ($Result2 -ne "True") {
    Write-Host "$($DestinationSN) is Unavailable, please check connection to Servers" -ForegroundColor Red
    Break
}
