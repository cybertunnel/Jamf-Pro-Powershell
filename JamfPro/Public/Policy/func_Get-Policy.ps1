############################
# API Type: Legacy / Classic
# --------------------------
# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyname
# - Subset: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyidsubset
# - Subset by Name: https://developer.jamf.com/jamf-pro/reference/findpoliciesbynamesubset
function Get-Policy
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

        [Parameter(Position = 4,
            ParameterSetName='single')]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Subset,

        [Parameter(Position = 3,
            ParameterSetName='all')]
        [Switch]$All,

        [Parameter(Position = 4,
            ParameterSetName='all')]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Category
    )

    $URI_PATH = "JSSResource/policies"
    $URI = "$Server/$URI_PATH"

    if (-not $All)
    {
        if (-not $null -eq $Id)
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

        if (-not $null -eq $Subset)
        {
            $URI += "/subset/$Subset"
        }
    }
    else
    {
        if (-not $null -eq $Category)
        {
            $URI += "/category/$Category"
        }
    }
    $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Method Get -Headers $headers

    if ($All)
    {
        return $response.policies
    }
    else
    {
        return $response.policy
    }
}