# CSE 560: XML and XQuery

## This is an individual project for writing XQuery. There are 6 problems.

# 1. Problem Statements

## Given the following DTD data format A that describes the information about authors and books.

## Assuming you have an XML document called books.xml that is valid against the given DTD.

## DTD data format A:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE biblio[
<!ELEMENT biblio (author*)>
<!ELEMENT author (name,book*)>
<!ELEMENT name (#PCDATA)>
<!ELEMENT book (title, category,rating,price)>
<!ELEMENT title (#PCDATA)>
<!ELEMENT category(#PCDATA)>
<!ELEMENT rating(#PCDATA)>
<!ELEMENT price (#PCDATA)>
<!ATTLIST book year CDATA #REQUIRED>
]>
```

## 1.1 Find the names of all Jeff’s co-authors and list them together with the titles of books that were co-authored.

Sample output format:
```
<book>
<title>Big data analytics</title>
<name>Jeff</name>
<name>the other author</name>
</book>
......
```
### XQuery(1.1):
```
let $bk :=doc("/db/books.xml")
let $x1 := $bk//*[name = "Jeff"]
let $x2 := $bk//*[name != "Jeff"]
for $i in $x1//title, $j in $x2//title
where $i = $j
return <book>{$i,$x1//name,$bk//author[name != "Jeff"][book/title = $i]/name}</book>
```

## 1.2 Return all the author pairs who have co-authored two or more books together, list their co-authored books’ information.

Sample output format:
```
<coauthor>
<output>
<name>author1</name>
<name>author2</name>
<book year="the book year">
<title>the book title</title>
<category>the book category</category>
<rating>the book rating</rating>
<price>the book price</price>
</book>
</output>
<output>
<name>author1</name>
<name>author2</name>
<book year="the book year">
<title>the book title</title>
<category>the book category</category>
<rating>the book rating</rating>
<price>the book price</price>
</book>
</output>
......
</coauthor>
......
```
### XQuery(1.2):
```
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
```

## 1.3 Find the average book price of each category and global. If a category has higher than global average book price, list one most expensive book and its authors, for each of those categories.

Sample output format:
```
<result>
<categories>
<output>
<category>DB</category>
<title>Database systems</title>
<price>1000</price>
<name>author1</name>
<name>author2</name>
<name>......</name>
</output>
</categories>
......
</result>
```
### XQuery(1.3):
```
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
```

## 1.4 Return all the book price and rating with book name and sort the price and rating from high to low separately.

Sample output format 1.4a:
```
<title>Applied Mathematics</title>
<price>100</price>
<title>Introduction to R programming<title/>
<price>200</price>
<title>Introduction to Python<title/>
<price>300</price>
<title>Big data analytics<title/>
<price>400</price>
...
```
### XQuery(1.4a):
```
let $bk := doc("/db/books.xml")//book
let $r := (for $i in distinct-values($bk/title) return $bk[title = $i][1])
for $i in $r order by xs:float($i/price) return ($i/title,$i/price)
```

Sample output format 1.4b:
```
<title>Applied Functional Analysis</title>
<rating>2</rating>
<title>Applied Mathematics</title>
<rating>2.1</rating>
<title>AWS: Security Best Practices on AWS</title>
<rating>2.7</rating>
<title>Introduction to R programming</title>
<rating>3.2</rating>
<title>Big data analytics</title>
<rating>3.5</rating>
...
```
### XQuery(1.4b):
```
let $bk := doc("/db/books.xml")//book
let $r := (for $i in distinct-values($bk/title) return $bk[title = $i][1])
for $i in $r order by xs:float($i/rating) descending return ($i/title,$i/rating)
```

## 1.5 The text book requirement in this class is based on ‘category’: one ‘DB’, one ‘PL’, one ‘Science’, one ‘Others’. Return your plan for the book purchasing. The plan should follow some second rules (cheapest (1), best rating (1), assume you have $1800 how to get the best rating books (2))

Sample output format 1.5a:
```
<title>Big data analytics</title>
<price>400</price>
<category>DB</category>
<title>Applied Functional Analysis</title>
<price>400</price>
<category>Others</category>
<title>Introduction to R programming</title>
<price>200</price>
<category>PL</category>
<title>Applied Mathematics</title>
<price>100</price>
<category>Science</category>
```
### XQuery(1.5a):
```
let $bk := doc("/db/books.xml")//author
let $ca := (for $i in distinct-values($bk//category) return $i)
for $i in $ca let $temp := (for $j in $bk/book[category = $i] order by xs:float($j/price)
return $j)[1] return ($temp/title,$temp/price,$temp/category)
```

Sample output format 1.5b:
```
<title>Database systems</title>
<rating>5</rating>
<category>DB</category>
<title>Pattern Recognition</title>
<rating>5</rating>
<category>Others</category>
<title>Introduction to Python</title>
<rating>4.7</rating>
<category>PL</category>
<title>Statistical Inference</title>
<rating>5</rating>
<category>Science</category>
```
### XQuery(1.5b):
```
let $bk := doc("/db/books.xml")//author
let $ca := (for $i in distinct-values($bk//category) return $i)
for $i in $ca let $temp := (for $j in $bk/book[category = $i] order by xs:float($j/rating) descending
return $j)[1] return  ($temp/title,$temp/rating,$temp/category)
```

### XQuery(1.5c):
```
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
```

## 1.6 Define a DTD for an equivalent DTD data format B which stores the same information as A, but in which the authors are listed under their books. Write an XQuery query whose input is an XML document valid with respect to the DTD A and whose output is another XML document valid with respect to B.

### XQuery(1.6):
```
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
```
### Output DTD:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE biblio[
<!ELEMENT biblio (book*)>
<!ELEMENT book (title,category,rating,price,author*)>
<!ELEMENT title (#PCDATA)>
<!ELEMENT category (#PCDATA)>
<!ELEMENT rating (#PCDATA)>
<!ELEMENT price (#PCDATA)>
<!ELEMENT author (#PCDATA)>
<!ATTLIST book year CDATA #REQUIRED>
]>
```
