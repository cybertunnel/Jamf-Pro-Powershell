function Remove-Token {
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token
    )

    $URI = "$Server/api/v1/auth/invalidate-token"

    $headers = @{'Authorization' = "Bearer $Token"}

    Invoke-RestMethod $URI -Method Post -Headers $headers
}