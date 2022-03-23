function Get-PreStages
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Scope,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$totalCount,
        [Parameter(Position = 1, Mandatory = $false)][Int]$page,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Computer
    )

    if (-not $Computer)
    {
        throw "A prestage type must be provided. Currently supported prestages: `"-Computer`""
    }

    $URI = "$Server/api/v2/computer-prestages"

    if (-not $null -eq $page -and $null -eq $Scope)
    {
        $URI += "?page=$page"
    }
    elseif ($Scope)
    {
        $URI += "/scope"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET -ContentType "application/json;charset=UTF-8"


    if (-not $Scope) {
        if ($totalCount) {
            return $response.totalCount
        } else {
            return $response.results
        }
    }
    else
    {
        return $response.serialsByPrestageId
    }
}