# Documentation Reference:
# - Computer Profiles: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofiles
# - Mobile Profiles: 
function Get-ConfigurationProfiles
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][switch]$Computer
    )

    if (-not $Computer)
    {
        throw "An extension attribute type flag must be provided. Supported extension attributes: `"-Computer`"."
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/osxconfigurationprofiles"

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers -Credential $Credential -Authentication Basic
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers
    }

    return $response.os_x_configuration_profiles
}