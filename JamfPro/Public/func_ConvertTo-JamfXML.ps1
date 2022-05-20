# Takes in PSCustomObject and returns an XML document
# Max Depth: 5 (Parent, Child, Grand Child, Great Grand Child, Great Great Grand Child)
function ConvertTo-JamfXML
{
    Param(
        [String]$ParentElementName,
        [PSCustomObject]$JamfObject
    )
    $xmlObj = New-Object System.Xml.XmlDocument

    $newObjectType = $xmlObj.AppendChild($xmlObj.CreateElement($ParentElementName))

    # EX: General / Scope
    $parentElements = $JamfObject | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

    foreach ($parentElement in $parentElements)
    {
        $parentXML = $newObjectType.AppendChild($xmlObj.CreateElement($parentElement))

        # Check if Custom Object or Array with contents
        if ($JamfObject.$parentElement -is [PSCustomObject] -or ($JamfObject.$parentElement -is [Array] -and $JamfObject.$parentElement.count -gt 0))
        {
            # There might be more than 1 layer of children, MULTI generations!
            $childrenElements = $JamfObject.$parentElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

            # Grabbing the contents of each child object
            foreach ($childElement in $childrenElements)
            {
                $childXML = $parentXML.AppendChild($xmlObj.CreateElement($childElement))

                # Add scope specific xml elements
                if ($parentElement -eq 'scope' -and $childElement -ne 'limitations' -and $childElement -ne 'exclusions' -and $childElement -ne 'all_computers' -and -not $null -eq  $JamfObject.$parentElement.$childElement  -and $JamfObject.$parentElement.$childElement.toString() -ne "")
                {
                    Write-Host 'Scope object like computer groups has been found, adding the required child element'
                    $childXML = $childXML.AppendChild($xmlObj.CreateElement($childElement.Substring(0, $childElement.Length - 1)))
                }

                # Check if Custom Object or Array with contents
                if ($JamfObject.$parentElement.$childElement -is [PSCustomObject] -or ($JamfObject.$parentElement.$childElement -is [Array] -and $JamfObject.$parentElement.$childElement.count -gt 0))
                {
                    $grandChildrenElements = $JamfObject.$parentElement.$childElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

                    # Grabbing the contents of each grandchild object
                    foreach ($grandChildElement in $grandChildrenElements)
                    {
                        $grandChildXML = $childXML.AppendChild($xmlObj.CreateElement($grandChildElement))

                        # Add scope specific xml elements
                        if ($parentElement -eq 'scope' -and ($childElement -eq 'limitations' -or $childElement -eq 'exclusions') -and -not $null -eq $JamfObject.$parentElement.$childElement.$grandChildElement -and $JamfObject.$parentElement.$childElement.$grandChildElement.toString() -ne "")
                        {
                            Write-Host 'Scope object like computer groups inside exclusions has been found, adding the required child element'
                            $grandChildXML = $grandChildXML.AppendChild($xmlObj.CreateElement($grandChildElement.Substring(0, $grandChildElement.Length - 1)))
                        }

                        # Check if Custom Object or Array with contents
                        if ($JamfObject.$parentElement.$childElement.$grandChildElement -is [PSCustomObject] -or ($JamfObject.$parentElement.$childElement.$grandChildElement -is [Array] -and $JamfObject.$parentElement.$childElement.$grandChildElement.count -gt 0))
                        {
                            $greatGrandChildrenElements = $JamfObject.$parentElement.$childElement.$grandChildElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

                            # Grabbing the contents of each great grandchild object
                            foreach ($greatGrandChildElement in $greatGrandChildrenElements)
                            {
                                $greatGrandChildXML = $grandChildXML.AppendChild($xmlObj.CreateElement($greatGrandChildElement))

                                # Check if Custom Object or Array with contents
                                if ($JamfObject.$parentElement.$childElement.$grandChildElement -is [PSCustomObject] -or ($JamfObject.$parentElement.$childElement.$grandChildElement -is [Array] -and $JamfObject.$parentElement.$childElement.$grandChildElement.count -gt 0))
                                {
                                    $greatGreatGrandChildrenElements = $JamfObject.$parentElement.$childElement.$grandChildElement.$greatGrandChildElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

                                    # Grabbing the contents of each great great grandchild object
                                    foreach ($greatGreatGrandChildElement in $greatGreatGrandChildrenElements)
                                    {
                                        $greatGreatGrandChildXML = $greatGrandChildXML.AppendChild($xmlObj.CreateElement($greatGreatGrandChildElement))
                                        if (-not $null -eq $JamfObject.$parentElement.$childElement.$grandChildElement.$greatGrandChildElement.$greatGreatGrandChildElement) { $greatGreatGrandChildXML.AppendChild($xmlObj.CreateTextNode()) }
                                        

                                        # Max depth, time to set value
                                        Write-Host 'WARNING: Max-Depth of 5 reached.'
                                    }
                                }
                                else
                                {
                                    # Great Grand Child doesn't have children, maybe cost of living too high?
                                    if (-not $null -eq $JamfObject.$parentElement.$childElement.$grandChildElement.$greatGrandChildElement -or $JamfObject.$parentElement.$childElement.$grandChildElement.toString() -eq "") { $greatGrandChildXML.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement.$grandChildElement.$greatGrandChildElement)) }
                                }
                            }
                        }
                        else
                        {
                            # Grand Child doesn't have children, not so grand eh?
                            if (-not $null -eq $JamfObject.$parentElement.$childElement.$grandChildElement) { $grandChildXML.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement.$grandChildElement)) }
                        }
                    }
                }
                else
                {
                    # Child object doesn't have children
                    if (-not $null -eq $JamfObject.$parentElement.$childElement) { $childXML.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement)) }
                }
            }
        }
        else
        {
            # Parent object doesn't have children
            $parentXML.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement))
        }
    }
    

    return $xmlObj
}