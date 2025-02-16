CREATE TEMPORARY TABLE tmp_01 (cust_code VARCHAR(50), sisan INT);
CREATE TEMPORARY TABLE tmp_02 (cust_code VARCHAR(50), panmae BIGINT);
CREATE TEMPORARY TABLE tmp_03 (cust_code VARCHAR(50), ipgeum BIGINT);
CREATE TEMPORARY TABLE tmp_04 (cust_code VARCHAR(50));

INSERT INTO tmp_01 (cust_code, sisan)
SELECT cust_code, SUM(geumaek) sisan
     FROM yu_sisan
    WHERE YEAR = 2024
 GROUP BY cust_code;

INSERT INTO tmp_02 (cust_code, panmae)
SELECT cust_code, SUM(hapgye_geumaek) panmae
     FROM yu_panmae
     WHERE ymd >= '2024-01-01'
       AND ymd <= '2024-11-15'
 GROUP BY cust_code;

INSERT INTO tmp_03 (cust_code, ipgeum)
SELECT cust_code, ifnull(SUM(geumaek),0) + ifnull(SUM(halin_geumaek),0) - ifnull(SUM(japiik),0) ipgeum
     FROM yu_ipgeum
     WHERE ymd >= '2024-01-01'
       AND ymd <= '2024-11-15'
 GROUP BY cust_code;

INSERT INTO tmp_04 (cust_code)
SELECT cust_code FROM tmp_01 UNION ALL
SELECT cust_code FROM tmp_02 UNION ALL
SELECT cust_code FROM tmp_03;

SELECT T4.cust_code, T1.sisan, T2.panmae, T3.ipgeum
     FROM tmp_04 T4 LEFT OUTER JOIN tmp_01 T1
                                 ON T1.cust_code = T4.cust_code
                    LEFT OUTER JOIN tmp_02 T2
                                 ON T2.cust_code = T4.cust_code
                    LEFT OUTER JOIN tmp_03 T3
                                 ON T3.cust_code = T4.cust_code;
 
DROP TEMPORARY TABLE if EXISTS tmp_01;
DROP TEMPORARY TABLE if EXISTS tmp_02;
DROP TEMPORARY TABLE if EXISTS tmp_03;
DROP TEMPORARY TABLE if EXISTS tmp_04;
