# Documentation Reference:
# - Single by ID: https://developer.jamf.com/jamf-pro/reference/delete_v1-departments-id
# - Multiple IDs: https://developer.jamf.com/jamf-pro/reference/post_v1-departments-delete-multiple
function Remove-Department
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

        [Parameter(Position = 1,
            Mandatory,
            ParameterSetName ='single')]
        [ValidateScript({ $_ -is [Int] -and $_ -gt 0})]
        [Int]$Id,
        
        [Parameter(Position = 1,
            ParameterSetName = 'multiple')]
        [ValidateScript({ $_ -is [Array] -and $_.count -gt 0})]
        [Int[]]$Ids
    )

    if (-not $null -eq $Ids)
    {
        # Delete multiple
        $URI = "$Server/api/v1/departments/delete-multiple"
        $body = ConvertTo-Json $Ids
        
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Post -ContentType 'application/json' -Body $body
    }
    elseif (-not $null -eq $Id)
    {
        # Delete single
        $URI = "$Server/api/v1/departments/$Id"
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Delete
    }
    else
    {
        throw 'An "-Id" or "-Ids" must be provided.'
    }

    return
}