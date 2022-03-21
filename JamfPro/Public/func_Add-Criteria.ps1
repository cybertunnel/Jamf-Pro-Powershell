function Add-Criteria
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][PSCustomObject]$Group,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 2, Mandatory = $false)][Int]$Priority,
        [Parameter(Position = 3, Mandatory = $false)][switch]$And,
        [Parameter(Position = 4, Mandatory = $false)][switch]$Or,
        [Parameter(Position = 5, Mandatory = $true)][String]$SearchType,
        [Parameter(Position = 6, Mandatory = $true)][String]$Value,
        [Parameter(Position = 7, Mandatory = $false)][switch]$OpeningParen,
        [Parameter(Position = 8, Mandatory = $false)][switch]$ClosingParen
    )

    $validSearchTypes = "is", "is not", "like", "not like", "matches regex", "does not match regex"

    $criteria = @{
        "name" = $Name
        "opening_paren" = $OpeningParen
        "closing_paren" = $ClosingParen
        "value" = $Value
        "priority" = $Priority
    }

    if ($null -eq $And -and $null -eq $Or)
    {
        throw "You must provide either an `"-And`" or `"-Or`" flag to specify if the criteria logic."
    }

    if ($null -eq $Priority)
    {
        $criteria["priority"] = 0
    }

    # Adding and_or component
    if ($And)
    {
        $criteria["and_or"] = "and"
    }
    else
    {
        $criteria["and_or"] = "or"
    }

    if (-not $validSearchTypes.Contains($SearchType))
    {
        throw "You must provide one of the following valid search types: $($validSearchTypes -Join ",")"
    }

    $criteria["search_type"] = $SearchType

    $obj = New-Object PSObject -Property $criteria

    Write-Host $obj

    $Group.criteria += $obj

    return $Group
}