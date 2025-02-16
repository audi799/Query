/*
*계산식
  - 유류환산             : (운행키로수 * 0.6) + 20 - 주유량 - 보관/현금정산 // 버림처리
  - 유류환산(부가세포함) : IF 주유량 > 0 THEN 0 
                                         ELSE 유류환산 * 1200

  - 일대차운반비         : 일대비 + 철야/OT
  - 지입차운반비         : IF(운송횟수 < 기본보장(80회전) THEN 1회전(45,000원) * 기본보장(80회전) 
                                                          ELSE 1회전(45,000원) * 운송횟수
*/


declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-05-01'
set @ymd_2 = '2020-05-31'

select car_gubun, Danga_A hoejeon_Danga, Danga_B gibon_hoejeon, Danga_C yuryudae
     into #tmp_01
     from cm_unbanbi_danga
    where yy = left(@ymd_1, 4)
      and mm = cast(substring(@ymd_1, 6, 2) as int)

select C.gubun car_gubun, N.car_code, sum(N.cnt_chulha) cnt_chulha, sum(N.cnt_mul) cnt_mul, 
       sum(N.total_geori) total_geori, sum(N.total_suryang) total_suryang, sum(N.value_A) juyuryang,
       sum(N.value_C) tonghaengryo, sum(N.value_D) OT_geumaek,
       T1.hoejeon_danga, T1.gibon_hoejeon, T1.yuryudae,
       cast(null as int) unsongbi, cast(null as int) total_unsongbi, 
       cast(null as int) yuryubi
     into #tmp_02
     from yu_unbanbi_naeyeok N left outer join cm_car C
                                            on C.car_code = N.car_code
                               left outer join #tmp_01 T1
                                            on T1.car_gubun = C.gubun
    where N.ymd >= @ymd_1
      and N.ymd <= @ymd_2
      and C.gubun = 2
 group by C.gubun, N.car_code, T1.hoejeon_danga, T1.gibon_hoejeon, T1.yuryudae

update #tmp_02 set unsongbi       = gibon_hoejeon * hoejeon_danga where cnt_chulha < gibon_hoejeon
update #tmp_02 set unsongbi       = cnt_chulha * hoejeon_danga    where cnt_chulha >= gibon_hoejeon
update #tmp_02 set total_unsongbi = isnull(unsongbi,0) + isnull(tonghaengryo,0) + isnull(OT_geumaek,0)
update #tmp_02 set yuryubi        = isnull(juyuryang,0) * (isnull(yuryudae,0) / 1.1)

select T.car_gubun, 
       sum(T.total_unsongbi) total_unsongbi, sum(T.yuryubi) yuryubi, sum(T.total_suryang) total_suryang,
       G.gubun_name, cast(null as int) ave_unsongbi
     into #tmp_jiep 
     from #tmp_02 T left outer join cm_car_gubun G
                                   on G.car_gubun = T.car_gubun
 group by T.car_gubun, G.gubun_name

update #tmp_jiep set ave_unsongbi = ( isnull(total_unsongbi,0) + isnull(yuryubi,0) ) / isnull(total_suryang,0)

select C.gubun car_gubun, N.car_code, sum(N.cnt_chulha) cnt_chulha, sum(N.cnt_mul) cnt_mul, 
       sum(N.total_geori) total_geori, sum(N.total_suryang) total_suryang, sum(N.value_A) juyuryang,
       sum(N.value_B) ildaebi, sum(N.value_C) tonghaengryo, sum(N.value_D) OT_geumaek,
       T1.hoejeon_danga, T1.gibon_hoejeon, T1.yuryudae,
       cast(null as int) total_unsongbi,
       cast(null as numeric(18,2)) hwansan, cast(null as numeric(18,2)) yuryu_hwansan,
       cast(null as int) yuryubi
     into #tmp_03
     from yu_unbanbi_naeyeok N left outer join cm_car C
                                            on C.car_code = N.car_code
                               left outer join #tmp_01 T1
                                            on T1.car_gubun = C.gubun
    where N.ymd >= @ymd_1
      and N.ymd <= @ymd_2
      and C.gubun = 4
 group by C.gubun, N.car_code, T1.hoejeon_danga, T1.gibon_hoejeon, T1.yuryudae

update #tmp_03 set total_unsongbi = isnull(ildaebi,0) + isnull(OT_geumaek,0)
update #tmp_03 set hwansan        = (isnull(total_geori,0) * 0.6) + 20 - isnull(juyuryang,0)
update #tmp_03 set hwansan        = round(hwansan,0)
update #tmp_03 set yuryu_hwansan  = 0                  where juyuryang > 0
update #tmp_03 set yuryu_hwansan  = hwansan * yuryudae where juyuryang <= 0
update #tmp_03 set yuryubi        = juyuryang * (yuryudae / 1.1) + (yuryu_hwansan / 1.1)

select T.car_gubun, 
       sum(T.total_unsongbi) total_unsongbi, sum(T.yuryubi) yuryubi, sum(T.total_suryang) total_suryang,
       G.gubun_name, cast(null as int) ave_unsongbi
     into #tmp_ildae 
     from #tmp_03 T left outer join cm_car_gubun G
                                    on G.car_gubun = T.car_gubun
 group by T.car_gubun, G.gubun_name

update #tmp_ildae set ave_unsongbi = ( isnull(total_unsongbi,0) + isnull(yuryubi,0) ) / isnull(total_suryang,0)

select 1 sortGubun, * into #tmp_04 from #tmp_jiep union all
select 2 sortGubun, *              from #tmp_ildae

select 3 sortGubun, 
       sum(total_unsongbi) total_unsongbi, sum(yuryubi) yuryubi, sum(total_suryang) total_suryang,
       cast('[계]' as varchar(10)) gubun_name, cast(null as int) ave_unsongbi
     into #tmp_05
     from #tmp_04

select 4 sortGubun, 
       round((total_unsongbi / total_suryang), 0) ave_unsongbi,
       round((yuryubi / total_suryang), 0) ave_yuryubi,
       round((total_unsongbi / total_suryang), 0) + round((yuryubi / total_suryang), 0) ave,
       cast('운송료/㎥' as varchar(10)) gubun_name
     into #tmp_06
     from #tmp_05

select sortGubun, total_unsongbi, yuryubi, gubun_name, ave_unsongbi into #tmp_07 from #tmp_04 union all
select sortGubun, total_unsongbi, yuryubi, gubun_name, ave_unsongbi              from #tmp_05 union all
select sortGubun, ave_unsongbi, ave_yuryubi, gubun_name, ave                     from #tmp_06

select sortGubun, gubun_name,
       cast(total_unsongbi as int) total_unsongbi,
       cast(yuryubi as int) yuryubi,
       cast(ave_unsongbi as int) ave_unsongbi
     from #tmp_07
 order by sortGubun

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_jiep
drop table #tmp_04
drop table #tmp_ildae
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07

--리포트에 표현하기에 문제
--계산식이 시트이동하면서 계산되다보니, 좀문제가있을듯함.
--일대차에서 보관/현금정산은 먼가?
-- 회전, 물차, 수량, 운행, 평균거리




