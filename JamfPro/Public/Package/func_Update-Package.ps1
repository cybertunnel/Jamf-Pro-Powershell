############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/updatepackagebyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/updatepackagebyname
function Update-Building
{
    Param(
        # Jamf Pro server
        [Parameter(Position = 0,
        Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
        Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        [Parameter(Position = 2)]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 4)]
        [PSCustomObject]$Package
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI_PATH = "JSSResource/computergroups"
    $URI = "$Server/$URI_PATH"
    $URI += "/id/$Id"
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

    $headers = @{"Authorization" = "Bearer $token"
        "Accept" = "application/json"    
    }
    $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Headers $headers -Body $body
    return $response.package
}