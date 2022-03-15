class Site {
    [int]$id
    [string]$name

    Site(
        [int]$id,
        [string]$name
    ){
        $this.id = $id
        $this.name = $name
    }
}