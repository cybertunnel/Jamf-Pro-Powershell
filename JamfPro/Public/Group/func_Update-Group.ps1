############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer Group by ID: https://developer.jamf.com/jamf-pro/reference/updateusergroupsbyid
# - Computer Group by Name: https://developer.jamf.com/jamf-pro/reference/updateusergroupsbyname
# - Mobile Group by ID: https://developer.jamf.com/jamf-pro/reference/updatemobiledevicegroupbyid
# - Mobile Group by Name: https://developer.jamf.com/jamf-pro/reference/updatemobiledevicegroupbyname
# - User Group by ID: https://developer.jamf.com/jamf-pro/reference/updatecomputergroupbyid
# - User Group by Name: https://developer.jamf.com/jamf-pro/reference/updatecomputergroupbyname
function Update-Group
{
    Param(
        # Jamf Pro server
        [Parameter(Position = 0,
        Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
        Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        [Parameter(Position = 2)]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 3)]
        [Switch]$Computer,

        [Parameter(Position = 4)]
        [PSCustomObject]$ExtensionAttribute
    )
    $URI_PATH = "JSSResource/computergroups"
    $URI = "$Server/$URI_PATH"
    $URI += "/id/$Id"

    if (-not $Computer)
    {
        throw "A Computer Group type must be provided. Currently supported types: `"-Computer`""
    }

    # Process XML String
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_group>"
    $xmlString += "<name>$($ExtensionAttribute.name)</name>"
    $xmlString += "<is_smart>$($ExtensionAttribute.is_smart)</is_smart>"
    $xmlString += "<site>"
    if ($null -eq $ExtensionAttribute.site.id -and $null -eq $ExtensionAttribute.site.name)
    {
        $xmlString += "<id>-1</id>"
    }
    elseif (-not $null -eq $ExtensionAttribute.site.id)
    {
        $xmlString += "<id>$SiteId</id>"
    }
    elseif (-not $null -eq $ExtensionAttribute.site.name)
    {
        $xmlString += "<name>$SiteName</name>"
    }
    $xmlString += "</site>"
    $xmlString += "<criteria>"
    foreach ($criterion in $ExtensionAttribute.criteria)
    {
        $xmlString += "<criterion>"
        $xmlString += "<name>$($criterion.name)</name>"
        $xmlString += "<priority>$($criterion.priority)</priority>"
        $xmlString += "<and_or>$($criterion.and_or)</and_or>"
        $xmlString += "<search_type>$($criterion.search_type)</search_type>"
        $xmlString += "<value>$($criterion.value)</value>"
        $xmlString += "<opening_paren>$($criterion.opening_paren)</opening_paren>"
        $xmlString += "<closing_paren>$($criterion.closing_paren)</closing_paren>"
        $xmlString += "</criterion>"
    }
    $xmlString += "</criteria>"
    $xmlString += "</computer_group>"

    Write-Host "Attempting to parse $xmlString"
    $body = New-Object System.Xml.XmlDocument
    $body.LoadXml($xmlString)

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
    $response = Invoke-RestMethod $URI -Method Put -Headers $headers -ContentType 'application/xml' -Body $body
    return $response.computer_group
}