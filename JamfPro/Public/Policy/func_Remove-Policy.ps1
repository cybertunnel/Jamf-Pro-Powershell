############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
function Remove-Policy
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


        [Parameter(Position = 2)]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id
    )

    $URI_PATH = "JSSResource/policies"
    $URI = "$Server/$URI_PATH"

    $URI += "/id/$Id"

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
    $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
    return $response
}