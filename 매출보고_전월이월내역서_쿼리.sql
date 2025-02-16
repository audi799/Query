declare @startYmdProg varchar(10)
declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @startYmdProg = '2020-01-01'
set @ymd_1 = '2020-05-01'
set @ymd_2 = '2020-05-30'

select *,
       case when gyesanseo_mm > 10 then cast(gyesanseo_yy as varchar(4)) + '-'  + cast(gyesanseo_mm as varchar(2))
                                   else cast(gyesanseo_yy as varchar(4)) + '-0' + cast(gyesanseo_mm as varchar(2)) end gyesanseo_ym
     into #tmp_01
     from yu_panmae
    where ymd >= @startYmdProg
      and ymd < @ymd_1

select case when C.cust_gubun_2 = 3 then 0 else 1 end sortGubun1,
       C.sangho, T.cust_code, sum(T.hapgye_geumaek) hapgye_geumaek, 
       T.gyesanseo_ym, T.gyesanseo_yy, T.gyesanseo_mm, T.gyesanseo_gubun, T.gyesanseo_no,
       isnull(M.maechul_gubun,1) maechul_gubun,
       case when isnull(M.maechul_gubun,1) = 1 then cast('전자세금계산서' as varchar(20))
            when isnull(M.maechul_gubun,1) = 2 then cast('현금영수증' as varchar(20))
            when isnull(M.maechul_gubun,1) = 3 then cast('카드매출' as varchar(20)) end maechul_gubun_name
     into #tmp_02
     from #tmp_01 T left outer join cm_cust C
                                 on C.cust_code = T.cust_code
                    left outer join gs_maechul M
                                 on M.yy = T.gyesanseo_yy
                                and M.mm = T.gyesanseo_mm
                                and M.gubun = T.gyesanseo_gubun
                                and M.no = T.gyesanseo_no
    where T.gyesanseo_ym is not null 
      and gyesanseo_ym = left(@ymd_1,7)
--      and gyesanseo_ym <> left(@ymd_1,7)
 group by C.cust_gubun_2, C.sangho, T.cust_code, T.gyesanseo_ym, T.gyesanseo_yy, T.gyesanseo_mm, T.gyesanseo_gubun, T.gyesanseo_no, M.maechul_gubun

select M.cust_code, count(*) cnt
     into #tmp_03                    
     from #tmp_02 T left outer join gs_maechul M
                                 on M.yy = T.gyesanseo_yy
                                and M.mm = T.gyesanseo_mm
                                and M.gubun = T.gyesanseo_gubun
                                and M.no = T.gyesanseo_no
 group by M.cust_code

select T.*, T3.cnt,
       case when T.sortGubun1 = 0 then cast('관수' as varchar(4)) 
            when T.sortGubun1 = 1 then cast('민수' as varchar(4)) end sortGubun_name
     from #tmp_02 T left outer join #tmp_03 T3
                                 on T.cust_code = T3.cust_code
 order by T.sortGubun1

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
