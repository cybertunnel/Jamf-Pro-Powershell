############################
# API Type: Legacy / Classic
# --------------------------
function Update-Policy
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

        # Policy object
        [Parameter(Position = 2,
            Mandatory)]
        [ValidateScript({$_ -is [PSCustomObject]})]
        [PSCustomObject]$Policy
    )

    $URI_PATH = "JSSResource/policies"
    $URI = "$Server/$URI_PATH"

    # Check if policy exists
    try
    {
        $URI += "/id/$($Policy.general.id)"
        Get-Policy -Id $Policy.general.id -Server $Server -Token $token
    }
    catch
    {
        throw 'Policy does not exist'
    }

    $xml = ConvertTo-JamfXML -ParentElementName "policy" -JamfObject $policy
    $body = $xml.innerXml

    Write-Host "Processing request to $URI using body of $body"

    $headers = @{"Authorization" = "Bearer $token"}

    Invoke-RestMethod $URI -Method Put -ContentType "application/xml" -Headers $headers -Body $body

    return $Policy
}