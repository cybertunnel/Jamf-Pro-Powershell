# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/put_v1-scripts-id
# - History: https://developer.jamf.com/jamf-pro/reference/post_v1-scripts-id-history
function Update-Script
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][String]$History,
        [Parameter(Position = 1, Mandatory = $false)][pscustomobject]$Script
    )

    $URI = "$Server/api/v1/scripts/$Id"
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