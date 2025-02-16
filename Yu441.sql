declare @ymd_1 varchar(10), @ymd_2 varchar(10) 

set @ymd_1 = '2020-03-01' 
set @ymd_2 = '2020-03-31' 

select cast(1 as tinyint) sortGubun1, cast(1 as tinyint) sortGubun2,
       cast(convert(varchar(10), P.ymd, 120) as varchar(20)) strYmd, P.ymd, P.cust_code, C.sangho vt_sangho, 
       P.pummok_code, K.pummok_name vt_pummok_name, G.gubun_name vt_gubun_name, P.jepum_code, J.jepum_yakeo vt_jepum_yakeo, sangpum_cust, 
       sum(suryang) suryang, danga, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, cast(0 as tinyint) lineDis 
     into #tmp_01 
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.ymd >= @ymd_1 
      and P.ymd <= @ymd_2 
      and P.sangpum_gubun = 1 
 group by P.ymd, P.cust_code, C.sangho, P.pummok_code, K.pummok_name, G.gubun_name, P.sangpum_cust, P.jepum_code, J.jepum_yakeo, danga

select cast(1 as tinyint) sortGubun1, cast(2 as tinyint) sortGubun2,
       cast(convert(varchar(10), ymd, 120) as varchar(20)) strYmd, ymd, cast(null as varchar(5)) cust_code, 
       cast('[ ¼Ò  °è ]' as varchar(70)) vt_sangho, 
       cast(null as varchar(4)) pummok_code, cast(null as varchar(50)) vt_pummok_name, cast(null as varchar(100)) vt_gubun_name, 
       cast(null as int) jepum_code, cast(null as varchar(50)) vt_jepum_yakeo, 
       cast(null as varchar(5)) sangpum_cust, sum(suryang) suryang, cast(0 as int) danga, 
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, 
       cast(1 as tinyint) lineDis 
     into #tmp_02 
     from #tmp_01 
 group by ymd 

select cast(3 as tinyint) sortGubun1, cast(1 as tinyint) sortGubun2, 
       cast('[ ÃÑ ÇÕ °è ]' as varchar(20)) strYmd, cast(null as smalldatetime) ymd, cast(null as varchar(5)) cust_code, 
       cast(null as varchar(70)) vt_sangho,
       cast(null as varchar(4)) pummok_code, cast(null as varchar(50)) vt_pummok_name, cast(null as varchar(100)) vt_gubun_name, 
       cast(null as int) jepum_code, cast(null as varchar(50)) vt_jepum_yakeo, 
       cast(null as varchar(5)) sangpum_cust, sum(suryang) suryang, cast(0 as int) danga, 
       sum(geumaek) geumaek, sum(seaek) seaek, 
       sum(hapgye_geumaek) hapgye_geumaek, cast(1 as tinyint) lineDis 
     into #tmp_03
     from #tmp_01 

select * into #tmp_04 from #tmp_01 union all 
select *              from #tmp_02 union all 
select *              from #tmp_03 

select T.*, left(SC.sangho, 8) sangpum_sangho 
     from #tmp_04 T left outer join cm_cust SC 
                                 on SC.cust_code = T.sangpum_cust 
order by T.sortGubun1, T.ymd, T.sortGubun2 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
