############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer Group: https://developer.jamf.com/jamf-pro/reference/createcomputergroupbyid
# - Mobile Group: https://developer.jamf.com/jamf-pro/reference/createmobiledevicegroupbyid
# - User Group: https://developer.jamf.com/jamf-pro/reference/createusergroupsbyid
function New-Group
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
        [Parameter(ParameterSetName='all')]
        [Switch]$Computer,
        
        [Parameter(Position = 3,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name,
        
        [Parameter(Position = 4,
            Mandatory)]
        [ValidateSet('Smart', 'Static')]
        [String]$Type,
        
        [Parameter(Position = 4,
            Mandatory)]
        [ValidateScript({})]
        [String]$SiteId,
        
        [Parameter(Position = 4,
            Mandatory)]
        [ValidateSet('Smart', 'Static')]
        [String]$SiteName,
        
        [Parameter(Position = 4)]
        [ValidateScript({$_ -is [Array]})]
        [String]$Criteria,

        [Parameter(Position = 4)]
        [ValidateScript({$_ -is [Array]})]
        [String]$Computers
    )

    $URI_PATH = "JSSResource/computerextensionattributes"
    $URI = "$Server/$URI_PATH"

    # -1 is used for 
    $URI += "/id/-1"

    # Process XML String
    $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_group>"
    $xmlString += "<name>$Name</name>"
    $xmlString += "<is_smart>$(($Type -eq "Smart").ToString())</is_smart>"
    $xmlString += "<site>"
    if ($null -eq $SiteId -and $null -eq $SiteName)
    {
        $xmlString += "<id>-1</id>"
    }
    elseif (-not $null -eq $SiteId)
    {
        $xmlString += "<id>$SiteId</id>"
    }
    elseif (-not $null -eq $SiteName)
    {
        $xmlString += "<name>$SiteName</name>"
    }
    $xmlString += "</site>"
    $xmlString += "<criteria>"
    foreach ($criterion in $Criteria)
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

    $headers = @{"Accept" = "application/json"}
    $response = Invoke-RestMethod $URI -Method Post -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
    return $response.computer_group
}