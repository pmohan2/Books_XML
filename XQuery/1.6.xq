(:Answer for question 1.6:)
let $bk := doc("/db/books.xml")//author
let $bk1 := doc("/db/books.xml")
let $b := (for $i in distinct-values($bk//title)
let $temp := (for $j in $bk/book[title = $i] return $j)[1] return $temp)
let $b_a := (for $i in $b/title
for $j in $bk1//author[book/title = $i]/name
let $temp1 := (<author>{data($j)}</author>) return <t>{$i, $temp1}</t>)
let $result := (for $i in $b
return <book year = "{data($i/@year)}">{$i/title,$i/category,$i/rating, $i/price, $b_a[title = $i/title]/author}</book>)
return <biblio>{$result}</biblio>