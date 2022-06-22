############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer EA by ID: https://developer.jamf.com/jamf-pro/reference/findcomputerextensionattributesbyid
# - Computer EA by Name: https://developer.jamf.com/jamf-pro/reference/findcomputerextensionattributesbyname
# - Mobile EA by ID: https://developer.jamf.com/jamf-pro/reference/findmobiledeviceextensionattributesbyid
# - Mobile EA by Name: https://developer.jamf.com/jamf-pro/reference/findmobiledeviceextensionattributesbyname
# - User EA by ID: https://developer.jamf.com/jamf-pro/reference/finduserextensionattributesbyid
# - User EA by Name: https://developer.jamf.com/jamf-pro/reference/finduserextensionattributesbyname
function Get-ExtensionAttribute
{
    Param(
        [CmdletBinding(DefaultParameterSetName='single')]
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
        
        [Parameter(Position = 3,
            ParameterSetName='single')]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 3,
            ParameterSetName='single')]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name,

        [Parameter(Position = 2,
            ParameterSetName='single')]
        [Parameter(ParameterSetName='all')]
        [Switch]$Computer,

        [Parameter(Position = 3,
            ParameterSetName='all')]
        [Switch]$All
    )

    $URI_PATH = "JSSResource/computerextensionattributes"
    $URI = "$Server/$URI_PATH"

    if (-not $Computer)
    {
        throw "An extension attribute type flag must be provided. Supported extension attributes: `"-Computer`"."
    }

    if (-not $All)
    {
        if ($Id -gt 0)
        {
            $URI += "/id/$Id"
        }
        elseif (-not $null -eq $Name)
        {
            $URI += "/name/$Name"
        }
        else
        {
            throw "Either a `"-Id`" or `"-Name`" must be provided."
        }
    }
    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Method Get -Headers $headers

    if ($All)
    {
        return $response.computer_extension_attributes
    }
    else
    {
        return $response.computer_extension_attribute
    }
}