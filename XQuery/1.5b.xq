(:Answer for question 1.5b:)
let $bk := doc("/db/books.xml")//author
let $ca := (for $i in distinct-values($bk//category) return $i)
for $i in $ca let $temp := (for $j in $bk/book[category = $i] order by xs:float($j/rating) descending
return $j)[1] return  ($temp/title,$temp/rating,$temp/category)