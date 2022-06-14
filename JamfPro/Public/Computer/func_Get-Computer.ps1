#TODO: Add support for sections as an array
function Get-Computer
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

        [Parameter(Position = 2,
            Mandatory,
            ParameterSetName='single')]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 3,
            ParameterSetName='single')]
        [Switch]$RecoveryKey,

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
        [String]$Filter,

        [Parameter(Position = 5,
        ParameterSetName='page')]
        [Parameter(ParameterSetName='all')]
        [ValidateSet("GENERAL", "DISK_ENCRYPTION", "PURCHASING", "APPLICATIONS", "STORAGE",
        "USER_AND_LOCATION", "CONFIGURATION_PROFILES", "PRINTERS", "SERVICES", "HARDWARE",
        "LOCAL_USER_ACCOUNTS", "CERTIFICATES", "ATTACHMENTS", "PLUGINS", "PACKAGE_RECEIPTS",
        "FONTS", "SECURITY", "OPERATING_SYSTEM", "LICENSED_SOFTWARE", "IBEACONS",
        "SOFTWARE_UPDATES", "EXTENSION_ATTRIBUTES", "CONTENT_CACHING", "GROUP_MEMBERSHIPS")]
        [Array]$Section
    )
    $URI_PATH = "api/v1/computers-inventory"

    if (-not $null -eq $Id)
    {
        $URI = "$Server/$URI_PATH"

        if ($RecoveryKey)
        {
            $URI += "/$Id/view-recovery-lock-password"
        }
        else
        {
            $URI += "-detail/$Id"
        }
    }
    else
    {
        $URI = "$Server/$URI_PATH"
        $URI += "?"
        
        # Add specific additions if needed
        ## Filter
        if (-not $null -eq $Filter)
        {
            $URI += "filter=$Filter"
        }

        ## Sections
        if ($Section.count -gt 0)
        {
            if ($URI[-1] -eq "?") {
                $URI += "section=$(Join-String -Separator "," -InputObject $Section)"
            }
            else {
                $URI += "&section=$(Join-String -Separator "," -InputObject $Section)"
            }
        }

        if ($All)
        {
            # Process pages
            write-host "Pulling all data"
            $Headers = @{"Authorization" = "Bearer $Token"}

            if ($URI[-1] -eq "?") {
                $totalCount = Invoke-RestMethod ($URI + "page=0" + "&page-size=1") -Headers $Headers -Method Get | Select-Object -ExpandProperty totalCount
            }
            else {
                    $totalCount = Invoke-RestMethod ($URI + "&page=0" + "&page-size=1") -Headers $Headers -Method Get | Select-Object -ExpandProperty totalCount
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
            if ($URI[-1] -eq "?") {
                $URI += "page=$Page&page-size=$PageSize"
            }
            else {
                $URI += "&page=$Page&page-size=$PageSize"
            }
        }
    }

    $Headers = @{"Authorization" = "Bearer $Token"}

    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    if ($Id -eq 0)
    {
        return $response | Select-Object -ExpandProperty results
    }
    else
    {
        return $response
    }
}