function New-Site
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 2, Mandatory = $true)][pscredential]$Credential
    )

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites/id/-1"

    $Content = New-Object system.Xml.XmlDocument
    $Content.LoadXml("<?xml version=`"1.0`" encoding=`"utf-8`"?><site><name>$name</name></site>")

    $response = Invoke-RestMethod $URI -Method Post -Authentication Basic -Credential $Credential -ContentType "application/xml" -Body $Content

    return $response.site
}