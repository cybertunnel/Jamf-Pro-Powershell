function Remove-Script
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id
    )

    if (-not $null -eq $Id)
    {
        # Delete single
        $URI = "$Server/api/v1/scripts/$Id"
        $Headers = @{"Authorization" = "Bearer $Token"}
    
        Invoke-RestMethod $URI -Headers $Headers -Method Delete
    }
    else
    {
        throw 'An "-Id" or "-Ids" must be provided.'
    }

    return
}