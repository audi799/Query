select 1 sortGubun, 1 sortGubun2, P.chulha_gubun, P.pummok_code, P.jepum_code, sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek,
       G.gubun_name chulha_gubun_name, K.pummok_name, J.jepum_name, J.jepum_yakeo
     into #tmp_01
     from yu_panmae P left outer join cm_chulha_gubun G
                                   on G.chulha_gubun = P.chulha_gubun
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd = '2020-04-10'
 group by P.chulha_gubun, P.pummok_code, P.jepum_code, G.gubun_name, K.pummok_name, J.jepum_name, J.jepum_yakeo

select 1 sortGubun, 2 sortGubun2, chulha_gubun, cast(null as varchar(4)) pummoK_code, cast(null as int) jepum_code, sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       chulha_gubun_name, cast(null as varchar(20)) pummok_name, cast(chulha_gubun_name + '[일계]' as varchar(50)) jepum_name, cast(chulha_gubun_name + '[일계]' as varchar(50)) jepum_yakeo
     into #tmp_02
     from #tmp_01
 group by chulha_gubun, chulha_gubun_name

select 2 sortGubun, 1 sortGubun2, P.chulha_gubun, P.pummok_code, P.jepum_code, sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek,
       G.gubun_name chulha_gubun_name, K.pummok_name, J.jepum_name, J.jepum_yakeo
     into #tmp_03
     from yu_panmae P left outer join cm_chulha_gubun G
                                   on G.chulha_gubun = P.chulha_gubun
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd >= '2020-04-01'
      and P.ymd <= '2020-04-30'
 group by P.chulha_gubun, P.pummok_code, P.jepum_code, G.gubun_name, K.pummok_name, J.jepum_name, J.jepum_yakeo

select 2 sortGubun, 2 sortGubun2, chulha_gubun, cast(null as varchar(4)) pummoK_code, cast(null as int) jepum_code, sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       chulha_gubun_name, cast(null as varchar(20)) pummok_name, cast(chulha_gubun_name + '[월계]' as varchar(50)) jepum_name, cast(chulha_gubun_name + '[월계]' as varchar(50)) jepum_yakeo
     into #tmp_04
     from #tmp_03
 group by chulha_gubun, chulha_gubun_name

select * into #tmp_05 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03 union all
select *              from #tmp_04

select *
     from #tmp_05
 order by sortGubun, chulha_gubun, sortGubun2, pummok_code, jepum_yakeo, jepum_name

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05

-- 제품명 / 출하구분명 / 수량 / 금액 / 세액 / 합계금액
