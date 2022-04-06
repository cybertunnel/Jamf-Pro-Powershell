############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer EA: https://developer.jamf.com/jamf-pro/reference/createcomputerextensionattributebyid
# - Mobile EA: https://developer.jamf.com/jamf-pro/reference/createmobiledeviceextensionattributebyid
# - User EA: https://developer.jamf.com/jamf-pro/reference/createuserextensionattributebyid
function New-ExtensionAttribute
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
        [Parameter(ParameterSetName='all')]
        [Switch]$Computer,
        
        [Parameter(Position = 3,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name,
        
        [Parameter(Position = 4,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Description,
        
        [Parameter(Position = 5,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$DataType,
        
        [Parameter(Position = 6,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$InputType,
        
        [Parameter(Position = 7,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$InventoryDisplay,
        
        [Parameter(Position = 8,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$ReconDisplay
    )

    $URI_PATH = "JSSResource/computerextensionattributes"
    $URI = "$Server/$URI_PATH"

    # -1 is used for 
    $URI += "/id/-1"

    # Process XML String
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_extension_attribute>"
    $xmlString += "<name>$Name</name>"
    $xmlString += "<description>$Description</description>"
    $xmlString += "<data_type>$DataType</data_type>"
    $xmlString += "<input_type><type>$Type</type></input_type>"
    $xmlString += "<inventory_display>$InventoryDisplay</inventory_display>"
    $xmlString += "<recon_display>$ReconDisplay</recon_display>"
    $xmlString += "</computer_extension_attribute>"

    Write-Host "Attempting to parse $xmlString"
    $body = New-Object System.Xml.XmlDocument
    $body.LoadXml($xmlString)

    $headers = @{"Accept" = "application/json"}
    $response = Invoke-RestMethod $URI -Method Post -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
    return $response.computer_extension_attribute
}