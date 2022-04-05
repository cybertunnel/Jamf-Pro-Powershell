# Documentation Reference:
# - Computer by ID: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyid
# - Computer by Name: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyname
# - Subset of Computer by ID: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbyidsubset
# - Subset of Computer by Name: https://developer.jamf.com/jamf-pro/reference/findosxconfigurationprofilesbynamesubset

function Get-ConfigurationProfile
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][Int]$Id,
        [Parameter(Position = 2, Mandatory = $false)][String]$Name,
        [Parameter(Position = 2, Mandatory = $false)][Switch]$Computer
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

    if (-not $null -eq $Id)
    {
        $URI = "$Server/JSSResource/osxconfigurationprofiles/id/$Id"
    }
    elseif (-not $null -eq $Name)
    {
        $URI = "$Server/JSSResource/osxconfigurationprofiles/name/$Name"
    }
    else
    {
        throw "Either a `"-Id`" or `"-Name`" must be provided."
    }

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

    return $response.os_x_configuration_profile

    return
}