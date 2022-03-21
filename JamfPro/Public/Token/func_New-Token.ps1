function New-Token
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][pscredential]$Credential
    )

    if ($null -eq $Credential)
    {
        $Credential = Get-Credential
    }

    $URI = "$Server/api/v1/auth/token"

    $response = Invoke-RestMethod $URI -Credential $Credential -Authentication Basic -Method POST -ContentType "application/json;charset=UTF-8"

    return $response
}