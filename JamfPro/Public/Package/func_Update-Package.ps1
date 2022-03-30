# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/updatepackagebyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/updatepackagebyname
function Update-Building
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 1, Mandatory = $false)][pscustomobject]$Package
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/packages/id/$Id"
    $Headers = @{"Authorization" = "Bearer $Token"}

    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><package>"
    $xmlString += "<id>$Id</id>"
    $xmlString += "<name>$($Package.name)</name>"
    $xmlString += "<category>$($Package.name)</category>"
    $xmlString += "<filename>$($Package.filename)</filename>"
    $xmlString += "<info>$($Package.info)</info>"
    $xmlString += "<notes>$($Package.notes)</notes"
    $xmlString += "<priority>$($Package.priority)</priority>"
    $xmlString += "<reboot_required>$($Package.reboot_required)</reboot_required>"
    $xmlString += "<fill_user_template>$($Package.fill_user_template)</fill_user_template>"
    $xmlString += "<fill_existing_users>$($Package.fill_existing_users)</fill_existing_users>"
    $xmlString += "<allow_uninstalled>$($Package.allow_uninstalled)</allow_uninstalled>"
    $xmlString += "<os_requirements>$($Package.os_requirements)</os_requirements>"
    $xmlString += "<required_processor>$($Package.required_processor)</required_processor>"
    $xmlString += "<hash_type>$($Package.hash_type)</hash_type>"
    $xmlString += "<hash_value>$($Package.hash_value)</hash_value>"
    $xmlString += "<switch_with_package>$($Package.switch_with_package)</switch_with_package>"
    $xmlString += "<install_if_reported_available>$($Package.install_if_reported_available)</install_if_reported_available>"
    $xmlString += "<reinstall_option>$($Package.reinstall_option)</reinstall_option>"
    $xmlString += "<triggering_files>$($Package.triggering_files)</triggering_files>"
    $xmlString += "<send_notification>$($Package.send_notification)</send_notification>"
    $xmlString += "</package>"
    
    $body = New-Object system.Xml.XmlDocument
    $body.LoadXml($xmlString)

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"
            "Accept" = "application/json"    
        }
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Headers $headers -Body $body
        return $response.package

    }
    else {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
        return $response.package
    }
}