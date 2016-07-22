Function Test-RectangleOverlap($RectangleBounds1, $RectangleBounds2)
{
	# Return True when rectangle overlaps
	 return  -not (($RectangleBounds1.x1 -le $RectangleBounds2.x2) -and ($RectangleBounds1.y1 -le $RectangleBounds2.y2) -and ($RectangleBounds1.x2 -ge $RectangleBounds2.x1) -and ($RectangleBounds1.y2 -ge $RectangleBounds2.y1))
}
