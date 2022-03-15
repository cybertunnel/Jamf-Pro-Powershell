function Get-Computers
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][switch]$totalCount,
        [Parameter(Position = 3, Mandatory = $false)][int]$page
    )

    # TODO: Validate URL path
    # TODO: Add paging
    if ($null -eq $page)
    {
        Write-Host "Page is not set, grabbing the default page..."
        $URI = "$Server/api/v1/computers-inventory"
    }
    else {
        $URI = "$Server/api/v1/computers-inventory?page=$page"
    }
    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET -ContentType "application/json;charset=UTF-8"

    if ($totalCount) {
        return $response.totalCount
    } else {
        return $response.results
    }
}