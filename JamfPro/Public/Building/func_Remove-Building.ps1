############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - Delete multiple: https://developer.jamf.com/jamf-pro/reference/post_v1-buildings-delete-multiple
# - Delete single: https://developer.jamf.com/jamf-pro/reference/delete_v1-buildings-id
function Remove-Building
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
            ParameterSetName='single',
            Mandatory)]
        [ValidateScript({ $_ -is [Int] -and $_ -gt 0})]
        [Int]$Id,
        
        [Parameter(Position = 2,
            ParameterSetName='multiple',
            Mandatory)]
        [ValidateScript({ $_ -is [Array] -and $_.count -gt 0})]
        [Int[]]$Ids
    )

    $URI_PATH = "api/v1/buildings"
    $URI = "$Server/$URI_PATH"

    if (-not $null -eq $Ids)
    {
        # Delete multiple
        $URI += "/delete-multiple"
        $body = ConvertTo-Json $Ids
        
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Post -ContentType 'application/json' -Body $body
    }
    elseif (-not $null -eq $Id)
    {
        # Delete single
        $URI += "/$Id"
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Delete
    }
    else
    {
        throw 'An "-Id" or "-Ids" must be provided.'
    }

    return
}