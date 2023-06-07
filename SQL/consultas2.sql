SELECT *
from products
where match(productName) against('davidson bar' IN NATURAL LANGUAGE MODE);
select *
from (select *
      from products
      where match(productName) against('davidson bar' IN NATURAL LANGUAGE MODE)) as A,
     (select *
      from products
      where match(productDescription) against('davidson bar' IN NATURAL LANGUAGE MODE)) as B
where A.productCode = B.productCode;
################################################################
select *
from (select a.productCode,
             (a.score + b.score) as nscore
      from (select productCode, match(productName) against('davidson bar' IN NATURAL LANGUAGE MODE) as score
            from products) as a,
           (select productCode, match(productDescription) against('davidson bar' IN NATURAL LANGUAGE MODE) as score
            from products) as b
      where a.productCode = b.productCode) as c
where c.nscore > 0
ORDER BY c.nscore DESC;
################################################################
select *
from products
where match(productDescription) against('wheels rubber' IN NATURAL LANGUAGE MODE);
################################################################
select *
from products
where match(productDescription) against('wheels rubber' IN BOOLEAN LANGUAGE MODE);
################################################################
select *
from products
where match(productDescription) against('+wheels -rubber' IN BOOLEAN LANGUAGE MODE);
################################################################
select *
from products
where match(productDescription) against('-wheels +rubber' IN BOOLEAN LANGUAGE MODE);
################################################################
select id,
       Nombre
from mytable
where Nombre LIKE 'Acevedo%Audra%';
################################################################
select id,
       Nombre
from mytable MATCH(Nombre) AGAINST('Audra Acevedo' IN NATURAL LANGUAGE MODE);
################################################################
select id,
       Nombre
FROM mytable
WHERE MATCH(Nombre) AGAINST('Audra Acevedo' IN NATURAL LANGUAGE MODE);
################################################################
SELECT id,
       Nombre,
       MATCH(Nombre) AGAINST('Audra Acevedo' IN NATURAL LANGUAGE MODE) as score
FROM mytable
HAVING score > 0
ORDER BY score DESC;
################################################################
SELECT *
FROM employees
WHERE lastName REGEXP 'son$';
################################################################
SELECT *
FROM employees
WHERE firstName REGEXP '^[L|M]';
################################################################
SELECT *
FROM employees
WHERE firstName REGEXP '^[L-M].[e]';
################################################################
SELECT *
FROM employees
WHERE firstName REGEXP '^.{10}$';
