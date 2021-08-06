Write-Output "Suljetaan Atera ja Slashtop prosessit"


Get-Process | Where-Object {$_.ProcessName -Like "*Slashtop*"} | Stop-Process -force

Get-Process | Where-Object {$_.ProcessName -Like "AnyDesk*"} | Stop-Process -force

#Sammutetaan ja Poistetaan Splashtop ja AnyDesk Palvelut
Write-Host = "Sammutetaan Splashtop ja AnyDesk Servicet"
$SplashService = Get-Service | Where-Object {$_.ServiceName -Like "Splash*"}
$SplashService | Stop-Service -force
sc.exe delete $SplashService

$SSUService = Get-Service | Where-Object {$_.ServiceName -Like "SSU*"}
$SSUService | Stop-Service -force
sc.exe delete $SSUService

$AnydeskService = Get-Service | Where-Object {$_.ServiceName -Like "AnyDesk*"}
$AnydeskService | Stop-Service -force
sc.exe delete $AnyDeskService

New-Item -Path "C:\Users\AdminJaloit\Desktop" -Name "Splashtop_Anydesk_stopattu.txt" -ItemType "file" -Value "Skripti suoritettiin loppuun saakka."
#Sammutetaan käynnissä olevat prosessit
#Suljetaan Atera ja splashtop prosessit


# Poistetaan Splashtop ja AnyDesk
Write-Output "Poistetaan Splashtop ja AnyDesk Asennus"
Get-Package "Splashtop Streamer" | Uninstall-Package -Force
Get-Package "Splashtop Software Updater" | Uninstall-Package -Force
#$app1 = Get-CimInstance -class Win32_Product -filter "Name = 'Splashtop Streamer'"
#$app1.Uninstall()


#$app2 = Get-CimInstance -class Win32_Product | where {$_.Name -Like "*AnyDesk*"}
#$app2.Uninstall()
Get-Package "AnyDesk Custom Client" | Uninstall-Package -Force
Get-Package "AnyDesk MSI" | Uninstall-Package -Force
#$app4 = Get-CimInstance -class Win32_Product -filter "Name = 'AnyDesk MSI'"
#$app4.Uninstall()
New-Item -Path "C:\Users\AdminJaloit\Desktop" -Name "Splashtop_Anydesk_poistettu.txt" -ItemType "file" -Value "Skripti suoritettiin loppuun saakka."



#Final: poistetaan kaikki itse ateran paska
Write-Output "Poistetaan Atera"

Get-Process | Where-Object {$_.ProcessName -Like "*Atera*"} | Stop-Process -force
Get-Process | Where-Object {$_.ProcessName -Like "AgentPackage*"} | Stop-Process -force
Start-Process "cmd.exe" -ArgumentList "/c taskkill /f /im AgentPackageSystemTools.exe > nul 2> nul && exit" -Wait

$AteraService = Get-Service | Where-Object {$_.ServiceName -Like "Atera*"}
$AteraService | Stop-Service -force
Get-Package AteraAgent | Uninstall-Package
#$app3 = get-CimInstance -class Win32_Product -filter "Name = 'AteraAgent'"
#$app3.Uninstall()

Start-Process "sc.exe" -ArgumentList "delete $AteraServices && exit" -Wait

New-Item -Path "C:\Users\AdminJaloit\Desktop" -Name "Atera_alku_poistettu.txt" -ItemType "file" -Value "Skripti suoritettiin loppuun saakka."



#Siivotaan järjestelmä
# Poistetaan  Ateraan ja Splashtop:iin viittaavat Program Files-kansiot varmuuden vuoksi
Write-Output "Poistetaan Program Files kansiot"

Get-ChildItem "C:\Program Files (x86)\ATERA Networks" -Recurse | Remove-Item -Recurse -Force -ErrorAction silentlycontinue
Remove-Item "C:\Program Files (x86)\ATERA Networks\*" -Recurse -Force
Remove-Item "C:\Program Files (x86)\ATERA Networks" -Recurse -Force
Get-ChildItem "C:\Program Files\ATERA Networks" -Recurse | Remove-Item -Recurse -Force -ErrorAction silentlycontinue 
Remove-Item "C:\Program Files\ATERA Networks" -Recurse -Force -ErrorAction silentlycontinue
Remove-Item "C:\Program Files (x86)\Splashtop" -Recurse -Force -ErrorAction silentlycontinue
Remove-Item "C:\Program Files\ATERA Networks\*" -Recurse -Force -ErrorAction silentlycontinue
# Remove-Item "C:\Program Files (x86)\AnyDeskMSI" -Recurse -Force -ErrorAction silentlycontinue
Get-ChildItem "C:\Program Files (x86)\" -Filter "AnyDesk*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Start-Process "cmd.exe" -ArgumentList "/c taskkill /f /im AgentPackageSystemTools.exe > nul 2> nul && exit" -Verb RunAs -Wait
Start-Process "cmd.exe" -ArgumentList "/c timeout /t 10 /nobreak && exit" -Wait
Start-Process "cmd.exe" -ArgumentList '/c RMDIR /S /Q "C:\Program Files (x86)\ATERA Networks" && exit' -Verb RunAs -
Remove-Item "C:\Program Files\ATERA Networks\AteraAgent\Packages" -Recurse -Force
Remove-Item "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageSystemTools" -Recurse -Force
Start-Process "cmd.exe" -ArgumentList '/c RMDIR /S /Q "C:\Program Files\ATERA Networks\AteraAgent" && exit' -Verb RunAs -Wait
Start-Process "cmd.exe" -ArgumentList '/c RMDIR /S /Q "C:\Program Files\ATERA Networks" && exit' -Verb RunAs -Wait
Start-Process "cmd.exe" -ArgumentList '/c RMDIR /S /Q "C:\Program Files\ATERA Networks\AteraAgent" && exit' -Verb RunAs -Wait
New-Item -Path "C:\Users\AdminJaloit\Desktop" -Name "Program_Files_poistettu.txt" -ItemType "file" -Value "Skripti suoritettiin loppuun saakka."


#Poistetaan %AppData%

# Get users
$users = Get-ChildItem -Path "C:\Users"

# Loop through users and delete the file
$users | ForEach-Object {
    Remove-Item -Path "C:\Users\$($_.Name)\AppData\Local\Splashtop" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Users\$($_.Name)\AppData\Roaming\AnyDesk" -Recurse -Force -ErrorAction SilentlyContinue
}


#Poistetaan ProgramData
Write-Output "Poistetaan ProgramData-kansioisen sisältö"
Remove-Item "C:\ProgramData\Splashtop" -Recurse -Force -ErrorAction silentlycontinue
Remove-Item "C:\ProgramData\AnyDesk" -Recurse -Force -ErrorAction silentlycontinue


#Poistetaan rekisteristä tietoa
Write-Output "Poistetaan näihin ohjelmiin liittyviä rekisteritietoja"
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "AlphaHelpdeskAgent"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "*Atera*"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name '*AnyDesk*'
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name '*Splashtop*'
Remove-Item -Path 'HKLM:\SOFTWARE\ATERA Networks' -Recurse
Remove-Item -Path 'HKCU:\SOFTWARE\ATERA Networks' -Recurse


Remove-Item -Path 'HKCU:\SOFTWARE\ATERA Networks' -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Splashtop Inc.' -Recurse
Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\AnyDesk-*" -Recurse
Remove-Item -Path 'HKCU:\SOFTWARE\Splashtop Inc.' -Recurse

New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
Remove-Item -Path 'HKCR:\Installer\Products\4758948C95C1B194AB15204D95B42292' -Recurse
Remove-Item -Path 'HKCR:\Installer\Products\4758948C95C1B194AB15204D95B42292' -Recurse
Remove-Item -Path 'HKCR:\Installer\Products\10F15BFE50893924BB61F671FEC4DE2F' -Recurse
Remove-PSDrive -Name HKCR


New-Item -Path "C:\Users\AdminJaloit\Desktop" -Name "AteraDeleted.txt" -ItemType "file" -Value "Skripti suoritettiin loppuun saakka."
Write-Output "Nyt pitäisi olla valmista"
