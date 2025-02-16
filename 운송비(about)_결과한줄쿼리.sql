declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-05-01'
set @ymd_2 = '2020-05-31'

select N.car_code, sum(N.cnt_chulha) jiep_cnt_chulha
     into #tmp_01
     from yu_unbanbi_naeyeok N left outer join cm_car C
                                            on C.car_code = N.car_code
    where N.ymd >= @ymd_1
      and N.ymd <= @ymd_2
      and C.gubun = 2
 group by N.car_code

select count(*) car_cnt, sum(jiep_cnt_chulha) jiep_cnt_chulha,
       ( sum(jiep_cnt_chulha) / count(*) ) ave_jiep_hoejeonsu
     into #tmp_02
     from #tmp_01

select sum(N.total_geori) total_geori, sum(N.cnt_chulha) cnt_chulha, sum(total_suryang) total_suryang,
       round(sum(N.total_geori) / sum(N.cnt_chulha), 2) ave_geori,
       round(sum(N.total_suryang) / sum(N.cnt_chulha), 2) ave_suryang,
       D.danga_C yuryudae
     into #tmp_03
     from yu_unbanbi_naeyeok N left outer join cm_car C
                                            on C.car_code = N.car_code
                               left outer join cm_unbanbi_danga D
                                            on D.yy = left(@ymd_1, 4)
                                           and D.mm = substring(@ymd_1, 6, 2)
                                           and D.car_gubun = 4
    where N.ymd >= @ymd_1
      and N.ymd <= @ymd_2
 group by D.danga_C

select T3.*, T2.*
     from #tmp_03 T3, #tmp_02 T2

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
