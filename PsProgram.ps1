$Dataset = @()

0..1000 | Foreach-Object  {
    $Dataset += (Get-Verb)[(Get-Random -Maximum 98)]
}
0..10 | Foreach-Object {$Dataset += $Dataset}

Measure-Command { $Dataset | Where-Object Verb -eq "Use"}

[Func[object,bool]] $Delegate = { param($v); return $v.verb -eq "Use" }
Measure-Command { [Linq.Enumerable]::Where($Dataset,$Delegate) }


