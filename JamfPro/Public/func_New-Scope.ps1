# Creates an object for Targeting, Limitation, or Exclusion part of the scoping object
function New-Scope
{
    [CmdletBinding(DefaultParameterSetName='single')]
    Param(
        [Parameter(Position = 0,
            ParameterSetName='all')]
        [Switch]$TargetAll,
        [Parameter(Position = 1,
            ParameterSetName='single')]
        [ValidateLength(1, [int]::MaxValue)]
        [Array]$TargetComputers,
        [Parameter(Position = 2,
            ParameterSetName='single')]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$TargetGroups,
        [Parameter(Position = 3,
            ParameterSetName='single')]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$TargetBuildings,
        [Parameter(Position = 4,
            ParameterSetName='single')]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$TargetDepartments,
        [Parameter(Position = 5,
            ParameterSetName='single')]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$TargetUserGroups,
        [Parameter(Position = 6)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$LimitUsers,
        [Parameter(Position = 7)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$LimitUserGroups,
        [Parameter(Position = 8)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$LimitSegments,
        [Parameter(Position = 9)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$LimitiBeacons,
        [Parameter(Position = 10)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeComputers,
        [Parameter(Position = 11)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeGroups,
        [Parameter(Position = 12)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeBuildings,
        [Parameter(Position = 13)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeDepartments,
        [Parameter(Position = 14)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeUsers,
        [Parameter(Position = 15)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeUserGroups,
        [Parameter(Position = 16)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeSegments,
        [Parameter(Position = 17)]
         [ValidateLength(1, [int]::MaxValue)]
        [Array]$ExcludeiBeacons,
        # Jamf Pro server
        [Parameter(Position = 18,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 19,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token
    )
    # Functions
    function Start-ProcessingComputers
    {
        Param(
            [Array]$Computers,
            [String]$Server,
            [String]$Token
        )

        $processedDevices = @()
        foreach ($computer in $Computers)
        {
            try {
                $value = [int]$computer
                $computerObj = Get-Computer -All -Server $Server -Token $Token -Filter "id==$value" | Select-Object id -ExpandProperty general | Select-Object id, name
            }
            catch {
                $value = [string]$computer
                $computerObj = Get-Computer -All -Server $Server -Token $Token -Filter "general.name==$value" | Select-Object id -ExpandProperty general | Select-Object id, name
            }
            $processedDevices += $computerObj
        }

        return $processedDevices
    }

    function Start-ProcessingComputerGroups
    {
        Param(
            [Array]$ComputerGroups,
            [String]$Server,
            [String]$Token
        )

        $processedGroups = @()
        foreach ($group in $ComputerGroups)
        {
            try {
                $value = [int]$group
                $groupObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            catch {
                $value = [string]$group
                $groupObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            $processedGroups += $groupObj
        }

        return $processedGroups
    }

    function Start-ProcessingBuildings
    {
        Param(
            [Array]$Buildings,
            [String]$Server,
            [String]$Token
        )

        $processedBuildings = @()
        foreach ($building in $Buildings)
        {
            try {
                $value = [int]$building
                $buildingObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            catch {
                $value = [string]$building
                $buildingObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            $processedBuildings += $buildingObj
        }

        return $processedBuildings
    }

    function Start-ProcessingDepartments
    {
        Param(
            [Array]$Departments,
            [String]$Server,
            [String]$Token
        )

        $processedDepartments = @()
        foreach ($department in $Departments)
        {
            try {
                $value = [int]$department
                $departmentObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            catch {
                $value = [string]$department
                $departmentObj = Get-Computer -All -Server $Server -Token $Token | Where-Object {$_.id -eq $value} | Select-Object id, name
            }
            $processedDepartments += $departmentObj
        }

        return $processedDepartments
    }

    function Start-ProcessingUsers
    {
        # TODO: Add User API functionality
        return $null
    }

    function Start-ProcessingUserGroups
    {
        # TODO: Add User Group API functionality
    }

    function Start-ProcessingNetworkSegements
    {
        # TODO: Add Network Segment API functionality
    }

    function Start-ProcessingiBeacons
    {
        # TODO: Add iBeacon API functionality
    }

    $scopeObject = [PSCustomObject]@{
        all_computers = $TargetAll
        computers = (Start-ProcessingComputers -Computers $TargetComputers -Server $Server -Token $Token)
        computer_groups = (Start-ProcessingComputerGroups -ComputerGroups $TargetGroups -Server $Server -Token $Token)
        buildings = (Start-ProcessingBuildings -Buildings $TargetBuildings -Server $Server -Token $Token)
        departments = (Start-ProcessingDepartments -Departments $TargetDepartments -Server $Server -Token $Token)
        limit_to_users = (Start-ProcessingUserGroups)
        limitations = [PSCustomObject]@{
            users = (Start-ProcessingUsers)
            user_groups = (Start-ProcessingUserGroups)
            network_segments = (Start-ProcessingNetworkSegements)
            ibeacons = (Start-ProcessingiBeacons)
        }
        exclusions = [PSCustomObject]@{
            computers = (Start-ProcessingComputers -Computers $ExcludeComputers -Server $Server -Token $Token)
            computer_groups = (Start-ProcessingComputerGroups -ComputerGroups $ExcludeGroups -Server $Server -Token $Token)
            buildings = (Start-ProcessingBuildings -Buildings $ExcludeBuildings -Server $Server -Token $Token)
            departments = (Start-ProcessingDepartments -Departments $ExcludeDepartments -Server $Server -Token $Token)
            users = (Start-ProcessingUsers)
            user_groups = (Start-ProcessingUserGroups)
            network_segments = (Start-ProcessingNetworkSegements)
            ibeacons = (Start-ProcessingiBeacons)
        }
    }

    return $scopeObject
}