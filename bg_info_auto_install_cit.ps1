$FolderName = "C:\Program Files\TeamViewerID"
$bgInfoZip = "C:\Program Files\TeamViewerID\BGInfo.zip"
$bginfoeula = "C:\Program Files\TeamViewerID\BGInfo\Eula.txt"
$bginfo_x86 = "C:\Program Files\TeamViewerID\BGInfo\Bginfo.exe"
$bginfofolder = "C:\Program Files\TeamViewerID\BGInfo"
$bgInfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$github_download = "https://github.com/compliceit/bginfo-config-file/raw/main/cit_bginfo_config.bgi"
$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegKey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegKeyValue = & "C:\Program Files\TeamViewerID\BGInfo\Bginfo64.exe" "C:\Program Files\TeamViewerID\BGInfo\cit_bginfo_config.bgi" /timer:0 /nolicprompt
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
$foregroundColor1 = "Red"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

#Create path if doesnt exist - if exists prompt to overwrite
if (Test-Path $FolderName) {
   
    Write-Host "Folder Exists"
    # Perform Delete file from folder operation
    Write-Host "Stopping installation"
    Exit
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    New-Item $bginfofolder -ItemType Directory
    Write-Host "Folder Created successfully"

}

#Get TeamVIewerID and write to txt file
(Get-ItemProperty -Path 'HKLM:\SOFTWARE\TeamViewer').ClientID | Out-File -FilePath "C:\Program FIles\TeamViewerID\TeamViewerID.txt"

#Download BGInfo and extract it & remove unneecessary files
Start-BitsTransfer -Source $bgInfoUrl -Destination $FolderName
Start-BitsTransfer -Source $github_download -Destination $bginfofolder
Expand-Archive -LiteralPath $bgInfoZip -DestinationPath $bginfofolder -Force
Remove-Item $bgInfoZip
Remove-Item $bginfoeula
Remove-Item $bginfo_x86

## Create BgInfo Registry Key to AutoStart
If ($regKeyExists -eq $True)
{
   Write-Host ($writeEmptyLine + "# BgInfo regkey exists, script wil go on" + $writeSeperatorSpaces + $currentTime)`
   -foregroundcolor $foregroundColor1 $writeEmptyLine
}
Else
{
   New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
 
   Write-Host ($writeEmptyLine + "# BgInfo regkey added" + $writeSeperatorSpaces + $currentTime)`
   -foregroundcolor $foregroundColor2 $writeEmptyLine
}

#Run BGInfo with config file
& "C:\Program Files\TeamViewerID\BGInfo\Bginfo64.exe" "C:\Program Files\TeamViewerID\BGInfo\cit_bginfo_config.bgi" /timer:0 /nolicprompt