Function Split-ContentToSentence ($Content)
{
@"
$Content
"@.Split(".").Trim() | ?{-not [string]::IsNullOrWhiteSpace($_)}  
}

Function Split-ContentToParagraph ($Content)
{
    $Content -split "`n`n"
}

Function Get-Intersection($S1, $S2)
{
    (Compare-Object -ReferenceObject $s1 -DifferenceObject $s2 -IncludeEqual |?{$_.sideindicator -eq '=='} | select Inputobject -ExpandProperty Inputobject -Unique).count
}


$Sentences = Split-ContentToSentence $c
$NoOfSentences = $Sentences.count
$values = New-Object 'object[,]' 36,36
$values = ,@()
foreach($i in (1..$NoOfSentences))
{
    foreach($j in (1..$NoOfSentences))
    {
        #$values[$i][$j] = 
        Get-Intersection $Sentences[$i] $Sentences[$j]
       
    }
}
