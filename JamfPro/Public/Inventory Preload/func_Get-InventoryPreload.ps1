function Get-InventoryPreload
{
    Param(
        [CmdletBinding(DefaultParameterSetName='csv')]
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
            ParameterSetName='csv')]
        [Switch]$csv,

        [Parameter(Position = 1,
            ParameterSetName='template')]
        [Switch]$Template,

        [Parameter(Position = 1,
            ParameterSetName='history')]
        [Switch]$History,

        [Parameter(Position = 1,
            ParameterSetName='columns')]
        [Switch]$Columns
    )

    $URI_PATH = "api/v2/inventory-preload"
    $URI = "$Server/$URI_PATH"

    if ($csv)
    {
        $URI += "/csv"
    }
    elseif ($Template)
    {
        $URI += "/csv-template"
    }
    elseif ($Columns)
    {
        $URI += "/ea-columns"
    }
    elseif ($History)
    {
        $URI += "/history"
    }

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"}
    Write-Host "Current URI: $URI"
    $response = Invoke-RestMethod $URI -Method Get -Headers $headers

    return $response
}