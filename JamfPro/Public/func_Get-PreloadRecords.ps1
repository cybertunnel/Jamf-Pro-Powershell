# Documentation Reference:
# - CSV: https://developer.jamf.com/jamf-pro/reference/get_v2-inventory-preload-csv
# - Columns: https://developer.jamf.com/jamf-pro/reference/get_v2-inventory-preload-ea-columns
# - History: https://developer.jamf.com/jamf-pro/reference/get_v2-inventory-preload-history
# - Records: https://developer.jamf.com/jamf-pro/reference/get_v2-inventory-preload-records
function Get-PreloadRecords
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$CSV,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Columns,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$History,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Records,
        [Parameter(Position = 1, Mandatory = $false)][Int]$Page
    )

    if ($CSV)
    {
        # Get CSV from the preload
        $URI = "$Server/api/v2/inventory-preload/csv"
    }
    elseif ($Columns)
    {
        # Get Columns from the preload
        $URI = "$Server/api/v2/inventory-preload/ea-columns"
    }
    elseif ($History)
    {
        # Get the history from the preload
        $URI = "$Server/api/v2/inventory-preload/history"
    }
    elseif ($Records)
    {
        # Get the records from the preload
        $URI = "$Server/api/v2/inventory-preload/records"

        if (-not $null -eq $Page)
        {
            $URI += "?page=$Page"
        }
    }
    else
    {
        throw 'You must provide one of the following "-CSV", "-Columns", "-History", "-Records".'
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response


}