declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-03-03'

select 1 sortGubun, 1 sortGubun2, P.ymd, convert(varchar(10), ymd, 120) strYmd, P.nno, P.pummok_code, P.jepum_code, P.suryang, P.danga, P.geumaek, P.seaek, P.hapgye_geumaek, P.sangpum_gubun,
       K.pummok_name, G.gubun_name, J.jepum_yakeo, C.sangho sangpum_sangho, cast(0 as tinyint) lineDis
     into #tmp_01
     from yu_panmae P left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
                      left outer join cm_cust C
                                   on C.cust_code = P.sangpum_cust
    where P.ymd >= @ymd_1
      and P.ymd <= @ymd_2

select 1 sortGubun, 2 sortGubun2, ymd, cast('[소계]' as varchar(50)) strYmd, cast(null as tinyint) nno, cast(null as varchar(10)) pummok_code, cast(null as int) jepum_code,
       sum(suryang) suryang, cast(null as numeric(18,0)) danga, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(null as tinyint) sangpum_gubun,
       cast(null as varchar(50)) pummok_name, cast(null as varchar(50)) gubun_name, cast(null as varchar(50)) jepum_yakeo, cast(null as varchar(50)) sangpum_sangho, cast(1 as tinyint) lineDis
     into #tmp_02
     from #tmp_01
 group by ymd 

select 2 sortGubun, 1 sortGubun2, cast(null as smalldatetime) ymd, cast('[합계]' as varchar(50)) strYmd, cast(null as tinyint) nno, cast(null as varchar(10)) pummok_code, cast(null as int) jepum_code,
       sum(suryang) suryang, cast(null as numeric(18,0)) danga, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(null as tinyint) sangpum_gubun,
       cast(null as varchar(50)) pummok_name, cast(null as varchar(50)) gubun_name, cast(null as varchar(50)) jepum_yakeo, cast(null as varchar(50)) sangpum_sangho, cast(1 as tinyint) lineDis
     into #tmp_03
     from #tmp_01

select 2 sortGubun, 2 sortGubun2, cast(null as smalldatetime) ymd, cast(jepum_yakeo + ' [계]' as varchar(50)) strYmd, cast(null as tinyint) nno, pummok_code, jepum_code,
       sum(suryang) suryang, cast(null as numeric(18,0)) danga, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(null as tinyint) sangpum_gubun,
       cast(null as varchar(50)) pummok_name, cast(null as varchar(50)) gubun_name, cast(null as varchar(50)) jepum_yakeo, cast(null as varchar(50)) sangpum_sangho, cast(2 as tinyint) lineDis
     into #tmp_04
     from #tmp_01
 group by pummok_code, jepum_code, jepum_yakeo

select 2 sortGubun, 3 sortGubun2, cast(null as smalldatetime) ymd, cast(pummok_name + ' [계]' as varchar(50)) strYmd, cast(null as tinyint) nno, pummok_code, cast(null as int) jepum_code,
       sum(suryang) suryang, cast(null as numeric(18,0)) danga, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(null as tinyint) sangpum_gubun,
       cast(null as varchar(50)) pummok_name, cast(null as varchar(50)) gubun_name, cast('[제품 계]' as varchar(50)) jepum_yakeo, cast(null as varchar(50)) sangpum_sangho, cast(3 as tinyint) lineDis
     into #tmp_05
     from #tmp_01
 group by pummok_code, pummok_name

select * into #tmp_06 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03 union all
select *              from #tmp_04 union all
select *              from #tmp_05

select *
     from #tmp_06
 order by sortGubun, ymd, sortGubun2


drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06