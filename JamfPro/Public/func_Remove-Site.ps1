function Remove-Site
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][int]$Id
    )

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    if ([Int]::IsNullOrEmpty)
    {
        Throw "Site's ID must be provided to -Id to delete the site"
    }
    else {
        $URI = "$server/JSSResource/sites/id/$Id"
    }

    $response = Invoke-RestMethod $URI -Method Delete -Credential $Credential -Authentication Basic

    return $response

}