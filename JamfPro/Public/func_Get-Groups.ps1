function Get-Groups
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 2, Mandatory = $false)][switch]$User,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Mobile,
        [Parameter(Position = 4, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 5, Mandatory = $false)][switch]$refresh
    )

    if ($Computer)
    {
        $storedData = $global:ComputerGroups | Where-Object {$_.Server -eq $Server} | Select-Object "data"
    }

    if ((-not $null -eq $storedData) -and (-not $refresh))
    {
        return $storedData.data
    }

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups"
    }
    elseif ($User)
    {
        $URI = "$Server/JSSResource/mobiledevicegroups"
    }
    elseif ($Mobile)
    {
        $URI = "$Server/JSSResource/usergroups"
    }
    else
    {
        Throw "Group type not specified, one of -Computer, -User, or -Mobile flags must be used to specify which groups you want to pull."
    }

    Write-Host "Attempting to call on $URI"
    $response = Invoke-RestMethod $URI -Method Get -Authentication Basic -Credential $Credential -ContentType 'application/xml;charset=UTF-8'

    $global:ComputerGroups = @{"Server" = $Server
    "data" = $response.computer_groups
    }
    return $response.computer_groups
}