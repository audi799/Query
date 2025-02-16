declare @startYmdProg varchar(10)
declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @startYmdProg = '2020-01-01'
set @ymd_1 = '2020-04-01'
set @ymd_2 = '2020-04-30'

select M.maechul_gubun, M.cust_code, convert(varchar(7), P.ymd, 120) ym, P.gyesanseo_gubun, sum(P.hapgye) hapgye_geumaek 
     into #tmp_01 
     from gs_maechul M, gs_maechul_pm P
    where P.gyesanseo_yy = M.yy 
      and P.gyesanseo_gubun = M.gubun 
      and P.gyesanseo_mm = M.mm 
      and P.gyesanseo_no = M.no 
      and M.gyesanseo_ilja >= @ymd_1 
      and M.gyesanseo_ilja <= @ymd_2 
 group by M.maechul_gubun, M.cust_code, convert(varchar(7), P.ymd, 120), P.gyesanseo_gubun

select maechul_gubun, cust_code, gyesanseo_gubun, ym, sum(hapgye_geumaek) hapgye_geumaek
     into #tmp_02 
     from #tmp_01 
    where ym = left(@ymd_1, 7) 
 group by maechul_gubun, cust_code, gyesanseo_gubun, ym 

select maechul_gubun, cust_code, gyesanseo_gubun, max(ym) ym, sum(hapgye_geumaek) hapgye_geumaek
     into #tmp_03 
     from #tmp_01 
    where ym <> left(@ymd_1, 7) 
 group by maechul_gubun, cust_code, gyesanseo_gubun 

select * into #tmp_04 from #tmp_02 union all 
select *              from #tmp_03 

select case when isnull(C.cust_gubun_2,1) = 3 then cast(0 as tinyint) else cast(1 as tinyint) end sortGubun1, 
       case when T.ym = left(@ymd_1, 7) then cast(0 as tinyint) else cast(1 as tinyint) end sortGubun2, 
       T.maechul_gubun, T.cust_code, C.sangho, G.gubun_name cust_gubun_name,
       cast(T.hapgye_geumaek as numeric(18,0)) hapgye_geumaek, 
       case when T.ym = left(@ymd_1, 7) then cast(11 as tinyint) else cast(12 as tinyint) end gubun
     into #tmp_05 
     from #tmp_04 T left outer join cm_cust C 
                                 on C.cust_code = T.cust_code 
                    left outer join cm_cust_gubun G
                                 on G.cust_gubun = C.cust_gubun_2
select left(@ymd_1, 7) ym, sortGubun1, 
       case sortGubun1 when 0 then cast('관수' as varchar(10)) when 1 then cast('민수' as varchar(10)) end sortName1, sortGubun2, 
       case sortGubun2 when 0 then cast('당월발행금액' as varchar(20)) when 1 then cast('전월발행금액' as varchar(20)) end sortName2, 
       case when isnull(maechul_gubun,1) = 1 then cast('전자세금계산서' as varchar(14))
            when isnull(maechul_gubun,1) = 2 then cast('현금영수증' as varchar(14))
            when isnull(maechul_gubun,1) = 3 then cast('카드매출' as varchar(14)) end maechul_gubun_name,
       cust_code, sangho, cust_gubun_name, gubun, hapgye_geumaek
     from #tmp_05 
 order by sortGubun1, sortGubun2, cust_gubun_name, sangho 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05 
