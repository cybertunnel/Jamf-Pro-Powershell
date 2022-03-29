# Documentation Reference:
# - Delete multiple: https://developer.jamf.com/jamf-pro/reference/post_v1-buildings-delete-multiple
# - Delete single: https://developer.jamf.com/jamf-pro/reference/delete_v1-buildings-id
function Remove-Building
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Int[]]$Ids
    )

    if (-not $null -eq $Ids)
    {
        # Delete multiple
        $URI = "$Server/api/v1/buildings/delete-multiple"
        $body = ConvertTo-Json $Ids
        
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Post -ContentType 'application/json' -Body $body
    }
    elseif (-not $null -eq $Id)
    {
        # Delete single
        $URI = "$Server/api/v1/buildings/$Id"
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Delete
    }
    else
    {
        throw 'An "-Id" or "-Ids" must be provided.'
    }

    return
}