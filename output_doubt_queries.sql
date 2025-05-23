--MY CODE

WITH category_net AS(
    SELECT
        p.categoryname,
        round((s.quantity * s.netprice * s.exchangerate)::numeric,2) as "net revenue",
        s.orderdate,
        EXTRACT(YEAR from s.orderdate)::numeric as year
    FROM
        sales s
    LEFT JOIN
        product p ON s.productkey = p.productkey
    WHERE
        s.orderdate between '2022-01-01' and '2023-12-31'
),
percentile_value AS(
    SELECT      
        percentile_cont(0.25) within group (order by(round((s.quantity * s.netprice * s.exchangerate)::numeric,2))) as revenue25th,
        percentile_cont(0.75) within group (order by(round((s.quantity * s.netprice * s.exchangerate)::numeric,2))) as revenue75th
    from 
        sales s
    WHERE
        EXTRACT(YEAR from s.orderdate)::numeric between 2022 and 2023
),
categorized as(
    SELECT
        c.categoryname,
        case
            when c."net revenue" <= p.revenue25th then '3 - LOW'
            when c."net revenue" >= p.revenue75th then '1 - HIGH'
            else '2 - MEDIUM'
        end as "revenue type",
        sum(c."net revenue") "total revenue"
    FROM
        category_net c,
        percentile_value p
    GROUP BY
        c.categoryname,
        "revenue type"
    order BY
        c.categoryname,
        "revenue type"
)
SELECT
    categoryname,
    "revenue type",
    "total revenue",
    ROUND("total revenue" / SUM("total revenue") OVER (PARTITION BY categoryname) * 100, 2) AS "percent of category"
FROM
    categorized
GROUP BY
    categoryname,
    "total revenue",
    "revenue type"
ORDER BY
    categoryname,
    "revenue type"

-- -- YOUTUBE CODE

-- WITH percentiles AS (
--     SELECT
--         PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY (s.quantity * s.netprice * s.exchangerate)) AS revenue_25th_percentile,
--         PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY (s.quantity * s.netprice * s.exchangerate)) AS revenue_75th_percentile
--     FROM
--         sales s
--     WHERE
--         orderdate BETWEEN '2022-01-01' AND '2023-12-31'
-- )

-- SELECT
--     p.categoryname AS category,
--     CASE
--         WHEN (s.quantity * s.netprice * s.exchangerate) <= pctl.revenue_25th_percentile THEN 'LOW'
--         WHEN (s.quantity * s.netprice * s.exchangerate) >= pctl.revenue_75th_percentile THEN 'HIGH'
--         ELSE 'MEDIUM'
--     END AS revenue_tier,
--     SUM(s.quantity * s.netprice * s.exchangerate) AS total_revenue
-- FROM
--     sales s
--     LEFT JOIN product p ON s.productkey = p.productkey,
--     percentiles pctl
-- GROUP BY
--     p.categoryname,
--     revenue_tier
-- order by
--     p.categoryname,
--     revenue_tier

-- -- TEST CODE

-- SELECT
--         p.categoryname,
--         sum(s.quantity * s.netprice * s.exchangerate) as "net revenue"
--         -- s.orderdate,
--         -- EXTRACT(YEAR from s.orderdate)::numeric as year
--     FROM
--         sales s
--     LEFT JOIN
--         product p ON s.productkey = p.productkey
--     WHERE
--         (s.orderdate between '2022-01-01' and '2023-12-31')
--         -- and (s.quantity * s.netprice * s.exchangerate) <= 111.070125       --111.070125 is the 0.25 percentile value
--         and (s.quantity * s.netprice * s.exchangerate) >= 1062.1200218024999       --1062.1200218024999 is the 0.75 percentile value
--         and p.categoryname = 'TV and Video'
--     GROUP by
--         p.categoryname
