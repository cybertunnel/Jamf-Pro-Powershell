# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/deletesitebyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/deletesitebyname
function Remove-Site
{
    Param(
        [Parameter(Position = 0,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        # ID as Int
        [Parameter(Position = 2, Mandatory = $true)]
        [ValidateScript({$_ -gt 0})]
        [Int]$Id
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/sites/id/$Id"

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"
            "Accept" = "application/json"    
        }
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
        return $response

    }
    else {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Delete -Authentication Basic -Credential $Credential -Headers $headers
        return $response
    }
}