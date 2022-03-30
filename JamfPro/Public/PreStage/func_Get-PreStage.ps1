# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/get_v2-computer-prestages-id
# - Scope: https://developer.jamf.com/jamf-pro/reference/get_v2-computer-prestages-id-scope
function Get-PreStage
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Scope,
        [Parameter(Position = 1, Mandatory = $true)][Switch]$Computer
    )

    if (-not $Computer)
    {
        throw "A Pre-Stage type must be provided. Currently supported types: `"-Computer`""
    }

    $URI = "$Server/api/v2/computer-prestages/$Id"

    if ($Scope)
    {
        $URI += "/scope"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response
}