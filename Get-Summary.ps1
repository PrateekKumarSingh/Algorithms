Function Split-ContentToSentence ($Content)
{
    ([string]$Content -split '. ',0,"simplematch").Trim() | ?{-not [string]::IsNullOrWhiteSpace($_)}  
}

Function Remove-PunctuautionAndSymbols ($word)
{
    $word  -replace(',.;:-/\`!@#$%^&*()')
}

Function Get-FrequencyDistribution ($Content)
{
    $Content.split(" ") |?{-not [String]::IsNullOrEmpty($_)} |group |sort count -Descending
}

Function Get-Intersection($Sentence1, $Sentence2)
{
    $CommonWords = Compare-Object -ReferenceObject $Sentence1 -DifferenceObject $Sentence2 -IncludeEqual |?{$_.sideindicator -eq '=='} | select Inputobject -ExpandProperty Inputobject

    $CommonWords.Count / ($Sentence1.Count + $Sentence2.Count) /2
}

Function Get-SentenceRank($Content)
{
    $Sentences = Split-ContentToSentence $Content
    $NoOfSentences = $Sentences.count
    $values = New-Object 'object[,]' $NoOfSentences,$NoOfSentences
    $SentenceScore = New-Object double[] $NoOfSentences
    
    
    #Get important words that where length is greater than 3 to avoid - in, on, of, to, by etc
    $ImportantWords = Get-FrequencyDistribution $Content |?{$_.name.length -gt 3} | select @{n='Weight';e={$_.Count * 0.001}}, @{n='ImportantWord';e={$_.Name}} -First 10
    $weight = 0

    foreach($i in (0..($NoOfSentences-1)))
    {
        $NoOfImportantwordsInSentence = 0
                
        foreach($j in (0..($NoOfSentences-1)))
        {
            #$values[$i][$j] = 
            $WordsInReferenceSentence = $Sentences[$i].Split(" ")
            $WordsInDifferenceSentence = $Sentences[$j].Split(" ")
            #"$i,$j --- > " + (Get-Intersection  $WordsInReferenceSentence $WordsInDifferenceSentence)
        
            $SentenceScore[$i] = $SentenceScore[$i] + (Get-Intersection  $WordsInReferenceSentence $WordsInDifferenceSentence)
    
            
        }

        Foreach($Item in $WordsInReferenceSentence |select -unique)
        {
            #$Item
            If($Item -in $ImportantWords.ImportantWord)
            {
                $weight += ($ImportantWords| ?{$_.ImportantWord -eq $Item}).weight
            }
        }
    
        ''| select  @{n='LineNumber';e={$i}}, @{n='TotalScore';e={"{0:N3}"-f ($SentenceScore[$i]+$weight)}}, @{n='WordCovered_Score';e={"{0:N3}"-f $SentenceScore[$i]}}, @{n='ImportantWord_Score';e={$weight}}, @{n='WordCount';e={($Sentences[$i].Split(" ")).count}} , @{n='Sentence';e={$Sentences[$i]}}
    }
}

Function Get-Summary($Content, $WordLimit)
{

    $TotalWords = 0
    $Summary=@()

    #Extracting Best sentences with highest Ranks within the word limit
    $BestSentences = Foreach($Item in (Get-SentenceRank $Content | Sort TotalScore -Descending))
    {
        $TotalWords += $Item.WordCount

        If($TotalWords -gt $WordLimit)
        {
            break
        }
        else
        {
            $Item
        }
   }
   
    #Constructing a paragraph with sentences in Chronological order
    Foreach($best in (($BestSentences |sort Linenumber).sentence))
    {
        If(-not $Best.endswith("."))
        {
            $Summary += -join ($Best, ". ")
        
        }
        else
        {
            $Summary += -join ($Best, " ")
        }

    }

    $Summary
}

