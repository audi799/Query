declare @ymd varchar(10)
declare @week_1 varchar(10)
declare @week_2 varchar(10)

set @ymd = getdate()
set @week_1 = ( select convert(char(10), dateadd(wk, DATEDIFF(wk,0, @ymd), 0), 120) )
set @week_2 = ( select convert(char(10), dateadd(wk, DATEDIFF(wk,0, @ymd), 6), 120) )

select ymd, car_code, min(operation_start_time) start_working_time, max(operation_end_time) end_working_time,
       datediff(s, min(operation_start_time), max(operation_end_time)) diffTime
     into #tmp_01
     from RM_B09_car_operation
    where ymd >= @week_1
      and ymd <= @week_2
 group by ymd, car_code

select car_code,
       case when ymd < @ymd then count(*) else 0 end cnt,
       sum(diffTime) week_second
     into #tmp_02
     from #tmp_01
 group by car_code, ymd

select car_code,
       sum(cnt) lunch_cnt,
       sum(week_second) week_second,
       cast(null as varchar(8)) week_time
     into #tmp_03
     from #tmp_02
 group by car_code

update #tmp_03 set week_second = week_second - (lunch_cnt * 3600) where week_second > 0
update #tmp_03 set week_time = stuff(convert(varchar, dateadd(s, week_second, ''), 108), 1, 2, week_second / 3600)
update #tmp_03 set week_time = '0' + week_time where len(week_time) = 7

select *
     from #tmp_03
 order by car_code

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
