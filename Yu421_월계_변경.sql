select 1 gubun, P.pummok_code, P.jepum_code, 
       sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek,
       K.pummok_name, J.jepum_name, J.jepum_yakeo
     into #tmp_01
     from yu_panmae P left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd = '2020-04-08'
 group by P.pummok_code, P.jepum_code, K.pummok_name, J.jepum_name, J.jepum_yakeo

select 2 gubun, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code, 
       sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       cast(null as varchar(20)) pummok_name, cast('일  계' as varchar(50)) jepum_name, cast('일  계' as varchar(50)) jepum_yakeo
     into #tmp_02
     from #tmp_01

select 3 gubun, P.pummok_code, P.jepum_code, 
       sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek,
       K.pummok_name, J.jepum_name, J.jepum_yakeo
     into #tmp_03
     from yu_panmae P left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd >= '2020-04-01'
      and P.ymd <= '2020-04-09'
 group by P.pummok_code, P.jepum_code, K.pummok_name, J.jepum_name, J.jepum_yakeo

select 4 gubun, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code, 
       sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       cast(null as varchar(20)) pummok_name, cast('월  계' as varchar(50)) jepum_name, cast('월  계' as varchar(50)) jepum_yakeo
     into #tmp_04
     from #tmp_03

select * into #tmp_05 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03 union all
select *              from #tmp_04

select *
     from #tmp_05
 order by gubun, jepum_yakeo, jepum_name

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05

-- 품목명 / 제품명 / 수량 / 금액 / 세액 / 합계
