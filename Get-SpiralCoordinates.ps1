Function Get-SpiralCoordinates($Left, $Top, $Width, $Height)
{
    $x = $y = 0
    
    $Delta = 0, -1

	$Coordinates = @()

    For($i = $width*$height; $i -gt 0; $i=$i-1) 
    {
        if( (-($width/2) -lt $x -and $x -le ($width/2)) -and (-($height/2) -lt $y -and $y -le ($height/2))) 
        {
            #$Graphics.DrawString("*",$Font,[System.Drawing.Brushes]::$(Get-Random -InputObject "red", "Green", "blue"),$x+$Left,$y+$Top)
			$Coordinates = $Coordinates + "$x,$y"
        }
    
        if($x -eq $y -or ($x -lt 0-and $x -eq (-$y)) -or ($x -gt 0 -and $x -eq (1-$y))){
            #change direction
            $delta = -$delta[1], $delta[0]           
        }
    
            #$delta = -$delta[1], $delta[0]
			$x =$x+ $delta[0];
			$y =$y+ $delta[1];
            #$Graphics.DrawString("*",$Font,[System.Drawing.Brushes]::$(Get-Random -InputObject "red", "Green", "blue"),$x+$Left,$y+$Top)        

			$Coordinates = $Coordinates + "$x,$y"
    }

	Return $Coordinates
    }
