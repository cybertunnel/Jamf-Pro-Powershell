# Takes in PSCustomObject and returns an XML document
function ConvertTo-JamfXML
{
    Param(
        [String]$ParentElementName,
        [PSCustomObject]$JamfObject
    )
    $xmlObj = New-Object System.Xml.XmlDocument

    $newObjectType = $xmlObj.AppendChild($xmlObj.CreateElement($ParentElementName))

    $parentElements = $JamfObject | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

    foreach ($parentElement in $parentElements)
    {
        Write-Host "Processing Element $parentElement"
        $newParentElement = $newObjectType.AppendChild($xmlObj.CreateElement($parentElement))

        # Check if Custom Object or Array with contents
        if ($JamfObject.$parentElement -is [PSCustomObject] -or ($JamfObject.$parentElement -is [Array] -and $JamfObject.$parentElement.count -gt 0))
        {
            Write-Host "Parent has children!"

            $childrenElements = $JamfObject.$parentElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

            foreach ($childElement in $childrenElements)
            {
                Write-Host "Processing Child Element $childElement"
                $newChildElement = $newParentElement.AppendChild($xmlObj.CreateElement($childElement))

                # Chick if Custom Object or Array with content
                if ($JamfObject.$parentElement.$childElement -is [PSCustomObject] -or ($JamfObject.$parentElement.$childElement -is [Array] -and $JamfObject.$parentElement.$childElement.count -gt 0))
                {
                    $childrenChildrenElements = $JamfObject.$parentElement.$childElement | Get-Member | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name

                    foreach ($childChildElement in $childrenChildrenElements)
                    {
                        Write-Host "Processing Child element of Child element $childChildElement"
                        $newChildChildElement = $newChildElement.AppendChild($xmlObj.CreateElement($childChildElement))

                        # Chick if Custom Object or Array with content
                        if ($JamfObject.$parentElement.$childElement.$childChildElement -is [PSCustomObject] -or ($JamfObject.$parentElement.$childElement.$childChildElement -is [Array] -and $JamfObject.$parentElement.$childElement.$childChildElement.count -gt 0))
                        {
                            Write-Host "Max depth reached for $JamfObject.$parentElement.$childElement.$childChildElement"
                            $newChildChildElement.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement.$childChildElement))
                        }
                        else
                        {
                            $newChildChildElement.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement.$childChildElement))
                        }
                    }
                }
                else
                {
                    $newChildElement.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement.$childElement))
                }
            }
        }
        else
        {
            $newParentElement.AppendChild($xmlObj.CreateTextNode($JamfObject.$parentElement))
        }
    }
    

    return $xmlObj
}