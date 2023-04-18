USE classicmodels;

ALTER TABLE `products`
    ADD FULLTEXT (`productName`);

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

SELECT *
FROM employees
WHERE lastName REGEXP 'son$';

SELECT *
FROM employees
WHERE firstName REGEXP '^[L-M].e';

SELECT *
FROM employees
WHERE firstName REGEXP '^.{10}$';

SELECT *
FROM employees
WHERE firstName REGEXP '^[L|M]';

SELECT id,
       Nombre,
       MATCH(Nombre) AGAINST('Audra Acevedo' IN NATURAL LANGUAGE MODE) as score
FROM mytable
HAVING score > 0
ORDER BY score DESC;