-- 2020-04-29

select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end dang_h_ipgeum,
       case when I.ipgeum_gubun = 2 then sum(geumaek) end dang_eoeum,
       sum(halin_geumaek) dang_halin,
       sum(japiik) dang_japiik
     into #tmp_01
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd = '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(dang_h_ipgeum) end min_dang_h_ipgeum,
       case when cust_gubun_2 = 3 then sum(dang_h_ipgeum) end gwan_dang_h_ipgeum,
       case when cust_gubun_2 = 4 then sum(dang_h_ipgeum) end su_dang_h_ipgeum,

       case when cust_gubun_2 = 1 then sum(dang_eoeum) end min_dang_eoeum,
       case when cust_gubun_2 = 3 then sum(dang_eoeum) end gwan_dang_eoeum,
       case when cust_gubun_2 = 4 then sum(dang_eoeum) end su_dang_eoeum,

       case when cust_gubun_2 = 1 then sum(dang_halin) end min_dang_halin,
       case when cust_gubun_2 = 3 then sum(dang_halin) end gwan_dang_halin,
       case when cust_gubun_2 = 4 then sum(dang_halin) end su_dang_halin,

       case when cust_gubun_2 = 1 then sum(dang_japiik) end min_dang_japiik,
       case when cust_gubun_2 = 3 then sum(dang_japiik) end gwan_dang_japiik,
       case when cust_gubun_2 = 4 then sum(dang_japiik) end su_dang_japiik,

       sum(dang_h_ipgeum) tot_dang_h_ipgeum, sum(dang_eoeum) tot_dang_eoeum,
       sum(dang_halin) tot_dang_halin, sum(dang_japiik) tot_dang_japiik
     into #tmp_02
     from #tmp_01
 group by cust_gubun_2

select sum(min_dang_h_ipgeum) min_dang_h_ipgeum, sum(gwan_dang_h_ipgeum) gwan_dang_h_ipgeum, sum(su_dang_h_ipgeum) su_dang_h_ipgeum,
       sum(min_dang_eoeum) min_dang_eoeum, sum(gwan_dang_eoeum) gwan_dang_eoeum, sum(su_dang_eoeum) su_dang_eoeum,
       sum(min_dang_halin) min_dang_halin, sum(gwan_dang_halin) gwan_dang_halin, sum(su_dang_halin) su_dang_halin,
       sum(min_dang_japiik) min_dang_japiik, sum(gwan_dang_japiik) gwan_dang_japiik, sum(su_dang_japiik) su_dang_japiik,
       sum(tot_dang_h_ipgeum) tot_dang_h_ipgeum, sum(tot_dang_eoeum) tot_dang_eoeum,
       sum(tot_dang_halin) tot_dang_halin, sum(tot_dang_japiik) tot_dang_japiik
     into #tmp_03
     from #tmp_02

select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end wol_h_ipgeum,
       case when I.ipgeum_gubun = 2 then sum(geumaek) end wol_eoeum,
       sum(halin_geumaek) wol_halin,
       sum(japiik) wol_japiik
     into #tmp_04
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd >= '2020-04-01'
      and I.ymd <= '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(wol_h_ipgeum) end min_wol_h_ipgeum,
       case when cust_gubun_2 = 3 then sum(wol_h_ipgeum) end gwan_wol_h_ipgeum,
       case when cust_gubun_2 = 4 then sum(wol_h_ipgeum) end su_wol_h_ipgeum,

       case when cust_gubun_2 = 1 then sum(wol_eoeum) end min_wol_eoeum,
       case when cust_gubun_2 = 3 then sum(wol_eoeum) end gwan_wol_eoeum,
       case when cust_gubun_2 = 4 then sum(wol_eoeum) end su_wol_eoeum,

       case when cust_gubun_2 = 1 then sum(wol_halin) end min_wol_halin,
       case when cust_gubun_2 = 3 then sum(wol_halin) end gwan_wol_halin,
       case when cust_gubun_2 = 4 then sum(wol_halin) end su_wol_halin,

       case when cust_gubun_2 = 1 then sum(wol_japiik) end min_wol_japiik,
       case when cust_gubun_2 = 3 then sum(wol_japiik) end gwan_wol_japiik,
       case when cust_gubun_2 = 4 then sum(wol_japiik) end su_wol_japiik,

       sum(wol_h_ipgeum) tot_wol_h_ipgeum, sum(wol_eoeum) tot_wol_eoeum,
       sum(wol_halin) tot_wol_halin, sum(wol_japiik) tot_wol_japiik
     into #tmp_05
     from #tmp_04
 group by cust_gubun_2

select sum(min_wol_h_ipgeum) min_wol_h_ipgeum, sum(gwan_wol_h_ipgeum) gwan_wol_h_ipgeum, sum(su_wol_h_ipgeum) su_wol_h_ipgeum,
       sum(min_wol_eoeum) min_wol_eoeum, sum(gwan_wol_eoeum) gwan_wol_eoeum, sum(su_wol_eoeum) su_wol_eoeum,
       sum(min_wol_halin) min_wol_halin, sum(gwan_wol_halin) gwan_wol_halin, sum(su_wol_halin) su_wol_halin,
       sum(min_wol_japiik) min_wol_japiik, sum(gwan_wol_japiik) gwan_wol_japiik, sum(su_wol_japiik) su_wol_japiik,
       sum(tot_wol_h_ipgeum) tot_wol_h_ipgeum, sum(tot_wol_eoeum) tot_wol_eoeum,
       sum(tot_wol_halin) tot_wol_halin, sum(tot_wol_japiik) tot_wol_japiik
     into #tmp_06
     from #tmp_05

select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end nyeon_h_ipgeum,
       case when I.ipgeum_gubun = 2 then sum(geumaek) end nyeon_eoeum,
       sum(halin_geumaek) nyeon_halin,
       sum(japiik) nyeon_japiik
     into #tmp_07
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd >= '2020-01-01'
      and I.ymd <= '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(nyeon_h_ipgeum) end min_nyeon_h_ipgeum,
       case when cust_gubun_2 = 3 then sum(nyeon_h_ipgeum) end gwan_nyeon_h_ipgeum,
       case when cust_gubun_2 = 4 then sum(nyeon_h_ipgeum) end su_nyeon_h_ipgeum,

       case when cust_gubun_2 = 1 then sum(nyeon_eoeum) end min_nyeon_eoeum,
       case when cust_gubun_2 = 3 then sum(nyeon_eoeum) end gwan_nyeon_eoeum,
       case when cust_gubun_2 = 4 then sum(nyeon_eoeum) end su_nyeon_eoeum,

       case when cust_gubun_2 = 1 then sum(nyeon_halin) end min_nyeon_halin,
       case when cust_gubun_2 = 3 then sum(nyeon_halin) end gwan_nyeon_halin,
       case when cust_gubun_2 = 4 then sum(nyeon_halin) end su_nyeon_halin,

       case when cust_gubun_2 = 1 then sum(nyeon_japiik) end min_nyeon_japiik,
       case when cust_gubun_2 = 3 then sum(nyeon_japiik) end gwan_nyeon_japiik,
       case when cust_gubun_2 = 4 then sum(nyeon_japiik) end su_nyeon_japiik,

       sum(nyeon_h_ipgeum) tot_nyeon_h_ipgeum, sum(nyeon_eoeum) tot_nyeon_eoeum,
       sum(nyeon_halin) tot_nyeon_halin, sum(nyeon_japiik) tot_nyeon_japiik
     into #tmp_08
     from #tmp_07
 group by cust_gubun_2

select sum(min_nyeon_h_ipgeum) min_nyeon_h_ipgeum, sum(gwan_nyeon_h_ipgeum) gwan_nyeon_h_ipgeum, sum(su_nyeon_h_ipgeum) su_nyeon_h_ipgeum,
       sum(min_nyeon_eoeum) min_nyeon_eoeum, sum(gwan_nyeon_eoeum) gwan_nyeon_eoeum, sum(su_nyeon_eoeum) su_nyeon_eoeum,
       sum(min_nyeon_halin) min_nyeon_halin, sum(gwan_nyeon_halin) gwan_nyeon_halin, sum(su_nyeon_halin) su_nyeon_halin,
       sum(min_nyeon_japiik) min_nyeon_japiik, sum(gwan_nyeon_japiik) gwan_nyeon_japiik, sum(su_nyeon_japiik) su_nyeon_japiik,
       sum(tot_nyeon_h_ipgeum) tot_nyeon_h_ipgeum, sum(tot_nyeon_eoeum) tot_nyeon_eoeum,
       sum(tot_nyeon_halin) tot_nyeon_halin, sum(tot_nyeon_japiik) tot_nyeon_japiik
     into #tmp_09
     from #tmp_08

select T3.*, T6.*, T9.*,
       isnull(T3.min_dang_h_ipgeum,0) + isnull(T3.min_dang_eoeum,0) + isnull(T3.min_dang_halin,0) - isnull(T3.min_dang_japiik,0) tot_min_dang_ipgeum,
       isnull(T6.min_wol_h_ipgeum,0) + isnull(T6.min_wol_eoeum,0) + isnull(T6.min_wol_halin,0) - isnull(T6.min_wol_japiik,0) tot_min_wol_ipgeum,
       isnull(T9.min_nyeon_h_ipgeum,0) + isnull(T9.min_nyeon_eoeum,0) + isnull(T9.min_nyeon_halin,0) - isnull(T9.min_nyeon_japiik,0) tot_min_nyeon_ipgeum,

       isnull(T3.gwan_dang_h_ipgeum,0) + isnull(T3.gwan_dang_eoeum,0) + isnull(T3.gwan_dang_halin,0) - isnull(T3.gwan_dang_japiik,0) tot_gwan_dang_ipgeum,
       isnull(T6.gwan_wol_h_ipgeum,0) + isnull(T6.gwan_wol_eoeum,0) + isnull(T6.gwan_wol_halin,0) - isnull(T6.gwan_wol_japiik,0) tot_gwan_wol_ipgeum,
       isnull(T9.gwan_nyeon_h_ipgeum,0) + isnull(T9.gwan_nyeon_eoeum,0) + isnull(T9.gwan_nyeon_halin,0) - isnull(T9.gwan_nyeon_japiik,0) tot_gwan_nyeon_ipgeum,

       isnull(T3.su_dang_h_ipgeum,0) + isnull(T3.su_dang_eoeum,0) + isnull(T3.su_dang_halin,0) - isnull(T3.su_dang_japiik,0) tot_su_dang_ipgeum,
       isnull(T6.su_wol_h_ipgeum,0) + isnull(T6.su_wol_eoeum,0) + isnull(T6.su_wol_halin,0) - isnull(T6.su_wol_japiik,0) tot_su_wol_ipgeum,
       isnull(T9.su_nyeon_h_ipgeum,0) + isnull(T9.su_nyeon_eoeum,0) + isnull(T9.su_nyeon_halin,0) - isnull(T9.su_nyeon_japiik,0) tot_su_nyeon_ipgeum
     from #tmp_03 T3, #tmp_06 T6, #tmp_09 T9

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07
drop table #tmp_08
drop table #tmp_09
