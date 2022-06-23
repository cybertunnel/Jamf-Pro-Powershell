############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - Computer Group by ID: https://developer.jamf.com/jamf-pro/reference/deletecomputergroupbyid
# - Computer Group by Name: https://developer.jamf.com/jamf-pro/reference/deletecomputergroupbyname
# - Mobile Group by ID: https://developer.jamf.com/jamf-pro/reference/deletemobiledevicegroupbyid
# - Mobile Group by Name: https://developer.jamf.com/jamf-pro/reference/deletemobiledevicegroupbyname
# - User Group by ID: https://developer.jamf.com/jamf-pro/reference/deleteusergroupsbyid
# - User Group by Name: https://developer.jamf.com/jamf-pro/reference/deleteusergroupsbyname
function Remove-Group
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

        [Parameter(Position = 2)]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 2,
            ParameterSetName='single')]
        [Parameter(ParameterSetName='all')]
        [ValidateSet('Computer', 'User', 'Mobile')]
        [String]$Type
    )

    switch ($Type) {
        "Computer" {$URI_PATH = "JSSResource/computergroups"}
        "User" {$URI_PATH = "JSSResource/usergroups"}
        "Mobile" {$URI_PATH = "JSSResource/mobiledevicegroups"}
    }
    $URI = "$Server/$URI_PATH"

    $URI += "/id/$Id"

    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
    $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
    return $response
}