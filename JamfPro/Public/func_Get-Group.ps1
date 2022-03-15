function Get-Group
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][String]$Id,
        [Parameter(Position = 2, Mandatory = $false)][String]$Name,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 4, Mandatory = $false)][switch]$User,
        [Parameter(Position = 5, Mandatory = $false)][switch]$Mobile,
        [Parameter(Position = 6, Mandatory = $false)][pscredential]$Credential
    )

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    if ($Computer)
    {
        if (-not [String]::IsNullOrEmpty($Id))
        {
            $URI = "$Server/JSSResource/computergroups/id/$Id"
        }
        elseif (-not [String]::IsNullOrEmpty($Name))
        {
            $URI = "$Server/JSSResource/computergroups/name/$Name"
        }
        else
        {
            Throw "Either a -Name or a -Id must be provided for the specific group you wish to pull"
        }
    }
    elseif ($User)
    {
        if (-not [String]::IsNullOrEmpty($Id))
        {
            $URI = "$Server/JSSResource/mobiledevicegroups/id/$Id"
        }
        elseif (-not [String]::IsNullOrEmpty($Name))
        {
            $URI = "$Server/JSSResource/mobiledevicegroups/name/$Name"
        }
        else
        {
            Throw "Either a -Name or a -Id must be provided for the specific group you wish to pull"
        }
    }
    elseif ($Mobile)
    {
        if (-not [String]::IsNullOrEmpty($Id))
        {
            $URI = "$Server/JSSResource/usergroups/id/$Id"
        }
        elseif (-not [String]::IsNullOrEmpty($Name))
        {
            $URI = "$Server/JSSResource/usergroups/name/$Name"
        }
        else
        {
            Throw "Either a -Name or a -Id must be provided for the specific group you wish to pull"
        }   
    }
    else
    {
        Throw "Group type not specified, one of -Computer, -User, or -Mobile flags must be used to specify which groups you want to pull."
    }

    Write-Host "Attempting to reach $URI"
    $response = Invoke-RestMethod $URI -Method Get -Authentication Basic -Credential $Credential -ContentType 'application/xml;charset=UTF-8'

    return $response
}