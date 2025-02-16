select distinct cust_code 
     into #tmp_01 
     from yu_panmae 
    where ymd = '2020-03-02' 

select distinct cust_code 
     into #tmp_02 
     from yu_ipgeum 
    where ymd = '2020-03-02' 

select cust_code into #tmp_03 from #tmp_01 union 
select cust_code              from #tmp_02 

select P.ymd, T.cust_code, P.unban_gubun, P.pummok_code, P.jepum_code, P.danga, P.suryang suryang, P.geumaek p_geumaek, P.seaek p_seaek, P.hapgye_geumaek p_hapgye 
     into #tmp_04 
     from yu_panmae P, #tmp_03 T 
    where T.cust_code = P.cust_code 
      and P.ymd >= '2015-01-01' 
      and P.ymd >= '2020-01-01' 
      and P.ymd <= '2020-03-02' 

select I.ymd, T.cust_code, I.geumaek i_geumaek, I.halin_geumaek i_halin, I.japiik i_japiik 
     into #tmp_05 
     from yu_ipgeum I, #tmp_03 T 
    where I.cust_code = T.cust_code 
      and I.ymd >= '2015-01-01' 
      and I.ymd >= '2020-01-01' 
      and I.ymd <= '2020-03-02' 

select T.cust_code, sum(S.geumaek) sisan 
     into #tmp_06 
     from #tmp_03 T left outer join yu_sisan S 
                                 on S.cust_code = T.cust_code 
                                and S.year = 2020 
 group by T.cust_code

select cust_code, sum(p_hapgye) p_geumaek 
     into #tmp_07 
     from #tmp_04 
    where ymd < '2020-03-02' 
 group by cust_code 

select cust_code, sum(i_geumaek) i_geumaek, sum(i_halin) i_halin, sum(i_japiik) i_japiik 
     into #tmp_08 
     from #tmp_05 
    where ymd < '2020-03-02' 
 group by cust_code 

select cust_code, sum(p_hapgye) d_panmae 
     into #tmp_09 
     from #tmp_04 
    where ymd = '2020-03-02' 
 group by cust_code 

select cust_code, sum( isnull(i_geumaek,0) + isnull(i_halin,0) - isnull(i_japiik,0) ) d_ipgeum 
     into #tmp_10 
     from #tmp_05 
    where ymd = '2020-03-02' 
 group by cust_code 

select distinct cust_code into #tmp_11 from #tmp_06 union 
select distinct cust_code                     from #tmp_07 union 
select distinct cust_code                     from #tmp_08 union 
select distinct cust_code                     from #tmp_09 union 
select distinct cust_code                     from #tmp_10 

select T.cust_code, T6.sisan, T7.p_geumaek, T8. i_geumaek, T8.i_halin, T8.i_japiik, T9.d_panmae, T10.d_ipgeum 
     into #tmp_12 
     from #tmp_11 T left outer join #tmp_06 T6 
                                 on T6.cust_code = T.cust_code 
                    left outer join #tmp_07 T7 
                                 on T7.cust_code = T.cust_code 
                    left outer join #tmp_08 T8 
                                 on T8.cust_code = T.cust_code 
                    left outer join #tmp_09 T9 
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

select 1 gubun, cust_code, unban_gubun, pummok_code, jepum_code, danga, suryang,  p_geumaek, p_seaek, p_hapgye, 0 i_geumaek, 0 i_halin, 0 i_japiik, 0 i_ipgeum 
     into #tmp_14 
     from #tmp_04 
    where ymd = '2020-03-02' 

select 2 gubun, cust_code, cast(null as tinyint) unban_gubun, cast(null as varchar(10)) pummok_code, null jepum_code, null danga, 0 suryang, 0 p_geumaek, 0 p_seaek, 0 p_hapgye, 
       i_geumaek, i_halin, i_japiik, (i_geumaek + i_halin - i_japiik) i_ipgeum 
     into  #tmp_15 
     from  #tmp_05 
    where ymd = '2020-03-02' 

select * into #tmp_16 from #tmp_14 union all 
select *              from #tmp_15 

select T.*, T13.misu, T13.j_misu, C.sangho, C.cust_gubun_2, J.jepum_yakeo, CG.gubun_name cust_gubun_name,  S.sawon_name, UG.unban_name, CG.cust_gubun custGubun, 
       cast(CG.gubun_name + ' ÇÕ°è' as char(12)) cust_name, CG.gubun_name jepum_gubun_name
     from #tmp_16 T left outer join #tmp_13 T13 
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
 order by CG.custGubun, C.sangho, T.cust_code, T.gubun 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05 
drop table #tmp_06 
drop table #tmp_07 
drop table #tmp_08 
drop table #tmp_09 
drop table #tmp_10 
drop table #tmp_11 
drop table #tmp_12 
drop table #tmp_13 
drop table #tmp_14 
drop table #tmp_15 
drop table #tmp_16 
