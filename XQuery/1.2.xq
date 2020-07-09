(:Answer for question 1.2:)
let $main := (for $x in doc("/db/books.xml")//*[count(book) > 1],
$y in doc("/db/books.xml")//*[count(book) > 1 ]
for $i in $x/book, $j in $y/book
where  $x/name != $y/name and $x << $y
return if ($i/title=$j/title)
then <output>{$x/name, $y/name, $i}</output>)
let $main2 := (for $k in $main, $l in $main
where $k/name[1] = $l/name[1]
and  $k/name[2] = $l/name[2]
and $k/book/title != $l/book/title
return $k)
return <coauthor>{$main2}</coauthor>