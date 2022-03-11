function Get-Auth {
    $serverUrl = $env:JamfProURL

    if ($null -eq $serverUrl) {
        $server = Read-Host "Jamf Pro Server URL"

        if ( isURIWeb($server) ) {
            $env:JamfProURL = $server
        } else {
            Write-Host "Server URL was not provided."
            exit 1
        }
    }
    $serverUrl = $env:JamfProURL
    $creds = Get-Credential
    $uri = "$serverURL/api/v1/auth/token"

    $response = Invoke-RestMethod $uri -Credential $creds -Authentication Basic -Method POST -ContentType "application/json;charset=UTF-8"

    return $response
}

function Get-Computers {
    Param(
        [string]$server = $env:JamfProURL,
        [Parameter(Mandatory=$true)]
        [string]$token,
        [switch]$totalCount
    )

    if ($null -eq $server) {
        $server = Read-Host "Jamf Pro Server URL"

        if ( isURIWeb($server) ) {
            $env:JamfProURL = $server
        } else {
            Write-Host "Server URL was not provided."
            exit 1
        }
    }

    Write-Host "Current token: $token"

    $uri = "$server/api/v1/computers-inventory"
    $headers = @{"Authorization" = "Bearer $token"}

    $response = Invoke-RestMethod $uri -Headers $headers -Method GET -ContentType "application/json;charset=UTF-8"

    if ($totalCount) {
        return $response.totalCount
    } else {
        return $response.results
    }
}

function Get-Computer {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id,
        [string]$serialNumber,
        [string]$user
    )

    if ($null -ne $id) {
        #Obtain record using inventory details
    } else {
        #Obtain record using inventory with all the sections
    }
}

function Get-Computer-Prestages {
    Param(
        [string]$server = $env:JamfProURL
    )

    # Get Computer Prestages
}

function Get-Computer-Prestage {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id,
        [string]$name
    )

    # Get Computer Prestage details
}

function Get-Computer-Prestages-Scope {
    Param(
        [string]$server = $env:JamfProURL
    )
}

function Get-Computer-Prestage-Scope {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id
    )
}

function Get-Departments {
    Param(
        [string]$server = $env:JamfProURL,
        [string]$name,
        [int]$id
    )
}

function Get-Department {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id
    )
}

function Get-Enrollment-Customizations {
    Param(
        [string]$server = $env:JamfProURL
    )
}

function Get-Enrollment-Customization {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id
    )
}

function Get-Inventory-Preloads {
    Param(
        [string]$server = $env:JamfProURL,
        [switch]$csv,
        [switch]$csvTemplate,
        [switch]$eaColumns
    )
}

function Get-Inventory-Preload {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id
    )
}

function Get-Scripts {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id,
        [string]$name
    )
}

function Get-Script {
    Param(
        [string]$server = $env:JamfProURL,
        [int]$id
    )
}

function isURI($address) {
    ($null -ne $address -as [System.URI])
}

function isURIWeb($address) {
    $uri = $address -as [System.URI]
    ($null -ne $uri.AbsoluteURI -and $uri.Scheme -match '[http|https]')

}

$server = Read-Host "Jamf Pro Server URL"

if ( isURIWeb($server) ) {
    $env:JamfProURL = $server
} else {
    Write-Host "Server URL was not provided."
    exit 1
}

$token = Get-Auth

$results = Get-Computers -token $token.token

Write-Host $results

$results = Get-Computers -token $token.token -totalCount
Write-Host $results
exit 0
