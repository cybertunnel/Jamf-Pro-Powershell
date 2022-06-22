############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer by ID: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyid
# - Computer by Name: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyname
# - Subset of Computer by ID: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyidsubset
# - Subset of Computer by Name: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbynamesubset

function Get-ConfigurationProfile
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

        [Parameter(Position = 2)]
        [Switch]$Computer,

        [Parameter(Position = 3,
            ParameterSetName='all')]
        [Switch]$All
    )

    $URI_PATH = "JSSResource/osxconfigurationprofiles"
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
        return $response.os_x_configuration_profiles
    }
    else
    {
        return $response.os_x_configuration_profile
    }
}