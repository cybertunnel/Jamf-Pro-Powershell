############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer Group by ID: https://developer.jamf.com/jamf-pro/reference/findcomputergroupsbyid
# - Computer Group by Name: https://developer.jamf.com/jamf-pro/reference/findcomputergroupsbyname
# - Mobile Group by ID: https://developer.jamf.com/jamf-pro/reference/findmobiledevicegroupsbyid
# - Mobile Group by Name: https://developer.jamf.com/jamf-pro/reference/findmobiledevicegroupsbyname
# - User Group by ID: https://developer.jamf.com/jamf-pro/reference/findusergroupsbyid
# - User Group by Name: https://developer.jamf.com/jamf-pro/reference/findusergroupsbyname
function Get-Group
{
    Param(
        [CmdletBinding(DefaultParameterSetName='single')]
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
        
        [Parameter(Position = 3,
            ParameterSetName='single')]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 3,
            ParameterSetName='single')]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Name,

        [Parameter(Position = 2,
            ParameterSetName='single')]
        [Parameter(ParameterSetName='all')]
        [ValidateSet('Computer', 'User', 'Mobile')]
        [String]$Type,

        [Parameter(Position = 3,
            ParameterSetName='all')]
        [Switch]$All
    )
    
    switch ($Type) {
        "Computer" {$URI_PATH = "JSSResource/computergroups"}
        "User" {$URI_PATH = "JSSResource/usergroups"}
        "Mobile" {$URI_PATH = "JSSResource/mobiledevicegroups"}
    }
    $URI = "$Server/$URI_PATH"

    if (-not $All)
    {
        if ($Id -gt 0)
        {
            $URI += "/id/$Id"
        }
        elseif (-not $null -eq $Name)
        {
            $URI += "/name/$Name"
        }
        else
        {
            throw "Either a `"-Id`" or `"-Name`" must be provided."
        }
    }
    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Method Get -Headers $headers

    switch ($Type) {
        "Computer" {
            if ($All)
            {
                return $response.computer_groups
            }
            else
            {
                return $response.computer_group
            }
        }
        "User" {
            if ($All)
            {
                return $response.user_groups
            }
            else
            {
                return $response.user_group
            }
        }
        "Mobile" {
            if ($All)
            {
                return $response.mobile_device_groups
            }
            else
            {
                return $response.mobile_device_group
            }
        }
    }
}