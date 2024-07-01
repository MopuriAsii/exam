#### Schemas
use exam

```sql
CREATE TABLE artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);

CREATE TABLE artworks (
    artwork_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    artist_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    artwork_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

INSERT INTO artists (artist_id, name, country, birth_year) VALUES
(1, 'Vincent van Gogh', 'Netherlands', 1853),
(2, 'Pablo Picasso', 'Spain', 1881),
(3, 'Leonardo da Vinci', 'Italy', 1452),
(4, 'Claude Monet', 'France', 1840),
(5, 'Salvador Dalí', 'Spain', 1904);

INSERT INTO artworks (artwork_id, title, artist_id, genre, price) VALUES
(1, 'Starry Night', 1, 'Post-Impressionism', 1000000.00),
(2, 'Guernica', 2, 'Cubism', 2000000.00),
(3, 'Mona Lisa', 3, 'Renaissance', 3000000.00),
(4, 'Water Lilies', 4, 'Impressionism', 500000.00),
(5, 'The Persistence of Memory', 5, 'Surrealism', 1500000.00);

INSERT INTO sales (sale_id, artwork_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-01-15', 1, 1000000.00),
(2, 2, '2024-02-10', 1, 2000000.00),
(3, 3, '2024-03-05', 1, 3000000.00),
(4, 4, '2024-04-20', 2, 1000000.00);
```

select * from artists;
select * from artworks;
select * from sales;




--### Section 1: 1 mark each

--1. Write a query to calculate the price of 'Starry Night' plus 10% tax.

select * from artists;
select * from artworks;
select * from sales;

create function dbo.price(@ntitle varchar(30))
returns decimal
as
begin
declare @new decimal;
set @new=(select artworks.price*1.1 from artworks where artworks.title=@ntitle)
return @new;
end

select dbo.price('Starry Night')
--2. Write a query to display the artist names in uppercase.


select * from artists;
select * from artworks;
select * from sales;


select (artists.name.uppercase())
as 


--3. Write a query to extract the year from the sale date of 'Guernica'.

select year(sale_date) as year from sales where sales.artwork_id=2;



--4. Write a query to find the total amount of sales for the artwork 'Mona Lisa'.

select sum(total_amount) as total_sales from sales where artwork_id=3; 


--### Section 2: 2 marks each


select * from artists;
select * from artworks;
select * from sales;


--5. Write a query to find the artists who have sold more artworks than the average number of artworks sold per artist.

select avg(quantity) from sales 

select 





---6. Write a query to display artists whose birth year is earlier than the average birth year of artists from their country.
select * from artists;
select * from artworks;
select * from sales;


select artists.[name],artist_id,year(birth_year) as year from artists group by artist_id having year(birth_year)>
(select avg(birth_year) from artists group by country)





--7. Write a query to create a non-clustered index on the `sales` table to improve query performance for queries filtering by `artwork_id`.

create nonclustered index index1 on sales[artwork_id ]




---8. Write a query to display artists who have artworks in multiple genres.

select * from artists;
select * from artworks;
select * from sales;

select artists.name,genre from artists left join artworks 
on artists.artist_id=artworks.artist_id
group by artworks.genre,artists.name having count(artworks.genre)>1


--9. Write a query to rank artists by their total sales amount and display the top 3 artists.

select * from artists;
select * from artworks;
select * from sales;


select top(3) artists.name,sum(total_amount) as total_sum from artists inner join artworks
on artists.artist_id=artworks.artist_id inner join sales on artworks.artwork_id=sales.artwork_id
group by artists.name order by sum(total_amount) desc;


--10. Write a query to find the artists who have created artworks in both 'Cubism' and 'Surrealism' genres.

select * from artists;
select * from artworks;
select * from sales;

select artists.name from artists inner join artworks
on artists.artist_id=artworks.artist_id where artworks.genre='cubism'
intersect
select artists.name from artists inner join artworks
on artists.artist_id=artworks.artist_id where artworks.genre='surrealism';

--11. Write a query to find the top 2 highest-priced artworks and the total quantity sold for each.


select * from artists;
select * from artworks;
select * from sales;


select top(2) sum(price) as sum1,artwork_id from artworks group by artwork_id
order by sum(price)


--12. Write a query to find the average price of artworks for each artist.

select * from artists;
select * from artworks;
select * from sales;


select artists.artist_id,artists.name,avg(artworks.price) as average from artists left join artworks 
on artists.artist_id=artworks.artist_id group by artists.artist_id,artists.name



---13. Write a query to find the artworks that have the highest sale total for each genre.


select * from artists;
select * from artworks;
select * from sales;


select artworks.title,sum(artworks.price),artworks.genre,
rank()over(order by sum(price) desc) as rank1
from artworks group by genre,artworks.title


---14. Write a query to find the artworks that have been sold in both January and February 2024.

select * from artists;
select * from artworks;
select * from sales;

select artworks.title,month(sales.sale_date) as month,year(sales.sale_date) as year
from artworks inner join sales 
on artworks.artwork_id=sales.artwork_id group by artworks.title,sales.sale_date 
having month(sales.sale_date)='01' and year(sales.sale_date)='2024' 
intersect

select artworks.title,month(sales.sale_date) as month,year(sales.sale_date) as year
from artworks inner join sales 
on artworks.artwork_id=sales.artwork_id group by artworks.title,sales.sale_date 
having month(sales.sale_date)='02' and year(sales.sale_date)='2024' 

--15. Write a query to display the artists whose average artwork price is higher 
--than every artwork price in the 'Renaissance' genre.

select * from artists;
select * from artworks;
select * from sales;

select artists.name,avg(artworks.price),artworks.genre from artists left join artworks 
on artists.artist_id=artworks.artist_id group by artworks.genre,artists.[name] having avg(artworks.price)>
(select artists.name,artworks.price from artists left join artworks 
on artists.artist_id=artworks.artist_id where artworks.genre='Renaissance')



--### Section 3: 3 Marks Questions

--16. Write a query to create a view that shows artists who have created artworks in multiple genres.

select * from artists;
select * from artworks;
select * from sales;

create view vwArtists
as
select artists.artist_id,artists.name,artworks.genre from artists left join artworks 
on artists.artist_id=artworks.artist_id group by artists.artist_id,artists.name,artworks.genre 
having count(artworks.genre)>1

select * from vwArtists


--17. Write a query to find artworks that have a higher price than 
--the average price of artworks by the same artist.

select * from artists;
select * from artworks;
select * from sales;

create view vwAverage
as

select artworks.title,avg(price) from artworks group by artworks.title having(avg(price)) <
(select artworks.title,max(price) from artworks group by artworks.title)    


select * from vwAverage


--18. Write a query to find the average price of artworks for each artist and only include artists 
--whose average artwork price is higher than the overall average artwork price.

select * from artists;
select * from artworks;
select * from sales;

select artwork_id ,avg(price) from artworks group by artwork_id having(avg(price)) >
(select avg(price) from artworks group by artwork_id)  


--### Section 4: 4 Marks Questions

--19. Write a query to export the artists and their artworks into XML format.

select * from artists;
select * from artworks;
select * from sales;

select artists.artist_id[artists/id],artists.name[namee/name],artworks.title[title/title]
from artists inner join artworks 
on artists.artist_id=artworks.artist_id 
for xml path('artworks') ,root('artists')



---20. Write a query to convert the artists and their artworks into JSON format.

select * from artists;
select * from artworks;
select * from sales;


select artists.artist_id as 'artists.artist_id',artists.name as 'name',artworks.title as 'title'
from artists inner join artworks 
on artists.artist_id=artworks.artist_id 
for json path() ,root('artists')



--### Section 5: 5 Marks Questions

--21. Create a multi-statement table-valued function (MTVF) to return the total quantity sold 
--for each genre and use it in a query to display the results.

select * from artists;
select * from artworks;
select * from sales;

create function dbo.multi()
return multi table(@quantity decimal,@nq integer)
as
insert into multi(

select sum(quantity) as total from sales inner join artworks on artworks.artwork_id=sales.artwork_id
group by genre 


--22. Create a scalar function to calculate the average sales amount for artworks in a given genre 
--and write a query to use this function for 'Impressionism'.

create function dbo.sales1(@ngenre varchar(30))
returns decimal
as
begin
declare @new decimal;

set @new=
(select avg(total_Amount) as average from sales inner join artworks
on sales.artwork_id=artworks.artwork_id group by artworks.genre having artworks.genre=@ngenre)

return @new;
end

select dbo.sales1('Impressionism');

23. Write a query to create an NTILE distribution of artists based on their total sales, divided into 4 tiles.

--24. Create a trigger to log changes to the `artworks` table into an `artworks_log` table, 
--capturing the `artwork_id`, `title`, and a change description.

select * from artists;
select * from artworks;
select * from sales;

create table artworks_log
(
artwork_id integer identity(1,1),
title varchar(50),
change_description varchar(50)); 

select * from artworks_log

create trigger capture
on artworks
after update
insert into artworks_log
select artworks.id,'insertion',




--25. Create a stored procedure to add a new sale and update the total sales for the artwork. 
--Ensure the quantity is positive, and use transactions to maintain data integrity.



select * from artists;
select * from artworks;
select * from sales;


create procedure spNew
(
@nsale_id integer,@artwork_id integer,@sale_date date,@quantity integer,@total_amount decimal
)
begin
begin try
begin transaction
       if not exists(select * from sales where sale_id=@nsale_id) 
	   throw 60000,'not exixts',1;

	   if(quantity>0)
	   insert into sales vales(@nsale_id,@artwork_id ,@sale_date ,@quantity ,@total_amount)

	   update sales set total_amount=total_amount











### Normalization (5 Marks)

26. **Question:**
    Given the denormalized table `ecommerce_data` with sample data:

| id  | customer_name | customer_email      | product_name | product_category | product_price | order_date | order_quantity | order_total_amount |
| --- | ------------- | ------------------- | ------------ | ---------------- | ------------- | ---------- | -------------- | ------------------ |
| 1   | Alice Johnson | alice@example.com   | Laptop       | Electronics      | 1200.00       | 2023-01-10 | 1              | 1200.00            |
| 2   | Bob Smith     | bob@example.com     | Smartphone   | Electronics      | 800.00        | 2023-01-15 | 2              | 1600.00            |
| 3   | Alice Johnson | alice@example.com   | Headphones   | Accessories      | 150.00        | 2023-01-20 | 2              | 300.00             |
| 4   | Charlie Brown | charlie@example.com | Desk Chair   | Furniture        | 200.00        | 2023-02-10 | 1              | 200.00             |

Normalize this table into 3NF (Third Normal Form). Specify all primary keys, foreign key constraints, unique constraints, not null constraints, and check constraints.

### ER Diagram (5 Marks)


create table customers
(
id integer primary key,
customer_name varchar(90),
customer_email varchar(max)
);

create table products
(
product_id integer,
product_name varchar(max),
product_category varchar(max),
product_price decimal
);

create table orders
(
order_id integer unique,
order_date date,
order_quantity integer
);

--27. Using the normalized tables from Question 26, create an ER diagram. 
--Include the entities, relationships, primary keys, foreign keys, unique constraints, 
--not null constraints, and check constraints. Indicate the associations using proper ER diagram notation.