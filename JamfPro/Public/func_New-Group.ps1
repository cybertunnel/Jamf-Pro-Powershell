function New-Group
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 2, Mandatory = $true)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][switch]$is_smart,
        [Parameter(Position = 4, Mandatory = $false)][Site]$site,
        [Parameter(Position = 5, Mandatory = $false)][Criterion[]]$criteria,
        [Parameter(Position = 6, Mandatory = $false)][String]$Computers,
        [Parameter(Position = 7, Mandatory = $false)][switch]$Computer
    )

    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups/id/-1"
    }
    else
    {
        Throw "You must have a -Computer flag turned on to create a computer group"
    }

    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_group><name>$name</name><is_smart>$is_smart</is_smart></computer_group>"

    $body = New-Object system.Xml.XmlDocument
    $body.LoadXml($xmlString)

    $response = Invoke-RestMethod $URI -Method Post -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body

    return $response.computer_group
}