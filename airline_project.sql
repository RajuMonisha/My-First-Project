-- 1) How many tickets are there without boarding passes?
select
count(*)
from tickets t 
where t.ticket_no not in (
  select distinct bp.ticket_no
  from Boarding_passes bp
  )

--2) Represent the "book_date" column in "yyyy-mm-dd" format using Booking table.
select
book_ref,
TO_CHAR (book_date, 'YYYY-MM-DD') as book_date
total_amount 
from Bookings

--3) Identify the most popular product in each store based on quantity sold
with product_sales as(
  select
  s.store_name,
  p.product_name,
  sum(oi.quantity) as quantity_sold
from order_items oi
join orders o
on oi.order_id = o.order_id
join products p 
on oi.product_id = p.product_id
join stores s
on o.store_id = s.store_id
group by s.store_name, p.product_name
),
ranked_sales as (
  select
  store_name,
  product_name,
  quantity_sold,
  row_number() over (partition by store_number order by quatity_sold desc) as rnk
)
select 
store_name,
product_name,
quantity_sold
from ranked_sales
where rnk = 1

--4) Rank airports based on the number of flights departing from them.
with airport_flights as (
  select 
  departure_airport,
  count(*) as total_flights 
  from flights 
  group by departure_airport
),
ranked_airport as (
  select departure_airport,
  total_flights,
  rank() over (order by total_flights desc) as airport_rank
  from airport_flights
)
select
departure_airport,
total_flights,
airport_rank,
from ranked_airports
order by airport_rank;











