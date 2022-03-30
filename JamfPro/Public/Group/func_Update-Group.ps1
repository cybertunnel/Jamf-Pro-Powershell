# Documentation Reference:
# - Computer Group by ID: https://developer.jamf.com/jamf-pro/reference/updateusergroupsbyid
# - Computer Group by Name: https://developer.jamf.com/jamf-pro/reference/updateusergroupsbyname
# - Mobile Group by ID: https://developer.jamf.com/jamf-pro/reference/updatemobiledevicegroupbyid
# - Mobile Group by Name: https://developer.jamf.com/jamf-pro/reference/updatemobiledevicegroupbyname
# - User Group by ID: https://developer.jamf.com/jamf-pro/reference/updatecomputergroupbyid
# - User Group by Name: https://developer.jamf.com/jamf-pro/reference/updatecomputergroupbyname
function Update-Group
{
    Param(
        [Parameter(Position = 4, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][String]$Token,
        [Parameter(Position = 0, Mandatory = $true)][PSCustomObject]$Group
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
        $URI = "$Server/JSSResource/computergroups/id/$($Group.id)"
        Write-Host "URI is $URI"

        # Process XML String
        $xmlString = "<?xml version=`"1.0`" encoding=`"utf-8`"?><computer_group>"
        $xmlString += "<id>$($Group.id)</id>"
        $xmlString += "<name>$($Group.name)</name>"
        $xmlString += "<is_smart>$($Group.is_smart)</is_smart>"
        if ($null -eq $Group.site.id -and $null -eq $Group.site.name)
        {
            $xmlString += "<site><id>-1</id></site>"
        }
        elseif (-not $null -eq $Group.site.id)
        {
            $xmlString += "<site><id>$($Group.site.id)</id></site>"
        }
        else
        {
            $xmlString += "<site><name>$($Group.site.name)</name></site>"
        }

        # Adding Criteria if it's a smart group
        if ($Group.is_smart)
        {
            $xmlString += "<criteria>"
            foreach ($crit in $Group.criteria)
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
            foreach ($comp in $Group.computers)
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
    $body = New-Object System.Xml.XmlDocument
    $body.LoadXml($xmlString)

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"
            "Accept" = "application/json"    
        }
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Headers $headers -Body $body
        return $response.computer_group
    }
    else
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Put -ContentType 'application/xml' -Authentication Basic -Credential $Credential -Body $body -Headers $headers
        return $response.computer_group
    }
}