declare @startYmdProg varchar(10)
declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @startYmdProg = '2020-01-01'
set @ymd_1 = '2020-04-01'
set @ymd_2 = '2020-04-30'

select *,
       case when gyesanseo_mm > 10 then cast(gyesanseo_yy as varchar(4)) + '-'  + cast(gyesanseo_mm as varchar(2))
                                   else cast(gyesanseo_yy as varchar(4)) + '-0' + cast(gyesanseo_mm as varchar(2)) end gyesanseo_ym
     into #tmp_01
     from yu_panmae
    where ymd >= @ymd_1
      and ymd <= @ymd_2

select case when C.cust_gubun_2 <> 3                                                            then sum(T.hapgye_geumaek) else 0 end d_panmae_min_geum,
       case when C.cust_gubun_2 = 3                                                             then sum(T.hapgye_geumaek) else 0 end d_panmae_gwan_geum,
       case when cust_gubun_2 <> 3 and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1, 7)) then sum(T.hapgye_geumaek) else 0 end d_no_gyesanseo_min_geum 
       case when cust_gubun_2 = 3  and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1, 7)) then sum(T.hapgye_geumaek) else 0 end d_no_gyesanseo_gwan_geum, 
     into #tmp_02
     from #tmp_01 T left outer join cm_cust C
                                 on C.cust_code = T.cust_code
 group by C.cust_gubun_2, T.gyesanseo_ym

select sum(d_panmae_gwan_geum) d_panmae_gwan_geum, sum(d_panmae_min_geum) d_panmae_min_geum, 
       sum(d_panmae_gwan_geum) + sum(d_panmae_min_geum) d_panmae_geum,
       sum(d_no_gyesanseo_gwan_geum) d_no_gyesanseo_gwan_geum, sum(d_no_gyesanseo_min_geum) d_no_gyesanseo_min_geum,
       sum(isnull(d_no_gyesanseo_gwan_geum,0) + isnull(d_no_gyesanseo_min_geum,0)) d_no_gyesanseo_geum
     into #tmp_03
     from #tmp_02

select *,
       case when gyesanseo_mm > 10 then cast(gyesanseo_yy as varchar(4)) + '-'  + cast(gyesanseo_mm as varchar(2))
                                   else cast(gyesanseo_yy as varchar(4)) + '-0' + cast(gyesanseo_mm as varchar(2)) end gyesanseo_ym
     into #tmp_04
     from yu_panmae
    where ymd >= @startYmdProg
      and ymd <  @ymd_1

select case when cust_gubun_2 <> 3 and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1, 7)) then sum(T.hapgye_geumaek) else 0 end j_panmae_min_geum, 
       case when cust_gubun_2 = 3  and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1, 7)) then sum(T.hapgye_geumaek) else 0 end j_panmae_gwan_geum ,
       case when cust_gubun_2 <> 3 and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1,7))  then sum(T.hapgye_geumaek) else 0 end j_no_gyesanseo_min_geum,
       case when cust_gubun_2 = 3  and (gyesanseo_ym is null or gyesanseo_ym > left(@ymd_1,7))  then sum(T.hapgye_geumaek) else 0 end j_no_gyesanseo_gwan_geum
     into #tmp_05
     from #tmp_04 T left outer join cm_cust C
                                 on C.cust_code = T.cust_code
 group by C.cust_gubun_2, T.gyesanseo_ym

select sum(j_panmae_min_geum) j_panmae_min_geum, sum(j_panmae_gwan_geum) j_panmae_gwan_geum,
       sum( isnull(j_panmae_gwan_geum,0) + isnull(j_panmae_min_geum,0) ) j_panmae_geum, 
       sum(j_no_gyesanseo_min_geum) j_no_gyesanseo_min_geum, sum(j_no_gyesanseo_gwan_geum) j_no_gyesanseo_gwan_geum,
       sum( isnull(j_no_gyesanseo_gwan_geum,0) + isnull(j_no_gyesanseo_min_geum,0)) j_no_gyesanseo_geum
     into #tmp_06
     from #tmp_05

select case when isnull(C.cust_gubun_2,1) = 3  and PM.ymd >= @ymd_1 and PM.ymd <= @ymd_2 then sum(PM.hapgye) else 0 end d_gyesanseo_gwan_geum, 
       case when isnull(C.cust_gubun_2,1) <> 3 and PM.ymd >= @ymd_1 and PM.ymd <= @ymd_2 then sum(PM.hapgye) else 0 end d_gyesanseo_min_geum, 
       case when isnull(C.cust_gubun_2,1) = 3  and PM.ymd < @ymd_1                       then sum(PM.hapgye) else 0 end j_gyesanseo_gwan_geum, 
       case when isnull(C.cust_gubun_2,1) <> 3 and PM.ymd < @ymd_1                       then sum(PM.hapgye) else 0 end j_gyesanseo_min_geum 
     into #tmp_07
     from gs_maechul_pm PM, gs_maechul M left outer join cm_cust C 
                                                      on C.cust_code = M.cust_code 
   where M.yy = PM.gyesanseo_yy 
     and M.gubun = PM.gyesanseo_gubun 
     and M.mm = PM.gyesanseo_mm 
     and M.no = PM.gyesanseo_no 
     and M.yy = year(@ymd_1) 
     and M.mm = month(@ymd_1) 
  group by isnull(C.cust_gubun_2,1), PM.ymd 

select sum(d_gyesanseo_gwan_geum) d_gyesanseo_gwan_geum, sum(d_gyesanseo_min_geum) d_gyesanseo_min_geum, 
       sum( isnull(d_gyesanseo_gwan_geum,0) + isnull(d_gyesanseo_min_geum,0) ) d_gyesanseo_geum, 
       sum(j_gyesanseo_gwan_geum) j_gyesanseo_gwan_geum, sum(j_gyesanseo_min_geum) j_gyesanseo_min_geum, 
       sum( isnull(j_gyesanseo_gwan_geum,0) + isnull(j_gyesanseo_min_geum,0) ) j_gyesanseo_geum 
     into #tmp_08
     from #tmp_07

select *,
       ( isnull(T8.d_gyesanseo_gwan_geum,0)    + isnull(T8.j_gyesanseo_gwan_geum,0) )    gyesanseo_gwan_geum, 
       ( isnull(T8.d_gyesanseo_min_geum,0)     + isnull(T8.j_gyesanseo_min_geum,0) )     gyesanseo_min_geum, 
       ( isnull(T8.d_gyesanseo_geum,0)         + isnull(T8.j_gyesanseo_geum,0) )         gyesanseo_geum, 
       ( isnull(T3.d_no_gyesanseo_gwan_geum,0) + isnull(T6.j_no_gyesanseo_gwan_geum,0) ) no_gyesanseo_gwan_geum, 
       ( isnull(T3.d_no_gyesanseo_min_geum,0)  + isnull(T6.j_no_gyesanseo_min_geum,0) )  no_gyesanseo_min_geum, 
       ( isnull(T3.d_no_gyesanseo_geum,0)      + isnull(T6.j_no_gyesanseo_geum,0) )      no_gyesanseo_geum 
     from #tmp_03 T3, #tmp_06 T6, #tmp_08 T8

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07
drop table #tmp_08
