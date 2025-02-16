declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)
declare @custCode varchar(5)

set @ymd_1 = '2020-03-01'
set @ymd_2 = '2020-04-30'
set @custCode = '10094'

select 1 sortGubun, 1 sortGubun2, P.cust_code, P.pummok_code, P.jepum_code, P.danga, 
       sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek,
       C.cust_gubun_1, G.gubun_name, C.sangho, K.pummok_name, J.jepum_name, J.jepum_yakeo
     into #tmp_01
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_cust_gubun G
                                   on G.cust_gubun = C.cust_gubun_1
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd >= @ymd_1
      and P.ymd <= @ymd_2
      and P.cust_code = @custCode
 group by G.gubun_name, P.cust_code, P.pummok_code, P.jepum_code, P.danga, C.cust_gubun_1, G.gubun_name, C.sangho, K.pummok_name, J.jepum_name, J.jepum_yakeo

select 1 sortGubun, 2 sortGubun2, cust_code, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code, cast(null as int) danga,
      sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
      cast(null as tinyint) cust_gubun_1, cast(null as varchar(10)) gubun_name, cast('[소  계]' as varchar(50)) sangho,
      cast(null as varchar(40)) pummok_name, cast(null as varchar(40)) jepum_name, cast(null as varchar(40)) jepum_yakeo
     into #tmp_02
     from #tmp_01
 group by cust_code

select 2 sortGubun, 1 sortGubun2, cast(null as varchar(5)) cust_code, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code, cast(null as int) danga,
      sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
      cast(null as tinyint) cust_gubun_1, cast(null as varchar(10)) gubun_name, cast('[합  계]' as varchar(50)) sangho,
      cast(null as varchar(40)) pummok_name, cast(null as varchar(40)) jepum_name, cast(null as varchar(40)) jepum_yakeo
     into #tmp_03
     from #tmp_01

select * into #tmp_04 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03

select T.*, 
       T3.suryang tot_suryang,
       round(T.suryang / T3.suryang * 100, 2)  s_biyul
     from #tmp_04 T, #tmp_03 T3
 order by T.sortGubun, T.cust_code, T.sortGubun2

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
