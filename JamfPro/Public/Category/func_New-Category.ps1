# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/post_v1-categories
function New-Category
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Priority
    )

    $URI = "$Server/api/v1/categories"

    $Body = @{
        "name" = $Name
        "priority" = $Priority
    }

    $Body = ConvertTo-Json $Body

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body -ContentType 'application/json'

    $response = Get-Category -Server $Server -Token $token -Id $response.id
    return $response
}