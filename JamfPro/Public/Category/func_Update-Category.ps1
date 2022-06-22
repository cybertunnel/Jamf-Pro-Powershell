############################
# API Type: JamfPro
# --------------------------
# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/put_v1-categories-id
# - https://developer.jamf.com/jamf-pro/reference/post_v1-categories-id-history
function Update-Category
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

        [Parameter(Position = 2, Mandatory = $true)]
        [ValidateScript({$_ -is [Int] -and $_ -gt 0})]
        [Int]$Id,

        [Parameter(Position = 3, Mandatory = $false)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$History,
        
        [Parameter(Position = 4, Mandatory = $false)]
        [pscustomobject]$Category
    )

    $URI = "$Server/api/v1/categories/$Id"
    $Headers = @{"Authorization" = "Bearer $Token"}

    if (-not $null -eq $History)
    {
        $URI += "/history"
        $Body = @{"note" = $History}
        $Body = ConvertTo-Json $Body

        Invoke-RestMethod $URI -Headers $Headers -Method Post -ContentType 'application/json' -Body $Body
    }
    elseif (-not $null -eq $Category)
    {
        $Body = ConvertTo-Json $Category

        Invoke-RestMethod $URI -Headers $Headers -Method Put -ContentType 'application/json' -Body $Body
    }
    else
    {
        throw 'Either a -Category or -History has to be provided.'
    }

    return
}