############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/post_v1-categories
function New-Category
{
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

        [Parameter(Position = 1,
            Mandatory)]
        [String]$Name,

        [Parameter(Position = 1,
            Mandatory)]
        [Int]$Priority
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