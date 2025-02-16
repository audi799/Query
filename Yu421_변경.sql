select distinct cust_code 
     into #tmp_1 
     from yu_panmae 
    where ymd = '2020-04-08' 

select distinct cust_code 
     into #tmp_2 
     from yu_ipgeum 
    where ymd = '2020-04-08' 

select cust_code into #tmp_3 from #tmp_1 union 
select cust_code              from #tmp_2 

select P.ymd, T.cust_code, P.unban_gubun, P.pummok_code, P.jepum_code, P.danga, P.suryang suryang, P.geumaek p_geumaek, P.seaek p_seaek, P.hapgye_geumaek p_hapgye,
       P.chulha_gubun, P.bigo
     into #tmp_4 
     from yu_panmae P, #tmp_3 T 
    where T.cust_code = P.cust_code 
      and P.ymd >= '2015-01-01' 
      and P.ymd >= '2020-01-01' 
      and P.ymd <= '2020-04-08' 

select I.ymd, T.cust_code, I.geumaek i_geumaek, I.halin_geumaek i_halin, I.japiik i_japiik 
     into #tmp_5 
     from yu_ipgeum I, #tmp_3 T 
    where I.cust_code = T.cust_code 
      and I.ymd >= '2015-01-01' 
      and I.ymd >= '2020-01-01' 
      and I.ymd <= '2020-04-08' 

select T.cust_code, sum(S.geumaek) sisan 
     into #tmp_6 
     from #tmp_3 T left outer join yu_sisan S 
                                 on S.cust_code = T.cust_code 
                                and S.year = 2020 
 group by T.cust_code 

select cust_code, sum(p_hapgye) p_geumaek 
     into #tmp_7 
     from #tmp_4 
    where ymd < '2020-04-08' 
 group by cust_code 

select cust_code, sum(i_geumaek) i_geumaek, sum(i_halin) i_halin, sum(i_japiik) i_japiik 
     into #tmp_8 
     from #tmp_5 
    where ymd < '2020-04-08' 
 group by cust_code 

select cust_code, sum(p_hapgye) d_panmae 
     into #tmp_9 
     from #tmp_4 
    where ymd = '2020-04-08' 
 group by cust_code 

select cust_code, sum( isnull(i_geumaek,0) + isnull(i_halin,0) - isnull(i_japiik,0) ) d_ipgeum 
     into #tmp_10 
     from #tmp_5 
    where ymd = '2020-04-08' 
 group by cust_code 

select distinct cust_code into #tmp_11 from #tmp_6 union 
select distinct cust_code              from #tmp_7 union 
select distinct cust_code              from #tmp_8 union 
select distinct cust_code              from #tmp_9 union 
select distinct cust_code              from #tmp_10 

select T.cust_code, T6.sisan, T7.p_geumaek, T8. i_geumaek, T8.i_halin, T8.i_japiik, T9.d_panmae, T10.d_ipgeum  
     into #tmp_12 
     from #tmp_11 T left outer join #tmp_6 T6 
                                 on T6.cust_code = T.cust_code 
                    left outer join #tmp_7 T7 
                                 on T7.cust_code = T.cust_code 
                    left outer join #tmp_8 T8 
                                 on T8.cust_code = T.cust_code 
                    left outer join #tmp_9 T9 
                                 on T9.cust_code = T.cust_code 
                    left outer join #tmp_10 T10 
                                 on T10.cust_code = T.cust_code 

update #tmp_12 set sisan = 0 where sisan is null 
update #tmp_12 set p_geumaek = 0 where p_geumaek is null 
update #tmp_12 set i_geumaek = 0 where i_geumaek is null 
update #tmp_12 set i_halin = 0 where i_halin is null 
update #tmp_12 set i_japiik = 0 where i_japiik is null 
update #tmp_12 set d_panmae = 0 where d_panmae is null 
update #tmp_12 set d_ipgeum = 0 where d_ipgeum is null 

select cust_code, (sisan + p_geumaek - i_geumaek - i_halin + i_japiik) j_misu, 
       (isnull(sisan,0) + isnull(p_geumaek,0) - isnull(i_geumaek,0) - isnull(i_halin,0) + isnull(i_japiik,0) + isnull(d_panmae,0) - isnull(d_ipgeum,0)) misu 
     into #tmp_13 
     from #tmp_12 

select 1 gubun, cust_code, unban_gubun, pummok_code, jepum_code, danga, suryang,  p_geumaek, p_seaek, p_hapgye, 0 i_geumaek, 0 i_halin, 0 i_japiik, 0 i_ipgeum, chulha_gubun, bigo
     into #tmp_14 
     from #tmp_4 
    where ymd = '2020-04-08' 

select 2 gubun, cust_code, cast(null as tinyint) unban_gubun, cast(null as varchar(10)) pummok_code, null jepum_code, null danga, 0 suryang, 0 p_geumaek, 0 p_seaek, 0 p_hapgye, i_geumaek, 
       i_halin, i_japiik, (i_geumaek + i_halin - i_japiik) i_ipgeum, cast(null as tinyint) chulha_gubun, cast(null as varchar(100)) bigo
     into  #tmp_15 
     from  #tmp_5 
    where ymd = '2020-04-08' 

select * into #tmp_16 from #tmp_14 union all 
select *              from #tmp_15 

select 3 gubun, cust_code, cast(null as tinyint) unban_gubun, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code, cast(null as int) danga, 
       sum(suryang) suryang, sum(p_geumaek) p_geumaek, sum(p_seaek) p_seaek, sum(p_hapgye) p_hapgye, 
       sum(i_geumaek) i_geumaek, sum(i_halin) i_halin, sum(i_japiik) i_japiik, sum(i_ipgeum) i_ipgeum, cast(null as tinyint) chulha_gubun, cast(null as varchar(100)) bigo
     into #tmp_17
     from #tmp_16
 group by cust_code

select * into #tmp_18 from #tmp_16 union all
select *              from #tmp_17

select T.*, T13.misu, T13.j_misu, case when gubun = 3 then cast(C.sangho + '[°è]' as varchar(60)) else C.sangho end sangho, 
       C.cust_gubun_2, J.jepum_yakeo, CG.gubun_name cust_gubun_name,  S.sawon_name, UG.unban_name, CG.cust_gubun custGubun, 
       cast(CG.gubun_name + ' ÇÕ°è' as char(12)) cust_name, PG.gubun_name jepum_gubun_name, GB.gubun_name chulha_gubun_name,
       K.pummok_name
     from #tmp_18 T left outer join #tmp_13 T13 
                                 on T13.cust_code = T.cust_code 
                    left outer join cm_cust C 
                                 on C.cust_code = T.cust_code 
                    left outer join cm_jepum J 
                                 on J.pummok_code = T.pummok_code 
                                and J.jepum_code = T.jepum_code 
                    left outer join cm_pummok K 
                                 on K.pummok_code = T.pummok_code 
                    left outer join cm_pummok_gubun PG 
                                 on PG.pummok_gubun = K.pummok_gubun 
                    left outer join cm_cust_gubun CG 
                                 on CG.cust_gubun = C.cust_gubun_2 
                    left outer join cm_sawon S 
                                 on S.sawon_code = C.sawon_code 
                    left outer join cm_unban_gubun UG 
                                 on UG.unban_gubun = T.unban_gubun 
                    left outer join cm_chulha_gubun GB
                                 on GB.chulha_gubun = T.chulha_gubun
 order by CG.custGubun, C.sangho, T.cust_code, T.gubun 

drop table #tmp_1 
drop table #tmp_2 
drop table #tmp_3 
drop table #tmp_4 
drop table #tmp_5 
drop table #tmp_6 
drop table #tmp_7 
drop table #tmp_8 
drop table #tmp_9 
drop table #tmp_10 
drop table #tmp_11 
drop table #tmp_12 
drop table #tmp_13 
drop table #tmp_14 
drop table #tmp_15 
drop table #tmp_16 
drop table #tmp_17
drop table #tmp_18
