# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/createsitebyid
function New-Site
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

        [Parameter(Position = 2,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name
    )

    $URI = "$Server/JSSResource/sites/id/-1"

    # Need pscustomobject for the conversion
    $Body = [pscustomobject]@{
        "name" = $Name
    }

    $Body = ConvertTo-JamfXML -JamfObject $Body -ParentElementName 'site'
    Write-Host "Body: $Body.innerXml"

    $Headers = @{"Authorization" = "Bearer $Token"}
    write-host "URI $URI"
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body.innerXml -ContentType 'application/xml'

    write-host "Response $response"

    $response = Get-Site -Server $Server -Token $token -Name $Name
    return $response
}