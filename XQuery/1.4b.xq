(:Answer for question 1.4b:)
let $bk := doc("/db/books.xml")//book
let $r := (for $i in distinct-values($bk/title) return $bk[title = $i][1])
for $i in $r order by xs:float($i/rating) descending return ($i/title,$i/rating)