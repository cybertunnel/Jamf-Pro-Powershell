############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer EA by ID: https://developer.jamf.com/jamf-pro/reference/updatecomputerextensionattributebyid
# - Computer EA by Name: https://developer.jamf.com/jamf-pro/reference/updatecomputerextensionattributebyname
# - Mobile EA by ID: https://developer.jamf.com/jamf-pro/reference/updatemobiledeviceextensionattributebyid
# - Mobile EA by Name: https://developer.jamf.com/jamf-pro/reference/updatemobiledeviceextensionattributebyname
# - User EA by ID: https://developer.jamf.com/jamf-pro/reference/updateuserextensionattributebyid
# - User EA by Name: https://developer.jamf.com/jamf-pro/reference/updateuserextensionattributebyname
function Update-ExtensionAttribute
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

        [Parameter(Position = 3)]
        [Switch]$Computer,

        [Parameter(Position = 4)]
        [PSCustomObject]$ExtensionAttribute
    )
    $URI_PATH = "JSSResource/computerextensionattributes"
    $URI = "$Server/$URI_PATH"
    $URI += "/id/$Id"

    if (-not $Computer)
    {
        throw "A Extension Attribute type must be provided. Currently supported types: `"-Computer`""
    }

    # Process XML String
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_extension_attribute>"
    $xmlString += "<name>$($ExtensionAttribute.name)</name>"
    $xmlString += "<description>$($ExtensionAttribute.description)</description>"
    $xmlString += "<data_type>$($ExtensionAttribute.data_type)</data_type>"
    $xmlString += "<input_type><type>$($ExtensionAttribute.input_type.type)</type></input_type>"
    $xmlString += "<inventory_display>$($ExtensionAttribute.inventory_display)</inventory_display>"
    $xmlString += "<recon_display>$($ExtensionAttribute.recon_display)</recon_display>"
    $xmlString += "</computer_extension_attribute>"

    Write-Host "Attempting to parse $xmlString"
    $body = New-Object System.Xml.XmlDocument
    $body.LoadXml($xmlString)

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
    $response = Invoke-RestMethod $URI -Method Put -Headers $headers -ContentType 'application/xml' -Body $body
    return $response.computer_extension_attribute
}