function Get-Sites
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 6, Mandatory = $false)][pscredential]$Credential
    )

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites"

    Write-Host "Attempting to get content from $URI"

    $response = Invoke-RestMethod $URI -Method Get -Authentication Basic -Credential $Credential -ContentType 'application/xml;charset=UTF-8'

    return $response.sites
}