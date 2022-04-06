# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/delete_v2-computer-prestages-id
function Remove-PreStage
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

        [Parameter(Position = 1,
            Mandatory,
            ParameterSetName ='single')]
        [ValidateScript({ $_ -is [Int] -and $_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 5,
            Mandatory)]
        [ValidateSet('Computer', 'Mobile')]
        [String]$Type
    )

    if ($Type -eq 'Computer')
    {
        $URI_PATH = "api/v2/computer-prestages"
    }
    elseif ($Type -eq 'Mobile')
    {
        $URI_PATH = "api/v2/mobile-device-prestages"
    }

    $URI = "$Server/$URI_PATH/$Id"

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    Invoke-RestMethod $URI -Headers $Headers -Method Delete

    return
}