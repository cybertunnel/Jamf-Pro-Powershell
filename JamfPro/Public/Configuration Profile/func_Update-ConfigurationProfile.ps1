############################
# API Type: Legacy / Classic
# --------------------------
function Update-ConfigurationProfile
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

        # Type
        [Parameter(Position = 2)]
        [Switch]$Computer,

        # Profile Object
        [Parameter(Position =3 ,
            Mandatory)]
        [PSCustomObject]$ConfigurationProfile
    )

    if ($Computer)
    {
        $URI_PATH = "JSSResource/osxconfigurationprofiles"
    }
    else
    {
        throw 'No other supported profiles at this time.'
    }
    write-host "URI path: $URI_PATH"
    $URI = "$Server/$URI_PATH"

    # Check if proifle exists
    try
    {
        Get-ConfigurationProfile -Computer -Id $ConfigurationProfile.general.id -Server $Server -Token $token
        $URI += "/id/$($ConfigurationProfile.general.id)"
    }
    catch
    {
        throw 'Configuration Profile does not exist'
    }

    $xml = ConvertTo-JamfXML -ParentElementName "os_x_configuration_profile" -JamfObject $ConfigurationProfile
    $body = $xml.innerXml

    Write-Host "Processing request to $URI using body of $body"

    $headers = @{"Authorization" = "Bearer $token"}

    Invoke-RestMethod $URI -Method Put -ContentType "application/xml" -Headers $headers -Body $body

    return $ConfigurationProfile
}