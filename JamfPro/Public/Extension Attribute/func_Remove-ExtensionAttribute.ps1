############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer EA by ID: https://developer.jamf.com/jamf-pro/reference/deletecomputerextensionattributebyid
# - Computer EA by Name: https://developer.jamf.com/jamf-pro/reference/deletecomputerextensionattributebyname
# - Mobile EA by ID: https://developer.jamf.com/jamf-pro/reference/deletemobiledeviceextensionattributebyid
# - Mobile EA by Name: https://developer.jamf.com/jamf-pro/reference/deletemobiledeviceextensionattributebyname
# - User EA by ID: https://developer.jamf.com/jamf-pro/reference/deleteuserextensionattributebyid
# - User EA by Name: https://developer.jamf.com/jamf-pro/reference/deleteuserextensionattributebyname
function Remove-ExtensionAttribute
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
        [Switch]$Computer
    )

    $URI_PATH = "JSSResource/computerextensionattributes"
    $URI = "$Server/$URI_PATH"

    $URI += "/id/$Id"

    if (-not $Computer)
    {
        throw "A Extension Attribute type must be provided. Currently supported types: `"-Computer`""
    }

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
    $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
    return $response
}