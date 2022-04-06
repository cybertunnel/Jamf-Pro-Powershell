# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/post_v1-departments
function New-Department
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
        
        [Parameter(Position = 2,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name
    )

    $URI = "$Server/api/v1/departments"

    $Body = @{
        "name" = $Name
    }

    $Body = ConvertTo-Json $Body

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body -ContentType 'application/json'

    $response = Get-Department -Server $Server -Token $token -Id $response.id
    return $response
}