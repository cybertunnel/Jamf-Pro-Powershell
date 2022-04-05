############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/get_v1-buildings-id
# - https://developer.jamf.com/jamf-pro/reference/get_v1-buildings-id-history
function Get-Building
{
    [CmdletBinding(DefaultParameterSetName='single')]
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
            Mandatory,
            ParameterSetName='single')]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,
        
        [Parameter(Position = 3,
            ParameterSetName='single')]
        [Switch]$History,
        
        [Parameter(Position = 2,
            ParameterSetName='all')]
        [Switch]$All
    )

    $URI_PATH = "api/v1/buildings"

    if (-not $All)
    {
        $URI = "$Server/$URI_Path/$Id"

        if ($History)
        {
            $URI += "/history"
        }
    }
    else
    {
        $URI = "$Server/$URI_Path"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response
}