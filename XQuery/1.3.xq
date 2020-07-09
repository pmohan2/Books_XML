(:Answer for question 1.3:)
let $bk := doc("/db/books.xml")//author
let $bk1 := doc("/db/books.xml")
let $ga := avg($bk//price)
let $ca := (for $i in distinct-values($bk//category) 
where avg($bk/book[category = $i]/price) > $ga return $i )
let $b := (for $i in $ca
let $temp := (for $j in $bk/book[category = $i] order by xs:float($j/price) descending
return $j)[1] return $temp)
let $b_a := (for $i in $b/title return <n>{$i, $bk1//author[book/title = $i]/name}</n>)
let $result := (for $i in $b
return <categories><output>{$i/category,$i/title,$i/price, $b_a[title = $i/title]/name}</output></categories>)
return <result>{$result}</result>