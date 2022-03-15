function New-Token
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server
    )

    $creds = Get-Credential

    $URI = "$Server/api/v1/auth/token"

    $response = Invoke-RestMethod $URI -Credential $creds -Authentication Basic -Method POST -ContentType "application/json;charset=UTF-8"

    return $response
}