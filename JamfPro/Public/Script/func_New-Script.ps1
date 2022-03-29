function New-Script
{
    # TODO: Add a `-FromFile` flag to create a script object from a file
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 1, Mandatory = $false)][String]$Info,
        [Parameter(Position = 1, Mandatory = $false)][String]$Notes,
        [Parameter(Position = 1, Mandatory = $true)][String]$Priority,        
        [Parameter(Position = 1, Mandatory = $false)][String]$categoryName,
        [Parameter(Position = 1, Mandatory = $true)][String]$categoryId,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter4,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter5,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter6,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter7,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter8,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter9,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter10,
        [Parameter(Position = 1, Mandatory = $true)][String]$Parameter11,
        [Parameter(Position = 1, Mandatory = $true)][String]$osRequirements,
        [Parameter(Position = 1, Mandatory = $true)][String]$scriptContents

    )

    $URI = "$Server/api/v1/scripts"

    $Body = @{
        "name" = $Name
        "info" = $Info
        "notes" = $Notes
        "priority" = $Priority
        "categoryId" = $categoryId
        "categoryName" = $categoryName
        "parameter4" = $Parameter4
        "parameter5" = $Parameter5
        "parameter6" = $Parameter6
        "parameter7" = $Parameter7
        "parameter8" = $Parameter8
        "parameter9" = $Parameter9
        "parameter10" = $Parameter10
        "parameter11" = $Parameter11
        "osRequirements" = $osRequirements
        "scriptContents" = $scriptContents
    }
    
    $Body = ConvertTo-Json $Body

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body -ContentType 'application/json'

    $response = Get-Script -Server $Server -Token $token -Id $response.id
    return $response
}