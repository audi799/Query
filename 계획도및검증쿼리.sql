/*
    *가져오기 버튼 만들어야할듯함.
    RM_B05_Car_Working_Time
    [Ymd] -- smalldatetime
    [Nno] -- int
    Start_Operation_No -- int 
    End_Operation_No -- int 
    Car_Code  -- varchar(20)
    Start_Working_Time -- min(operation_start_time) varchar(20)
    End_Working_Time   -- max(operation_end_time) varchar(20)
    Bigo -- varchar(50)
*/

declare @StartOfMonth varchar(10)

declare @OneWeek_1 varchar(10)
declare @OneWeek_2 varchar(10)

declare @TwoWeek_1 varchar(10)
declare @TwoWeek_2 varchar(10)

declare @ThreeWeek_1 varchar(10)
declare @ThreeWeek_2 varchar(10)

declare @FourWeek_1 varchar(10)
declare @FourWeek_2 varchar(10)

declare @FiveWeek_1 varchar(10)
declare @FiveWeek_2 varchar(10)

set @StartOfMonth = '2021-07-01'

/*
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 0)  -- 첫째주의 월요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 6)  -- 첫째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 7)  -- 둘째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 13) -- 둘째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 14) -- 셋째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 20) -- 셋째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 21) -- 넷째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 27) -- 넷째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 28) -- 다섯째주의 일요일을찾아냄.
select dateadd(wk, datediff(wk, 0, @StartOfMonth), 34) -- 다섯째주의 일요일을찾아냄.
*/

set @OneWeek_1 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 0)
set @OneWeek_2 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 6)

set @TwoWeek_1 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 7)
set @TwoWeek_2 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 13)

set @ThreeWeek_1 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 14)
set @ThreeWeek_2 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 20)

set @FourWeek_1 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 21)
set @FourWeek_2 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 27)

set @FiveWeek_1 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 28)
set @FiveWeek_2 = dateadd(wk, datediff(wk, 0, @StartOfMonth), 34)

select ymd, nno, end_operation_no, car_code, start_working_time, end_working_time,
       datediff(second, start_working_time, end_working_time) diffTime, null as bigo
     into #tmp_01
     from RM_B05_car_working_time
    where ymd >= @OneWeek_1
      and ymd <= @FiveWeek_2

select car_code,
       case when ymd >= @OneWeek_1 and ymd <= @OneWeek_2 then sum(diffTime) else 0 end one_week_second,
       case when ymd >= @TwoWeek_1 and ymd <= @TwoWeek_2 then sum(diffTime) else 0 end two_week_second,
       case when ymd >= @ThreeWeek_1 and ymd <= @ThreeWeek_2 then sum(diffTime) else 0 end three_week_second,
       case when ymd >= @FourWeek_1 and ymd <= @FourWeek_2 then sum(diffTime) else 0 end four_week_second,
       case when ymd >= @FiveWeek_1 and ymd <= @FiveWeek_2 then sum(diffTime) else 0 end five_week_second
     into #tmp_02
     from #tmp_01
 group by car_code, ymd

select car_code,
       sum(one_week_second) one_week_second,
       sum(two_week_second) two_week_second,
       sum(three_week_second) three_week_second,
       sum(four_week_second) four_week_second,
       sum(five_week_second) five_week_second,
       cast(null as varchar(8)) one_week_time,
       cast(null as varchar(8)) two_week_time,
       cast(null as varchar(8)) three_week_time,
       cast(null as varchar(8)) four_week_time,
       cast(null as varchar(8)) five_week_time
     into #tmp_03
     from #tmp_02
 group by car_code

update #tmp_03 set one_week_time = stuff(convert(varchar, dateadd(s, one_week_second, ''), 108), 1, 2, one_week_second / 3600)
update #tmp_03 set two_week_time = stuff(convert(varchar, dateadd(s, two_week_second, ''), 108), 1, 2, two_week_second / 3600)
update #tmp_03 set three_week_time = stuff(convert(varchar, dateadd(s, three_week_second, ''), 108), 1, 2, three_week_second / 3600)
update #tmp_03 set four_week_time = stuff(convert(varchar, dateadd(s, four_week_second, ''), 108), 1, 2, four_week_second / 3600)
update #tmp_03 set five_week_time = stuff(convert(varchar, dateadd(s, five_week_second, ''), 108), 1, 2, five_week_second / 3600)

update #tmp_03 set one_week_time = '0' + one_week_time where len(one_week_time) = 7 
update #tmp_03 set two_week_time = '0' + two_week_time where len(two_week_time) = 7 
update #tmp_03 set three_week_time = '0' + three_week_time where len(three_week_time) = 7 
update #tmp_03 set four_week_time = '0' + four_week_time where len(four_week_time) = 7 
update #tmp_03 set five_week_time = '0' + five_week_time where len(five_week_time) = 7 

select *,
	cast(@OneWeek_1 as smalldatetime) OneWeek_1, cast(@OneWeek_2 as smalldatetime) OneWeek_2, 
	cast(@TwoWeek_1 as smalldatetime) TwoWeek_1, cast(@TwoWeek_2 as smalldatetime) TwoWeek_2, 
	cast(@ThreeWeek_1 as smalldatetime) ThreeWeek_1, cast(@ThreeWeek_2 as smalldatetime) ThreeWeek_2, 
	cast(@FourWeek_1 as smalldatetime) FourWeek_1, cast(@FourWeek_2 as smalldatetime) FourWeek_2, 
	cast(@FiveWeek_1 as smalldatetime) FiveWeek_1, cast(@FiveWeek_2 as smalldatetime) FiveWeek_2 
     from #tmp_03
 order by car_code

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03


