(:Answer for question 1.5a:)
let $bk := doc("/db/books.xml")//author
let $ca := (for $i in distinct-values($bk//category) return $i)
for $i in $ca let $temp := (for $j in $bk/book[category = $i] order by xs:float($j/price)
return $j)[1] return ($temp/title,$temp/price,$temp/category)