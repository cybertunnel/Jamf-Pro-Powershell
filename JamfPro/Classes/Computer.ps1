class Computer
{
    [int]$id
    [string]$name

    Computer(
        [int]$id,
        [string]$name
    ){
        $this.id = $id
        $this.name = $name
    }
}