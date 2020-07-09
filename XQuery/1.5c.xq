(:Answer for question 1.5c:)
let $bk := doc("/db/books.xml")//author
let $ca := (for $i in distinct-values($bk//category) return $i)
let $ca1 := ($bk/book[category = $ca[1]])
let $ca2 := ($bk/book[category = $ca[2]])
let $ca3 := ($bk/book[category = $ca[3]])
let $ca4 := ($bk/book[category = $ca[4]])
let $result := (for $i in $ca1, $j in $ca2, $k in $ca3, $l in $ca4
where sum(($i/price,$j/price,$k/price,$l/price)) <= 1800 
order by avg(($i/rating,$j/rating,$k/rating,$l/rating)) descending
return <t>{$i,$j,$k,$l}</t>)[1]
for $x in $result//* return ($x/title, $x/price, $x/rating, $x/category)