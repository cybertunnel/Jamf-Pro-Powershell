function Get-Group
{
    Param(
        [Parameter(Position = 4, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][String]$Token,
        [Parameter(Position = 0, Mandatory = $false)][String]$Id,
        [Parameter(Position = 0, Mandatory = $false)][String]$Name
    )

    if (-not $Computer)
    {
        throw "A group type flag must be provided. Supported groups: `"-Computer`"."
    }

    if ($null -eq $Id -and $null -eq $Name)
    {
        throw "An `"-Id`" or `"-Name`" must be provided."
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    # Generate the URI
    if ($Computer)
    {
        if (-not $null -eq $Id)
        {
            $URI = "$Server/JSSResource/computergroups/id/$Id"
        }
        elseif (-not $null -eq $Name) {
            $URI = "$Server/JSSResource/computergroups/name/$Name"
        }
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

    return $response.computer_group
}