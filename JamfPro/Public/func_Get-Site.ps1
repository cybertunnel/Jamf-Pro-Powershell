function Get-Site
{
    Param(
        [Parameter(Position = 1, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 0, Mandatory = $false)][int]$Id,
        [Parameter(Position = 0, Mandatory = $false)][string]$Name
    )

    if ($null -eq $Credential)
    {
        # Prompt for credentials if none are provided
        $Credential = Get-Credential
    }

    if (-not [String]::IsNullOrEmpty($Id))
    {
        $URI = "$Server/JSSResource/sites/id/$Id"
    }
    elseif (-not [String]::IsNullOrEmpty($Name))
    {
        $URI = "$Server/JSSResource/sites/name/$Name"
    }
    else
    {
        Throw "Either a -Id or -Name must be provided to fetch the proper site object."
    }
    Write-Host "Attempting to get content from $URI"
    $response = Invoke-RestMethod $URI -Method Get -Authentication Basic -Credential $Credential -ContentType 'application/xml;charset=UTF-8'

    return $response.site
}