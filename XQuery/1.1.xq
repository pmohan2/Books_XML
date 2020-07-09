(:Answer for question 1.1:)
let $bk :=doc("/db/books.xml")
let $x1 := $bk//*[name = "Jeff"]
let $x2 := $bk//*[name != "Jeff"]
for $i in $x1//title, $j in $x2//title
where $i = $j
return <book>{$i,$x1//name,$bk//author[name != "Jeff"][book/title = $i]/name}</book>