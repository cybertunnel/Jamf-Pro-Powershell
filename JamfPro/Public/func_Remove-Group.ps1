function Remove-Group
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $true)][int]$Id,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Computer
    )

    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups/id/$Id"
    }
    else
    {
        Throw "The -Computer flag must be present to delete a computer group"
    }


    $response = Invoke-RestMethod $URI -Method Delete -Credential $Credential -Authentication Basic
    return $response
}