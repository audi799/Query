declare @ymd_1 varchar(10), @ymd_2 varchar(10) 

set @ymd_1 = '2010-01-01' 
set @ymd_2 = '2020-03-31' 

select P.ymd, C.sangho, J.jepum_yakeo jepum_yakeo, K.pummok_name, P.suryang, 
       P.sangpum_danga, P.sangpum_geumaek, P.sangpum_seaek, P.sangpum_hapgye, P.danga, 
       P.geumaek, P.seaek, P.hapgye_geumaek, C.sangho sangpum_sangho, CG.gubun_name, G.gubun_name jepum_gubun_name
     into #tmp_01 
     from yu_panmae P left outer join cm_cust C 
                                   on C.cust_code = P.sangpum_cust 
                      left outer join cm_cust_gubun CG 
                                   on CG.cust_gubun = C.cust_gubun_2 
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd >= @ymd_1 
      and P.ymd <= @ymd_2 
      and P.sangpum_gubun = 2 

select cast(1 as tinyint) sortGubun1, cast(1 as tinyint) sortGubun2, gubun_name, jepum_gubun_name, ymd, sangpum_sangho, jepum_yakeo, pummok_name, suryang, 
       sangpum_danga, sangpum_geumaek, sangpum_seaek, sangpum_hapgye, sangho, danga, 
       geumaek, seaek, hapgye_geumaek, cast(0 as tinyint) lineDis 
     into #tmp_02 
     from #tmp_01 

select cast(1 as tinyint) sortGubun1, cast(2 as tinyint) sortGubun2, cast(null as varchar(4)) gubun_name, cast(null as varchar(50)) jepum_gubun_name, 
       dateadd(s, -1, dateadd(mm, datediff(m,0, max(ymd)) +1,0)) ymd, cast(sangpum_sangho as varchar(70)) sangpum_sangho, 
       cast(null as varchar(15)) jepum_yakeo, cast(null as varchar(15)) pummok_name, sum(suryang) suryang, cast(null as int) sangpum_danga, 
       sum(sangpum_geumaek) sangpum_geumaek, sum(sangpum_seaek) sangpum_seaek, sum(sangpum_hapgye) sangpum_hapgye, 
       sangpum_sangho sangho, cast(null as int) danga, 
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(1 as tinyint) lineDis 
     into #tmp_03 
     from #tmp_01 
 group by sangpum_sangho 

select cast(2 as tinyint) sortGubun1, cast(3 as tinyint) sortGubun2, cast(null as varchar(4)) gubun_name, cast(null as varchar(50)) jepum_gubun_name, cast(null as smalldatetime) ymd, 
       cast(null as varchar(70)) sangpum_sangho, cast(null as varchar(15)) jepum_yakeo, cast(null as varchar(15)) pummok_name, 
       sum(suryang) suryang, cast(null as int) sangpum_danga, 
       sum(sangpum_geumaek) sangpum_geumaek, 
       sum(sangpum_seaek) sangpum_seaek, sum(sangpum_hapgye) sangpum_hapgye, cast('[  ÇÕ  °è  ]' as varchar(70)) sangho, 
       cast(null as int) danga, sum(geumaek) geumaek, sum(seaek) seaek, 
       sum(hapgye_geumaek) hapgye_geumaek, cast(1 as tinyint) lineDis 
     into #tmp_04 
     from #tmp_01 

select * into #tmp_05 from #tmp_02 union all 
select *              from #tmp_03 union all 
select *              from #tmp_04 

select sortGubun1, sortGubun2, gubun_name, case when sortgubun2 = 1 and linedis = 1 then null else ymd end ymd, 
       case when sortgubun2 = 1 and linedis = 1 then null else sangpum_sangho end sangpum_sangho, 
       jepum_gubun_name, jepum_yakeo, pummok_name, suryang, sangpum_danga, sangpum_geumaek, sangpum_seaek, sangpum_hapgye, 
       sangho, danga, geumaek, seaek, hapgye_geumaek, (hapgye_geumaek - sangpum_hapgye) iikgeum, 
       case when lineDis = 1 then null else cast(((hapgye_geumaek - sangpum_hapgye) / hapgye_geumaek * 100) as numeric(18,1)) end iikyul, 
       lineDis 
     from #tmp_05 
 order by sortGubun1, sangpum_sangho, sortGubun2, ymd 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05 
