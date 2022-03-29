function Get-Scripts
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $false)][Int]$Page
    )

    $URI = "$Server/api/v1/scripts"

    if (-not $null -eq $Page)
    {
        $URI += "?page=$Page"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response.results
}