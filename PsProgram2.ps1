# From https://powershell.org/2018/05/executing-linq-queries-in-powershell-part-2/

#Create empty arrays
$DatasetA = @()
$DatasetB = @()
#Initialize "status" arrays to pull random values from
$ProductionStatusArray = @('In Production','Retired')
$PowerStatusArray = @('Online','Offline')
#Loop 1000 times to populate our separate datasets
1..1000 | Foreach-Object {
    #Create one object with the current iteration attached to the name property
    #and a random power status
    $PropA = @{
        Name = "Server$_"
        PowerStatus = $PowerStatusArray[(Get-Random -Minimum 0 -Maximum 2)]
    }
    $DatasetA += New-Object -Type PSObject -Property $PropA
    #Create a second object with the same name and a random production status
    $PropB = @{
        Name = "Server$_"
        ProductionStatus = $ProductionStatusArray[(Get-Random -Minimum 0 -Maximum 2)]
    }
    $DatasetB += New-Object -Type PSObject -Property $PropB
}

#The old way
Measure-Command {
    $JoinedData = @()
    foreach($ServerA in $DatasetA) {
       # $ServerB = $DatasetB | Where-Object Name -eq $ServerA.Name
        $ServerB = $DatasetB[$ServerA.Name] 
        $Props = @{
            Name = $ServerA.Name
            PowerStatus = $ServerA.PowerStatus
            ProductionStatus = $ServerB.ProductionStatus
        }
        $JoinedData += New-Object -Type PSObject -Property $Props
    }
}

# with LinQ

Measure-Command{
$LinqJoinedData = [System.Linq.Enumerable]::Join(
    $DatasetA,
    $DatasetB,
    [System.Func[Object,string]] {param ($x);$x.Name},
    [System.Func[Object,string]]{param ($y);$y.Name},
    [System.Func[Object,Object,Object]]{
        param ($x,$y);
        New-Object -TypeName PSObject -Property @{
        Name = $x.Name;
        PowerStatus = $x.PowerStatus;
        ProductionStatus = $y.ProductionStatus}
    }
)

    $OutputArray = [System.Linq.Enumerable]::ToArray($LinqJoinedData)
}
$OutputArray.count | Write-Host

Measure-Command{
   Write-Host "Result :"+($OutputArray.Where({($_.PowerStatus -eq "Offline") -and ($_.ProductionStatus -eq "In Production")})).count
}
