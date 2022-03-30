# Documentation Reference:
# - Remove all: https://developer.jamf.com/jamf-pro/reference/post_v2-inventory-preload-records-delete-all
# - Remove by ID: https://developer.jamf.com/jamf-pro/reference/delete_v2-inventory-preload-records-id
function Remove-PreloadRecord
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $false)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$All
    )

    if ($All)
    {
        $confirm = Read-Host "Wish to delete all records in Inventory Preloads on $Server?(y/N)"

        if ($confirm -eq 'y' -or $confirm -eq 'Y' -or $confirm -eq 'Yes' -or $confirm -eq 'yes')
        {
            $URI = "$Server/api/v2/inventory-preload/records/delete-all"
        }
        else
        {
            throw 'Confirmation to delete all entries was not made, no data was deleted.'
        }

        $Headers = @{"Authorization" = "Bearer $Token"}
    
        $response = Invoke-RestMethod $URI -Headers $Headers -Method Post

        return $response
    }

    if (-not $null -eq $Id)
    {
        $URI = "$Server/api/v2/inventory-preload/records/$Id"
    }
    else
    {
        throw 'An "-Id" must be provided.'
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Delete

    return $response
}