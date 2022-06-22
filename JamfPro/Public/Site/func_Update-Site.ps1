# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/updatesitebyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/updatesitebyname
function Update-Site
{
    Param(
        [Parameter(Position = 0,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        # Profile Object
        [Parameter(Position =2 ,
            Mandatory)]
        [PSCustomObject]$Site
    )

    $URI = "$Server/JSSResource/sites/id/$($Site.id)"
    $obj = [pscustomobject]@{"name" = $Site.name}
    $xml = ConvertTo-JamfXML -JamfObject $obj -ParentElementName 'site'
    $body = $xml.innerXml

    $headers = @{"Authorization" = "Bearer $token"}
    $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Headers $headers -Body $body
    return $response.site
}