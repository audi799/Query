declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-03-03'

select 1 sortGubun, 1 sortGubun2, P.ymd, JP.chulha_plan_no, JP.chulha_plan_sno, P.cust_code, PP.pummok_code, PP.jepum_code, C.sigan, JP.suryang, PP.danga, C.bigo,
       BG.chulbal_name, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, CC.vat_gubun, C.car_code, C.car_no,
       cast(null as numeric(18,0)) geumaek, cast(null as numeric(18,0)) seaek, cast(null as numeric(18,0)) hapgye_geumaek,
       cast(0 as tinyint) lineDis
     into #tmp_01
     from yu_chulha C left outer join yu_chulha_plan P
                                   on P.ymd = C.ymd
                                  and P.nno = C.chulha_plan_no
                      left outer join yu_chulha_plan_jp PP
                                   on PP.ymd = P.ymd
                                  and PP.nno = P.nno
                      left outer join yu_chulha_jp JP
                                   on JP.ymd = PP.ymd
                                  and JP.chulha_plan_no = PP.nno
                                  and JP.chulha_plan_sno = PP.sno
                      left outer join cm_chulbal_gubun BG
                                   on BG.chulbal_gubun = P.chulbal_gubun
                      left outer join cm_cust CC
                                   on CC.cust_code = P.cust_code
                      left outer join cm_pummok K
                                   on K.pummok_code = PP.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = PP.pummok_code
                                  and J.jepum_code = PP.jepum_code
    where C.ymd >= @ymd_1
      and C.ymd <= @ymd_2

update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga * 1.1) where vat_gubun = 1
update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga)       where vat_gubun = 2
update #tmp_01 set geumaek        = ceiling(hapgye_geumaek / 1.1) 
update #tmp_01 set seaek          = hapgye_geumaek - geumaek 

select 1 sortGubun, 2 sortGubun2, ymd, cast(null as tinyint) chulha_plan_no, cast(null as tinyint) chulha_plan_sno,
       cast(null as varchar(5)) cust_code, cast(null as varchar(20)) pummok_code, cast(null as int) jepum_code,
       cast(null as varchar(10)) sigan, sum(suryang) suryang, cast(null as numeric(18,0)) danga, cast(null as varchar(50)) bigo, cast(null as varchar(10)) chulbal_name,
       cast('[소 계]' as varchar(50)) sangho, cast(null as varchar(50)) pummok_name, cast(null as varchar(20)) gubun_name, cast(null as varchar(50)) jepum_yakeo,
       cast(null as int) vat_gubun, cast(null as varchar(10)) car_code, cast(null as varchar(20)) car_no, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       cast(1 as tinyint) lineDis
     into #tmp_02
     from #tmp_01
 group by ymd 

select 2 sortGubun, 1 sortGubun2, cast(null as smalldatetime) ymd, cast(null as tinyint) chulha_plan_no, cast(null as tinyint) chulha_plan_sno,
       cast(null as varchar(5)) cust_code, cast(null as varchar(20)) pummok_code, cast(null as int) jepum_code,
       cast(null as varchar(10)) sigan, sum(suryang) suryang, cast(null as numeric(18,0)) danga, cast(null as varchar(50)) bigo,  cast(null as varchar(10)) chulbal_name,
       cast('[합 계]' as varchar(50)) sangho, cast(null as varchar(50)) pummok_name, cast(null as varchar(20)) gubun_name, cast(null as varchar(50)) jepum_yakeo,
       cast(null as int) vat_gubun, cast(null as varchar(10)) car_code, cast(null as varchar(20)) car_no, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       cast(1 as tinyint) lineDis
     into #tmp_03
     from #tmp_01

select * into #tmp_04 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03

select *
     from #tmp_04
 order by sortGubun, ymd, sortGubun2

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04