Function Get-Intersection($S1, $S2)
{
    Compare-Object -ReferenceObject $s1 -DifferenceObject $s2 -IncludeEqual |?{$_.sideindicator -eq '=='} | select Inputobject -ExpandProperty Inputobject -Unique
}

