function Update-Site
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $true)][Int]$Id
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites/id/$Id"
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><site><name>$Name</name></site>"

    $body = New-Object system.Xml.XmlDocument
    $body.LoadXml($xmlString)

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"
            "Accept" = "application/json"    
        }
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Headers $headers -Body $body
        return $response.site

    }
    else {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
        return $response.site
    }
    
    return
}