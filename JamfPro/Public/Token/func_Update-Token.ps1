function Update-Token
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token
    )

    $URI = "$Server/api/v1/auth/keep-alive"

    $headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Method Post -Headers $headers

    return $response
}