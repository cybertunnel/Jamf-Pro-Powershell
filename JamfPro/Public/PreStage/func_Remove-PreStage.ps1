# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/delete_v2-computer-prestages-id
function Remove-PreStage
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $true)][Switch]$Computer
    )

    if (-not $Computer)
    {
        throw "A Pre-Stage type must be provided. Currently supported types: `"-Computer`""
    }

    $URI = "$Server/api/v2/computer-prestages/$Id"

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    Invoke-RestMethod $URI -Headers $Headers -Method Delete

    return
}