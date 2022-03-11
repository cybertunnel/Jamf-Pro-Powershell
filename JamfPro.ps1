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
