class ComputerGroup {
    [int]$id
    [string]$name
    [switch]$is_smart
    # TODO: Add class for just site object
    [Site]$site
    [Array]$criteria
    [array]$computers

    ComputerGroup(
        [int]$id,
        [string]$name,
        [switch]$is_smart,
        [hashtable]$site,
        [array]$criteria,
        [array]$computers
    ){
        $this.id = $id
        $this.name = $name
        $this.is_smart = $is_smart
        $this.site = $site
        if ($null -eq $criteria)
        {
            $this.criteria = @()
        }
        else
        {
            $this.criteria = $criteria
        }

        if ($null -eq $computers)
        {
            $this.computers = @()
        }
        else
        {
            $this.computers = $computers
        }
        
        $this.computers = $computers
    }

    [void] AddCriteria(
        [Criterion]$criterion
    ){
        if ($this.criteria.Length -gt 0)
        {
            $this.criteria += $criterion
        }
        else
        {
            $this.criteria = @($criterion)
        }
    }

    # TODO: Add constructor for system object that would come from the API
}