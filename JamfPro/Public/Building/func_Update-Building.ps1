############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/put_v1-buildings-id
# - https://developer.jamf.com/jamf-pro/reference/post_v1-buildings-id-history
function Update-Building
{
    [CmdletBinding(DefaultParameterSetName='objectUpdate')]
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

        [Parameter(Position = 2, Mandatory)]
        [Int]$Id,
        
        [Parameter(Position = 3,
            ParameterSetName='historyUpdate')]
        [String]$History,
        
        [Parameter(Position = 3,
            Mandatory,
            ParameterSetName='objectUpdate')]
        [pscustomobject]$Building
    )

    $URI_PATH = "api/v1/buildings"
    $URI = "$Server/$URI_Path"
    $URI += "$Id"

    $Headers = @{"Authorization" = "Bearer $Token"}

    if (-not $null -eq $History)
    {
        $URI += "/history"
        $Body = @{"note" = $History}
        $Body = ConvertTo-Json $Body

        Invoke-RestMethod $URI -Headers $Headers -Method Post -ContentType 'application/json' -Body $Body
    }
    elseif (-not $null -eq $Building)
    {
        $Body = ConvertTo-Json $Building

        Invoke-RestMethod $URI -Headers $Headers -Method Put -ContentType 'application/json' -Body $Body
    }
    else
    {
        throw 'Either a -Building or -History has to be provided.'
    }

    

    return
}