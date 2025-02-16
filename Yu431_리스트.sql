declare @startProgYmd varchar(10), @ymd_1 varchar(10), @ymd_2 varchar(10), @custCode_1 varchar(5), @custCode_2 varchar(5)

set @startProgYmd = '2014-01-01'
set @custCode_1 = '10001'
set @custCode_2 = '90001'
set @ymd_1 = '2014-06-01'
set @ymd_2 = '2020-03-03'


declare @startYearYmd varchar(10)
set @startYearYmd = substring(@ymd_1, 1,4) + '-01-01'

select cust_code, sum(geumaek) sisan
     into #tmp_01
     from yu_sisan
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and year = substring(@startYearYmd, 1,4)
 group by cust_code

select cust_code, sum(hapgye_geumaek) j_panmae
     into #tmp_02
     from yu_panmae 
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and ymd >= @startProgYmd
      and ymd >= @startYearYmd
      and ymd <= @ymd_2
 group by cust_code

select cust_code, sum(isnull(geumaek, 0) + isnull(halin_geumaek,0) - isnull(japiik,0)) j_ipgeum
     into #tmp_03
     from yu_ipgeum
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and ymd >= @startProgYmd
      and ymd >= @startYearYmd
      and ymd <= @ymd_2
 group by cust_code

select cust_code into #tmp_04 from #tmp_01 union
select cust_code              from #tmp_02 union
select cust_code              from #tmp_03

select T.cust_code, (isnull(T1.sisan,0) + isnull(T2.j_panmae,0) - isnull(T3.j_ipgeum, 0)) misu
    into #tmp_05
    from #tmp_04 T left outer join #tmp_01 T1
                                on T1.cust_code = T.cust_code
                   left outer join #tmp_02 T2
                                on T2.cust_code = T.cust_code
                   left outer join #tmp_03 T3
                                on T3.cust_code = T.cust_code

select T.*, C.sangho, C.tel_1, C.tel_2, C.fax
     from #tmp_05 T left outer join cm_cust C
                                 on C.cust_code = T.cust_code

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
