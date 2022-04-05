############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/post_v1-buildings
function New-Building
{
    Param(
        # Jamf Pro Server
        [Parameter(Position = 0,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        [Parameter(Position = 2)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name,
        [Parameter(Position = 3, Mandatory = $true)][String]$StreetAddress1,
        [Parameter(Position = 4, Mandatory = $true)][String]$StreetAddress2,
        [Parameter(Position = 5, Mandatory = $true)][String]$City,
        [Parameter(Position = 6, Mandatory = $true)][String]$State,
        [Parameter(Position = 7, Mandatory = $true)][String]$ZipCode,
        [Parameter(Position = 8, Mandatory = $true)][String]$Country
    )

    $URI_PATH = "api/v1/buildings"

    $URI = "$Server/$URI_PATH"

    $Body = @{
        "name" = $Name
        "streetAddress1" = $StreetAddress1
        "streetAddress2" = $StreetAddress2
        "city" = $City
        "stateProvince" = $State
        "zipPostalCode" = $ZipCode
        "country" = $Country
    }

    $Body = ConvertTo-Json $Body

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body -ContentType 'application/json'

    $response = Get-Building -Server $Server -Token $token -Id $response.id
    return $response
}