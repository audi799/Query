declare @startProgYmd varchar(10)
declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @startProgYmd = '2020-01-01'
set @ymd_1 = '2020-05-01'
set @ymd_2 = '2020-05-30'

select *,
       case when gyesanseo_mm > 10 then cast(gyesanseo_yy as varchar(4)) + '-'  + cast(gyesanseo_mm as varchar(2))
                                   else cast(gyesanseo_yy as varchar(4)) + '-0' + cast(gyesanseo_mm as varchar(2)) end gyesanseo_ym
     into #tmp_01
     from yu_panmae
    where ymd >= @startProgYmd
      and ymd <= @ymd_2

select case when C.cust_gubun_2 = 3 then cast(0 as tinyint) else cast(1 as tinyint) end sortGubun1, cast(0 as tinyint) sortGubun2, 
       T.cust_code, C.sangho, G.gubun_name cust_gubun_name, cast(21 as tinyint) gubun, sum(T.hapgye_geumaek) hapgye_geumaek 
     into #tmp_02
     from #tmp_01 T left outer join cm_cust C 
                                  on C.cust_code = T.cust_code 
                    left outer join cm_cust_gubun G
                                 on G.cust_gubun = C.cust_gubun_2
    where T.ymd >= @ymd_1 
      and T.ymd <= @ymd_2 
      and (T.gyesanseo_ym is null 
       or T.gyesanseo_ym > left(@ymd_1, 7) ) 
 group by C.cust_gubun_2, T.cust_code, C.sangho, G.gubun_name

select case when C.cust_gubun_2 = 3 then cast(0 as tinyint) else cast(1 as tinyint) end sortGubun1, cast(1 as tinyint) sortGubun2, 
       T.cust_code, C.sangho, G.gubun_name cust_gubun_name, cast(22 as tinyint) gubun, sum(T.hapgye_geumaek) hapgye_geumaek 
     into #tmp_03
     from #tmp_01 T left outer join cm_cust C 
                                  on C.cust_code = T.cust_code 
                    left outer join cm_cust_gubun G
                                 on G.cust_gubun = C.cust_gubun_2
    where T.ymd >= @startProgYmd 
      and T.ymd < @ymd_1 
      and (T.gyesanseo_ym is null 
       or T.gyesanseo_ym > left(@ymd_1, 7) ) 
 group by C.cust_gubun_2, T.cust_code, C.sangho, G.gubun_name

select * into #tmp_04 from #tmp_02 union all 
select *              from #tmp_03 

select left(@ymd_1, 7) ym, *,
       case sortGubun1 when 0 then cast('관수' as varchar(10)) when 1 then cast('민수' as varchar(10)) end sortName1, 
       case sortGubun2 when 0 then cast('당월이월분' as varchar(20)) when 1 then cast('전월이월분' as varchar(20)) end sortName2
     from #tmp_04 
 order by sortGubun1, sortGubun2, cust_gubun_name, sangho

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04
