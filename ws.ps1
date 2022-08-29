$fileName = "agent-$(Get-Date -f yyyy-MM-dd)-updates.log"

Write-Host "1. Install PSWindowsUpdate module."
Install-Module PSWindowsUpdate
Write-Host "2. Verify PSWindowsUpdate module"
Get-InstalledModule -Name PSWindowsUpdate
Write-Host "3. Get windows update list"
Get-WindowsUpdate
Write-Host "4. Install windows update list"
Install-WindowsUpdate -AcceptAll | Out-File "./$fileName"

$content = Get-Content -Path "./$fileName"

if([string]::IsNullOrEmpty($content)){
    $content = "Nothing to update!"    
}else{
    $content = $content.Replace("`n","<br/>")
}

$body = @{
    "@type" = "MessageCard"
    "@context" = "<http://schema.org/extensions>"
    "summary" = "Windows update summary!"
    "themeColor" = '0078D7'
    "title" = 'Windows Update status'
    "text" = "$content"
}

$msg = ConvertTo-Json $body

$parameters = @{
    "URI" = '{URL}'
    "Method" = 'POST'
    "Body" = $msg
    "ContentType" = 'application/json'
}

Invoke-RestMethod @parameters
