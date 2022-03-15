class Criterion
{
    [string]$name
    [int]$priority
    [string]$and_or
    [string]$search_type
    [string]$value
    [switch]$opening_paren
    [switch]$closing_paren

    Criterion(
        [string]$name,
        [int]$priority,
        [string]$and_or,
        [string]$search_type,
        [string]$value,
        [switch]$opening_paren,
        [switch]$closing_paren
    ){
        $this.name = $name
        $this.priority = $priority
        $this.and_or = $and_or
        $this.search_type = $search_type
        $this.value = $value
        $this.opening_paren = $opening_paren
        $this.closing_paren = $closing_paren
    }
}