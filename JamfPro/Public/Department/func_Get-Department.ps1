function Get-Department
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$History
    )

    $URI = "$Server/api/v1/departments/$Id"

    if ($History)
    {
        $URI += "/history"
    }

    if (-not $null -eq $Page -and -not $History)
    {
        $URI += "?page=$Page"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response
}