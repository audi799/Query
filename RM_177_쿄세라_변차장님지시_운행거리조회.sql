declare @ymd_1 varchar(10) 
declare @ymd_2 varchar(10) 
declare @limitDistance smallint

set @ymd_1 = '2024-07-01' 
set @ymd_2 = '2024-07-04' 
set @limitDistance = 5

select 1 gubun1, 1 gubun2, R.* , 
       (isnull(TotalDistance,0) + isnull(ReviceDistance,0)) hapsan_km, P.cust_code, P.hyeonjang_code, C.sangho, H.hyeonjang_name, A.car_code, A.suryang 
     into #tmp_01 
     from yu_driving_result R left outer join yu_chulha_plan P 
                                           on P.ymd = R.ymd 
                                          and P.nno = R.chulha_plan_no 
                              left outer join yu_chulha A 
                                           on A.ymd = R.ymd 
                                          and A.nno = R.nno 
                              left outer join cm_cust C 
                                           on C.cust_code = P.cust_code 
                              left outer join cm_hyeonjang H 
                                           on H.cust_code = P.cust_code 
                                          and H.hyeonjang_code = P.hyeonjang_code 
                              left outer join cm_car CC 
                                           on CC.car_code = A.car_code 
    where R.ymd >= @ymd_1 
      and R.ymd <= @ymd_2 

select 1 gubun1, 2 gubun2, cast(null as smalldatetime) ymd, cast(null as int) nno, cast(null as int) OrderNo, cast(null as smallint) Chulha_Plan_No, 
       cast(null as varchar(8)) StartToHyeonjangTime, cast(null as varchar(8)) ArrivedHyeonjangTime, cast(null as varchar(8)) StartToFactoryTime, 
       cast(null as varchar(8)) ArrivedFactoryTime, sum(TotalDistance) TotalDistance, sum(ReviceDistance) ReviceDistance, 
       cast(null as varchar(8)) PumpedTime, cast(null as varchar(8)) StayedInSiteTIme, cast(null as varchar(8)) TotalTime, 
       cast(null as datetime) EditedYmd, cast(0 as bit) Published, sum(hapsan_km) hapsan_km, cast(null as varchar(5)) cust_code, 
       cast(null as varchar(4)) hyeonjang_code, cast('[**소계**]' as varchar(50)) sangho, cast('[**소계**]' as varchar(50)) hyeonnang_name, car_code, 
       sum(suryang) suryang 
     into #tmp_02 
     from #tmp_01 
 group by Car_Code 

select 2 gubun1, 2 gubun2, cast(null as smalldatetime) ymd, cast(null as int) nno, cast(null as int) OrderNo, cast(null as smallint) Chulha_Plan_No, 
       cast(null as varchar(8)) StartToHyeonjangTime, cast(null as varchar(8)) ArrivedHyeonjangTime, cast(null as varchar(8)) StartToFactoryTime, 
       cast(null as varchar(8)) ArrivedFactoryTime, sum(TotalDistance) TotalDistance, sum(ReviceDistance) ReviceDistance, cast(null as varchar(8)) PumpedTime, 
       cast(null as varchar(8)) StayedInSiteTIme, cast(null as varchar(8)) TotalTime, cast(null as datetime) EditedYmd, cast(0 as bit) Published, 
       sum(hapsan_km) hapsan_km, cast(null as varchar(5)) cust_code, cast(null as varchar(4)) hyeonjang_code, cast('[**총계**]' as varchar(50)) sangho, 
       cast('[**총계**]' as varchar(50)) hyeonnang_name, cast(null as varchar(10)) car_code, sum(suryang) suryang 
     into #tmp_03 
     from #tmp_02 

select cust_code, hyeonjang_code, avg(hapsan_km) avg_hapsan_km, count(*) cnt
     into #tmp_avg
     from #tmp_01
    where StartToHyeonjangTime is not null 
      and ArrivedHyeonjangTime is not null 
      and StartToFactoryTime is not null
      and ArrivedFactoryTime is not null
      and TotalDistance is not null
 group by cust_code, hyeonjang_code

select * into #tmp_04 from #tmp_01 union all 
select *              from #tmp_02 union all 
select *              from #tmp_03 

select T.*,
       G.avg_hapsan_km, G.cnt,
       cast(null as varchar(30)) bigo
     into #tmp_05
     from #tmp_04 T left outer join #tmp_avg G
                                 on G.cust_code = T.cust_code
                                and G.hyeonjang_code = T.hyeonjang_code

update #tmp_05 set bigo = 'GPS 3회 이하'    where cnt <= 3
update #tmp_05 set bigo = 'GPS 임계치 초과' where cnt > 3 and hapsan_km > avg_hapsan_km + @limitDistance
update #tmp_05 set bigo = 'GPS 임계치 미만' where cnt > 3 and hapsan_km < avg_hapsan_km - @limitDistance
update #tmp_05 set bigo = 'GPS 통신 오류'   
             where StartToHyeonjangTime is null 
                or ArrivedHyeonjangTime is null 
                or StartToFactoryTime is null
                or ArrivedFactoryTime is null
                or TotalDistance is null

select *
     from #tmp_05
 order by gubun1, car_code, gubun2, Ymd, StartToHyeonjangTime 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05
drop table #tmp_avg

