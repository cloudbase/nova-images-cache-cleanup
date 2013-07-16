# Run every 30 minutes
$path = split-path -parent $MyInvocation.MyCommand.Definition
schtasks.exe /create /tn Nova-Images-Cache-Cleanup  /tr "powershell.exe -ExecutionPolicy RemoteSigned -File $path\nova_images_cache_cleanup.ps1" /sc minute /mo 30 /ru Administrator /rp
