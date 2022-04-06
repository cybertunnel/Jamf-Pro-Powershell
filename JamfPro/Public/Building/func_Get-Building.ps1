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
        [Switch]$All,

        [Parameter(Position = 2,
            ParameterSetName='page')]
        [ValidateScript({$_ -ge 0})]
        [Int]$Page,

        [Parameter(Position = 3,
            ParameterSetName='page')]
        [Parameter(ParameterSetName='all')]
        [ValidateScript({$_ -gt 0})]
        [Int]$PageSize = 100,
        
        [Parameter(Position = 4,
        ParameterSetName='page')]
        [Parameter(ParameterSetName='all')]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Filter
    )

    $URI_PATH = "api/v1/buildings"

    if ($null -eq $Id)
    {
        $URI = "$Server/$URI_PATH"
        $URI += "/$Id"

        if ($History)
        {
            $URI += "/history"
        }
    }
    else
    {
        $URI = "$Server/$URI_PATH"

        if ($All)
        {
            # Process pages
            write-host "Pulling all data"
            $Headers = @{"Authorization" = "Bearer $Token"}
            if (-not $null -eq $Filter)
            {
                $URI += "?filter=$Filter"
                $totalCount = Invoke-RestMethod ($URI + "&page=0" + "&page-size=1") -Headers $Headers -Method Get | Select-Object -ExpandProperty totalCount
            }
            else
            {
                $URI += "?"
                $totalCount = Invoke-RestMethod ($URI + "page=0" + "&page-size=1") -Headers $Headers -Method Get | Select-Object -ExpandProperty totalCount
            }
            $totalPages = [math]::Floor($totalCount/$PageSize)
            Write-Host "Processing a total of $totalPages pages..."
            Write-Host "URI: $URI"
            $jobs = (0..$totalPages) | ForEach-Object {Start-ThreadJob -ArgumentList ($URI, $Token, $_, $PageSize) -ScriptBlock {
                param($URI, $Token, $Page, $PageSize)
                $Headers = @{"Authorization" = "Bearer $Token"}
                if ($URI[-1] -eq "?")
                {
                    return Invoke-RestMethod ($URI + "page=$Page&page-size=$PageSize") -Method Get -Headers $Headers
                }
                else
                {
                    return Invoke-RestMethod ($URI + "&page=$Page&page-size=$PageSize") -Method Get -Headers $Headers
                }
            }}
            return $jobs | ForEach-Object {$_ | Wait-Job | Receive-Job | Select-Object -ExpandProperty results}

        }
        else
        {
            $URI += "?page=$Page&page-size=$PageSize"

            if (-not $null -eq $Filter)
            {
                $URI += "&filter=$Filter"
            }
        }
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET | Select-Object -ExpandProperty results

    return $response
}