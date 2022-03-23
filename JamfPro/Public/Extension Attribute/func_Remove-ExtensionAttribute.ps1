function Remove-ExtensionAttribute
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][Int]$Id,
        [Parameter(Position = 2, Mandatory = $false)][Switch]$Computer
    )

    if (-not $Computer)
    {
        throw "A Extension Attribute type must be provided. Currently supported types: `"-Computer`""
    }

    $URI = "$Server/JSSResource/computerextensionattributes/id/$Id"

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers -Credential $Credential -Authentication Basic
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
    }

    return $response
}