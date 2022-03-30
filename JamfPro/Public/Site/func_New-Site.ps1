# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/createsitebyid
function New-Site
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $true)][String]$Name
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites/id/-1"
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><site><name>$Name</name></site>"

    $body = New-Object System.Xml.XmlDocument
    $body.LoadXml($xmlString)

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Post -Headers $headers -Credential $Credential -Authentication Basic -ContentType "application/xml" -Body $body
        return $response.site
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Post -Headers $headers -ContentType "application/xml" -Body $body
        return $response.site
    }
}