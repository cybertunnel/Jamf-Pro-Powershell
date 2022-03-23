function Get-Sites
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 6, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 6, Mandatory = $false)][String]$Token
    )

    if ($null -eq $Credential -and $null -eq $Token)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites"

    Write-Host "Attempting to get content from $URI"

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers -Credential $Credential -Authentication Basic
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers
    }

    return $response.sites
}