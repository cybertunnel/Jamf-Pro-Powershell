# Documentation Reference:
# - Computer Group: https://developer.jamf.com/jamf-pro/reference/createcomputergroupbyid
# - Mobile Group: https://developer.jamf.com/jamf-pro/reference/createmobiledevicegroupbyid
# - User Group: https://developer.jamf.com/jamf-pro/reference/createusergroupsbyid
function New-Group
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 3, Mandatory = $false)][switch]$is_smart,
        [Parameter(Position = 4, Mandatory = $false)][PSCustomObject]$Site,
        [Parameter(Position = 5, Mandatory = $false)][PSCustomObject[]]$Criteria,
        [Parameter(Position = 6, Mandatory = $false)][String]$Computers,
        [Parameter(Position = 7, Mandatory = $false)][switch]$Computer
    )

    if (-not $Computer)
    {
        throw "A group type flag must be provided. Supported groups: `"-Computer`"."
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    # Generate the URI
    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups/id/-1"
        # Process XML String
        $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_group>"
        $xmlString += "<name>$Name</name>"
        $xmlString += "<is_smart>$is_smart</is_smart>"
        if ($null -eq $Site.id -and $null -eq $Site.name)
        {
            $xmlString += "<site><id>-1</id></site>"
        }
        elseif (-not $null -eq $Site.id)
        {
            $xmlString += "<site><id>$($Site.id)</id></site>"
        }
        else
        {
            $xmlString += "<site><name>$($Site.name)</name></site>"
        }

        # Adding Criteria if it's a smart group
        if ($is_smart)
        {
            $xmlString += "<criteria>"
            foreach ($crit in $Criteria)
            {
                $xmlString += "<criterion>"
                $xmlString += "<name>$($crit.name)</name>"
                $xmlString += "<priority>$($crit.priority)</priority>"
                $xmlString += "<and_or>$($crit.and_or)</and_or>"
                $xmlString += "<search_type>$($crit.search_type)</search_type>"
                $xmlString += "<value>$($crit.value)</value>"
                $xmlString += "<opening_paren>$($crit.opening_paren)</opening_paren>"
                $xmlString += "<closing_paren>$($crit.closing_paren)</closing_paren>"
                $xmlString += "</criterion>"
            }
            $xmlString += "</criteria>"
        }
        else
        {
            # Adding computer entries
            $xmlString += "<computers>"
            foreach ($comp in $Computers)
            {
                $xmlString += "<computer>"
                if (-not $null -eq $comp.id)
                {
                    $xmlString += "<id>$($comp.id)</id>"
                }
                elseif (-not $null -eq $comp.name)
                {
                    $xmlString += "<name>$(comp.name)</name>"
                }
                else
                {
                    throw "An `"id`" or `"name`" must be provided in the `"Computers`" object."
                }
                $xmlString += "</computer>"
            }
        }
        $xmlString += "</computer_group>"
    }

    Write-Host "Attempting to parse $xmlString"
    $body = New-Object system.Xml.XmlDocument
    $body.LoadXml($xmlString)

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"
            "Accept" = "application/json"    
        }
        $response = Invoke-RestMethod $URI -Method Post -ContentType 'application/xml' -Headers $headers -Body $body
        return $response.computer_group

    }
    else {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Post -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
        return $response.computer_group
    }
}