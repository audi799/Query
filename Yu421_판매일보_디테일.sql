select distinct cust_code, hyeonjang_code 
     into #tmp_01 
     from yu_panmae 
    where ymd = '2020-04-25' 

select distinct cust_code, hyeonjang_code 
     into #tmp_02 
     from yu_ipgeum 
    where ymd = '2020-04-25' 

select cust_code, hyeonjang_code into #tmp_03 from #tmp_01 union 
select cust_code, hyeonjang_code              from #tmp_02 

select T.cust_code, T.hyeonjang_code, T.hyeonjang_code hyeonjang, C.hyeonjang_gubun 
     into #tmp_04 
     from #tmp_03 T left outer join cm_cust C 
                                 on C.cust_code = T.cust_code 

update #tmp_04 set hyeonjang = 0 where hyeonjang_gubun = 1 

select distinct cust_code, hyeonjang_gubun 
     into #tmp_05 
     from #tmp_04 

select P.ymd, T.cust_code, P.hyeonjang_code, T.hyeonjang_gubun, 
       case when T.hyeonjang_gubun = 1 then '0' else P.hyeonjang_code end hyeonjang, 
       P.jepum_code, P.danga, P.suryang suryang, P.geumaek p_geumaek, P.seaek p_seaek, P.hapgye_geumaek p_hapgye 
     into #tmp_06 
     from yu_panmae P, #tmp_05 T 
    where T.cust_code = P.cust_code 
      and P.ymd >= '2002-01-01' 
      and P.ymd >= '2020-01-01' 
      and P.ymd <= '2020-04-25' 

select I.ymd, T.cust_code, I.hyeonjang_code, T.hyeonjang_gubun, 
       case when T.hyeonjang_gubun = 1 then '0' else I.hyeonjang_code end hyeonjang, 
       case when I.ipgeum_gubun in (1, 3) then sum(I.geumaek) end h_i_geumaek,
       case when I.ipgeum_gubun in (1, 3) then sum(I.halin_geumaek) end h_i_halin,
       case when I.ipgeum_gubun in (1, 3) then sum(I.japiik) end h_i_japiik,
       case when I.ipgeum_gubun = 2 then sum(I.geumaek) end eo_i_geumaek,
       case when I.ipgeum_gubun = 2 then sum(I.halin_geumaek) end eo_i_halin,
       case when I.ipgeum_gubun = 2 then sum(I.japiik) end eo_i_japiik,
       sum(I.geumaek) i_geumaek, sum(I.halin_geumaek) i_halin, sum(I.japiik) i_japiik
     into #tmp_07 
     from yu_ipgeum I, #tmp_05 T 
    where I.cust_code = T.cust_code 
      and I.ymd >= '2002-01-01' 
      and I.ymd >= '2020-01-01' 
      and I.ymd <= '2020-04-25' 
 group by I.ymd, T.cust_code, I.hyeonjang_code, T.hyeonjang_gubun, I.ipgeum_gubun

select ymd, cust_code, hyeonjang_code, hyeonjang_gubun, hyeonjang,
       sum(h_i_geumaek) h_i_geumaek, sum(h_i_halin) h_i_halin, sum(h_i_japiik) h_i_japiik,
       sum(eo_i_geumaek) eo_i_geumaek, sum(eo_i_halin) eo_i_halin, sum(eo_i_japiik) eo_i_japiik,
       sum(i_geumaek) i_geumaek, sum(i_halin) i_halin, sum(i_japiik) i_japiik
     into #tmp_08
     from #tmp_07
 group by ymd, cust_code, hyeonjang_code, hyeonjang_gubun, hyeonjang

select T.cust_code, case when T.hyeonjang_gubun = 1 then '0' else S.hyeonjang_code end hyeonjang, S.geumaek sisan 
     into #tmp_09
     from yu_sisan S, #tmp_05 T 
    where S.cust_code = T.cust_code 
      and S.year = 2020 

select cust_code, hyeonjang, sum(sisan) sisan 
     into #tmp_10 
     from #tmp_09
 group by cust_code, hyeonjang 

select cust_code, hyeonjang, sum(p_hapgye) p_geumaek 
     into #tmp_11
     from #tmp_06 
 group by cust_code, hyeonjang 

select cust_code, hyeonjang,
       sum(h_i_geumaek) h_i_geumaek, sum(h_i_halin) h_i_halin, sum(h_i_japiik) h_i_japiik,
       sum(eo_i_geumaek) eo_i_geumaek, sum(eo_i_halin) eo_i_halin, sum(eo_i_japiik) eo_i_japiik,
       sum(i_geumaek) i_geumaek, sum(i_halin) i_halin, sum(i_japiik) i_japiik
     into #tmp_12 
     from #tmp_08
 group by cust_code, hyeonjang 

select distinct cust_code, hyeonjang into #tmp_13 from #tmp_10 union 
select distinct cust_code, hyeonjang              from #tmp_11 union 
select distinct cust_code, hyeonjang              from #tmp_12 

select T.cust_code, T.hyeonjang, T10.sisan, T11.p_geumaek, 
       T12.h_i_geumaek, T12.h_i_halin, T12.h_i_japiik,
       T12.eo_i_geumaek, T12.eo_i_halin, T12.eo_i_japiik,
       T12.i_geumaek, T12.i_halin, T12.i_japiik
     into #tmp_14
     from #tmp_13 T left outer join #tmp_10 T10
                                 on T10.cust_code = T.cust_code 
                                and T10.hyeonjang = T.hyeonjang 
                    left outer join #tmp_11 T11 
                                 on T11.cust_code = T.cust_code 
                                and T11.hyeonjang = T.hyeonjang 
                    left outer join #tmp_12 T12
                                 on T12.cust_code = T.cust_code 
                                and T12.hyeonjang = T.hyeonjang 

update #tmp_14 set sisan = 0 where sisan is null 
update #tmp_14 set p_geumaek = 0 where p_geumaek is null 
update #tmp_14 set h_i_geumaek = 0 where h_i_geumaek is null 
update #tmp_14 set h_i_geumaek = 0 where h_i_geumaek is null 
update #tmp_14 set h_i_halin = 0 where h_i_halin is null 
update #tmp_14 set eo_i_geumaek = 0 where eo_i_geumaek is null 
update #tmp_14 set eo_i_halin = 0 where eo_i_halin is null 
update #tmp_14 set eo_i_japiik = 0 where eo_i_japiik is null 
update #tmp_14 set i_geumaek = 0 where i_geumaek is null 
update #tmp_14 set i_halin = 0 where i_halin is null 
update #tmp_14 set i_japiik = 0 where i_japiik is null 

select cust_code, hyeonjang, (sisan + p_geumaek - i_geumaek - i_halin + i_japiik) misu 
     into #tmp_15 
     from #tmp_14

select 1 gubun, cust_code, hyeonjang_code, hyeonjang, jepum_code, danga, suryang,  p_geumaek, p_seaek, p_hapgye, 0 i_geumaek, 0 i_halin, 0 i_japiik,
       0 h_i_geumaek, 0 h_i_halin, 0 h_i_japiik, 0 eo_i_geumaek, 0 eo_i_halin, 0 eo_i_japiik, 0 i_ipgeum
     into #tmp_16
     from #tmp_06 
    where ymd = '2020-04-25' 

select 2 gubun, cust_code, hyeonjang_code, hyeonjang, null jepum_code, null danga, 0 suryang, 0 p_geumaek, 0 p_seaek, 0 p_hapgye, i_geumaek, i_halin, i_japiik, 
       h_i_geumaek, h_i_halin, h_i_japiik, eo_i_geumaek, eo_i_halin, eo_i_japiik, (i_geumaek + i_halin - i_japiik) i_ipgeum
     into  #tmp_17
     from  #tmp_08
    where ymd = '2020-04-25' 

select * into #tmp_18 from #tmp_16 union all 
select *              from #tmp_17 

select T.*, T15.misu, C.sangho, C.cust_gubun_2, H.hyeonjang_name, J.jepum_name, CG.gubun_name cust_gubun_name 
     into #tmp_19 
     from #tmp_18 T left outer join #tmp_15 T15
                                 on T15.cust_code = T.cust_code 
                                and T15.hyeonjang = T.hyeonjang 
                    left outer join cm_cust C 
                                 on C.cust_code = T.cust_code 
                    left outer join cm_hyeonjang H 
                                 on H.cust_code = T.cust_code 
                                and H.hyeonjang_code = T.hyeonjang_code 
                    left outer join cm_jepum J 
                                 on J.jepum_code = T.jepum_code 
                    left outer join cm_cust_gubun CG 
                                 on CG.cust_gubun = C.cust_gubun_2 

select * 
     from #tmp_19 
 order by cust_gubun_2, cust_code, hyeonjang, gubun 

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
drop table #tmp_17 
drop table #tmp_18
drop table #tmp_19

