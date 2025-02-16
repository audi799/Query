--판매
select case when C.cust_gubun_2 = 1 then sum(P.suryang) end dang_min_p_suryang,
       case when C.cust_gubun_2 = 1 then sum(P.geumaek) end dang_min_p_geumaek,
       case when C.cust_gubun_2 = 1 then sum(P.seaek) end dang_min_p_seaek,
       case when C.cust_gubun_2 = 1 then sum(P.hapgye_geumaek) end dang_min_p_hapgye,

       case when C.cust_gubun_2 = 3 then sum(P.suryang) end dang_gwan_p_suryang,
       case when C.cust_gubun_2 = 3 then sum(P.geumaek) end dang_gwan_p_geumaek,
       case when C.cust_gubun_2 = 3 then sum(P.seaek) end dang_gwan_p_seaek,
       case when C.cust_gubun_2 = 3 then sum(P.hapgye_geumaek) end dang_gwan_p_hapgye,

       case when C.cust_gubun_2 = 4 then sum(P.suryang) end dang_su_p_suryang,
       case when C.cust_gubun_2 = 4 then sum(P.geumaek) end dang_su_p_geumaek,
       case when C.cust_gubun_2 = 4 then sum(P.seaek) end dang_su_p_seaek,
       case when C.cust_gubun_2 = 4 then sum(P.hapgye_geumaek) end dang_su_p_hapgye
     into #tmp_01
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
    where P.ymd = '2020-04-29'
 group by C.cust_gubun_2

select sum(dang_min_p_suryang) dang_min_p_suryang, sum(dang_min_p_geumaek) dang_min_p_geumaek, sum(dang_min_p_seaek) dang_min_p_seaek, sum(dang_min_p_hapgye) dang_min_p_hapgye,
       sum(dang_gwan_p_suryang) dang_gwan_p_suryang, sum(dang_gwan_p_geumaek) dang_gwan_p_geumaek, sum(dang_gwan_p_seaek) dang_gwan_p_seaek, sum(dang_gwan_p_hapgye) dang_gwan_p_hapgye,
       sum(dang_su_p_suryang) dang_su_p_suryang, sum(dang_su_p_geumaek) dang_su_p_geumaek, sum(dang_su_p_seaek) dang_su_p_seaek, sum(dang_su_p_hapgye) dang_su_p_hapgye
     into #tmp_02
     from #tmp_01

select case when C.cust_gubun_2 = 1 then sum(P.suryang) end wol_min_p_suryang,
       case when C.cust_gubun_2 = 1 then sum(P.geumaek) end wol_min_p_geumaek,
       case when C.cust_gubun_2 = 1 then sum(P.seaek) end wol_min_p_seaek,
       case when C.cust_gubun_2 = 1 then sum(P.hapgye_geumaek) end wol_min_p_hapgye,

       case when C.cust_gubun_2 = 3 then sum(P.suryang) end wol_gwan_p_suryang,
       case when C.cust_gubun_2 = 3 then sum(P.geumaek) end wol_gwan_p_geumaek,
       case when C.cust_gubun_2 = 3 then sum(P.seaek) end wol_gwan_p_seaek,
       case when C.cust_gubun_2 = 3 then sum(P.hapgye_geumaek) end wol_gwan_p_hapgye,

       case when C.cust_gubun_2 = 4 then sum(P.suryang) end wol_su_p_suryang,
       case when C.cust_gubun_2 = 4 then sum(P.geumaek) end wol_su_p_geumaek,
       case when C.cust_gubun_2 = 4 then sum(P.seaek) end wol_su_p_seaek,
       case when C.cust_gubun_2 = 4 then sum(P.hapgye_geumaek) end wol_su_p_hapgye
     into #tmp_03
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
    where P.ymd >= '2020-04-01'
      and P.ymd <= '2020-04-29'
 group by C.cust_gubun_2  

select sum(wol_min_p_suryang) wol_min_p_suryang, sum(wol_min_p_geumaek) wol_min_p_geumaek, sum(wol_min_p_seaek) wol_min_p_seaek, sum(wol_min_p_hapgye) wol_min_p_hapgye,
       sum(wol_gwan_p_suryang) wol_gwan_p_suryang, sum(wol_gwan_p_geumaek) wol_gwan_p_geumaek, sum(wol_gwan_p_seaek) wol_gwan_p_seaek, sum(wol_gwan_p_hapgye) wol_gwan_p_hapgye,
       sum(wol_su_p_suryang) wol_su_p_suryang, sum(wol_su_p_geumaek) wol_su_p_geumaek, sum(wol_su_p_seaek) wol_su_p_seaek, sum(wol_su_p_hapgye) wol_su_p_hapgye
     into #tmp_04
     from #tmp_03 

select case when C.cust_gubun_2 = 1 then sum(P.suryang) end nyeon_min_p_suryang,
       case when C.cust_gubun_2 = 1 then sum(P.geumaek) end nyeon_min_p_geumaek,
       case when C.cust_gubun_2 = 1 then sum(P.seaek) end nyeon_min_p_seaek,
       case when C.cust_gubun_2 = 1 then sum(P.hapgye_geumaek) end nyeon_min_p_hapgye,

       case when C.cust_gubun_2 = 3 then sum(P.suryang) end nyeon_gwan_p_suryang,
       case when C.cust_gubun_2 = 3 then sum(P.geumaek) end nyeon_gwan_p_geumaek,
       case when C.cust_gubun_2 = 3 then sum(P.seaek) end nyeon_gwan_p_seaek,
       case when C.cust_gubun_2 = 3 then sum(P.hapgye_geumaek) end nyeon_gwan_p_hapgye,

       case when C.cust_gubun_2 = 4 then sum(P.suryang) end nyeon_su_p_suryang,
       case when C.cust_gubun_2 = 4 then sum(P.geumaek) end nyeon_su_p_geumaek,
       case when C.cust_gubun_2 = 4 then sum(P.seaek) end nyeon_su_p_seaek,
       case when C.cust_gubun_2 = 4 then sum(P.hapgye_geumaek) end nyeon_su_p_hapgye
     into #tmp_05
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
    where P.ymd >= '2020-01-01'
      and P.ymd <= '2020-04-29'
 group by C.cust_gubun_2  

select sum(nyeon_min_p_suryang) nyeon_min_p_suryang, sum(nyeon_min_p_geumaek) nyeon_min_p_geumaek, sum(nyeon_min_p_seaek) nyeon_min_p_seaek, sum(nyeon_min_p_hapgye) nyeon_min_p_hapgye,
       sum(nyeon_gwan_p_suryang) nyeon_gwan_p_suryang, sum(nyeon_gwan_p_geumaek) nyeon_gwan_p_geumaek, sum(nyeon_gwan_p_seaek) nyeon_gwan_p_seaek, sum(nyeon_gwan_p_hapgye) nyeon_gwan_p_hapgye,
       sum(nyeon_su_p_suryang) nyeon_su_p_suryang, sum(nyeon_su_p_geumaek) nyeon_su_p_geumaek, sum(nyeon_su_p_seaek) nyeon_su_p_seaek, sum(nyeon_su_p_hapgye) nyeon_su_p_hapgye
     into #tmp_06
     from #tmp_05

--입금
select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end dang_h_i_geumaek,
       case when I.ipgeum_gubun in (1, 3) then sum(halin_geumaek) end dang_h_i_halin,
       case when I.ipgeum_gubun in (1, 3) then sum(japiik) end dang_h_i_japiik,

       case when I.ipgeum_gubun = 2 then sum(geumaek) end dang_eo_geumaek,
       case when I.ipgeum_gubun = 2 then sum(halin_geumaek) end dang_eo_halin,
       case when I.ipgeum_gubun = 2 then sum(japiik) end dang_eo_japiik,

       case when I.ipgeum_gubun = 4 then sum(geumaek) end dang_sg_geumaek,

       sum(geumaek) dang_ipgeum, sum(halin_geumaek) dang_halin, sum(japiik) dang_japiik
     into #tmp_07
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd = '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(dang_h_i_geumaek) end dang_min_h_i_geumaek,
       case when cust_gubun_2 = 3 then sum(dang_h_i_geumaek) end dang_gwan_h_i_geumaek,
       case when cust_gubun_2 = 4 then sum(dang_h_i_geumaek) end dang_su_h_i_geumaek,

       case when cust_gubun_2 = 1 then sum(dang_eo_geumaek) end dang_min_eo_geumaek,
       case when cust_gubun_2 = 3 then sum(dang_eo_geumaek) end dang_gwan_eo_geumaek,
       case when cust_gubun_2 = 4 then sum(dang_eo_geumaek) end dang_su_eo_geumaek,

       case when cust_gubun_2 = 1 then sum(dang_sg_geumaek) end dang_min_sg_geumaek,
       case when cust_gubun_2 = 3 then sum(dang_sg_geumaek) end dang_gwan_sg_geumaek,
       case when cust_gubun_2 = 4 then sum(dang_sg_geumaek) end dang_su_sg_geumaek,

       case when cust_gubun_2 = 1 then sum(dang_ipgeum) end dang_min_ipgeum,
       case when cust_gubun_2 = 3 then sum(dang_ipgeum) end dang_gwan_ipgeum,
       case when cust_gubun_2 = 4 then sum(dang_ipgeum) end dang_su_ipgeum,

       case when cust_gubun_2 = 1 then sum(dang_halin) end dang_min_halin,
       case when cust_gubun_2 = 3 then sum(dang_halin) end dang_gwan_halin,
       case when cust_gubun_2 = 4 then sum(dang_halin) end dang_su_halin,

       case when cust_gubun_2 = 1 then sum(dang_japiik) end dang_min_japiik,
       case when cust_gubun_2 = 3 then sum(dang_japiik) end dang_gwan_japiik,
       case when cust_gubun_2 = 4 then sum(dang_japiik) end dang_su_japiik
     into #tmp_08
     from #tmp_07
 group by cust_gubun_2

select sum(dang_min_h_i_geumaek) dang_min_h_i_geumaek, sum(dang_gwan_h_i_geumaek) dang_gwan_h_i_geumaek, sum(dang_su_h_i_geumaek) dang_su_h_i_geumaek,
       sum(dang_min_eo_geumaek) dang_min_eo_geumaek, sum(dang_gwan_eo_geumaek) dang_gwan_eo_geumaek, sum(dang_su_eo_geumaek) dang_su_eo_geumaek,
       sum(dang_min_sg_geumaek) dang_min_sg_geumaek, sum(dang_gwan_sg_geumaek) dang_gwan_sg_geumaek, sum(dang_su_sg_geumaek) dang_su_sg_geumaek,
       sum(dang_min_ipgeum) dang_min_ipgeum, sum(dang_gwan_ipgeum) dang_gwan_ipgeum, sum(dang_su_ipgeum) dang_su_ipgeum,
       sum(dang_min_halin) dang_min_halin, sum(dang_gwan_halin) dang_gwan_halin, sum(dang_su_halin) dang_su_halin,
       sum(dang_min_japiik) dang_min_japiik, sum(dang_gwan_japiik) dang_gwan_japiik, sum(dang_su_japiik) dang_su_japiik
     into #tmp_09
     from #tmp_08

select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end wol_h_i_geumaek,
       case when I.ipgeum_gubun in (1, 3) then sum(halin_geumaek) end wol_h_i_halin,
       case when I.ipgeum_gubun in (1, 3) then sum(japiik) end wol_h_i_japiik,

       case when I.ipgeum_gubun = 2 then sum(geumaek) end wol_eo_geumaek,
       case when I.ipgeum_gubun = 2 then sum(halin_geumaek) end wol_eo_halin,
       case when I.ipgeum_gubun = 2 then sum(japiik) end wol_eo_japiik,

       case when I.ipgeum_gubun = 4 then sum(geumaek) end wol_sg_geumaek,
       sum(geumaek) wol_ipgeum, sum(halin_geumaek) wol_halin, sum(japiik) wol_japiik
     into #tmp_10
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd >= '2020-04-01'
      and I.ymd <= '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(wol_h_i_geumaek) end wol_min_h_i_geumaek,
       case when cust_gubun_2 = 3 then sum(wol_h_i_geumaek) end wol_gwan_h_i_geumaek,
       case when cust_gubun_2 = 4 then sum(wol_h_i_geumaek) end wol_su_h_i_geumaek,

       case when cust_gubun_2 = 1 then sum(wol_eo_geumaek) end wol_min_eo_geumaek,
       case when cust_gubun_2 = 3 then sum(wol_eo_geumaek) end wol_gwan_eo_geumaek,
       case when cust_gubun_2 = 4 then sum(wol_eo_geumaek) end wol_su_eo_geumaek,

       case when cust_gubun_2 = 1 then sum(wol_sg_geumaek) end wol_min_sg_geumaek,
       case when cust_gubun_2 = 3 then sum(wol_sg_geumaek) end wol_gwan_sg_geumaek,
       case when cust_gubun_2 = 4 then sum(wol_sg_geumaek) end wol_su_sg_geumaek,

       case when cust_gubun_2 = 1 then sum(wol_ipgeum) end wol_min_ipgeum,
       case when cust_gubun_2 = 3 then sum(wol_ipgeum) end wol_gwan_ipgeum,
       case when cust_gubun_2 = 4 then sum(wol_ipgeum) end wol_su_ipgeum,

       case when cust_gubun_2 = 1 then sum(wol_halin) end wol_min_halin,
       case when cust_gubun_2 = 3 then sum(wol_halin) end wol_gwan_halin,
       case when cust_gubun_2 = 4 then sum(wol_halin) end wol_su_halin,

       case when cust_gubun_2 = 1 then sum(wol_japiik) end wol_min_japiik,
       case when cust_gubun_2 = 3 then sum(wol_japiik) end wol_gwan_japiik,
       case when cust_gubun_2 = 4 then sum(wol_japiik) end wol_su_japiik
     into #tmp_11
     from #tmp_10
 group by cust_gubun_2

select sum(wol_min_h_i_geumaek) wol_min_h_i_geumaek, sum(wol_gwan_h_i_geumaek) wol_gwan_h_i_geumaek, sum(wol_su_h_i_geumaek) wol_su_h_i_geumaek,
       sum(wol_min_eo_geumaek) wol_min_eo_geumaek, sum(wol_gwan_eo_geumaek) wol_gwan_eo_geumaek, sum(wol_su_eo_geumaek) wol_su_eo_geumaek,
       sum(wol_min_sg_geumaek) wol_min_sg_geumaek, sum(wol_gwan_sg_geumaek) wol_gwan_sg_geumaek, sum(wol_su_sg_geumaek) wol_su_sg_geumaek,
       sum(wol_min_ipgeum) wol_min_ipgeum, sum(wol_gwan_ipgeum) wol_gwan_ipgeum, sum(wol_su_ipgeum) wol_su_ipgeum,
       sum(wol_min_halin) wol_min_halin, sum(wol_gwan_halin) wol_gwan_halin, sum(wol_su_halin) wol_su_halin,
       sum(wol_min_japiik) wol_min_japiik, sum(wol_gwan_japiik) wol_gwan_japiik, sum(wol_su_japiik) wol_su_japiik
     into #tmp_12
     from #tmp_11

select C.cust_gubun_2,
       case when I.ipgeum_gubun in (1, 3) then sum(geumaek) end nyeon_h_i_geumaek,
       case when I.ipgeum_gubun in (1, 3) then sum(halin_geumaek) end nyeon_h_i_halin,
       case when I.ipgeum_gubun in (1, 3) then sum(japiik) end nyeon_h_i_japiik,

       case when I.ipgeum_gubun = 2 then sum(geumaek) end nyeon_eo_geumaek,
       case when I.ipgeum_gubun = 2 then sum(halin_geumaek) end nyeon_eo_halin,
       case when I.ipgeum_gubun = 2 then sum(japiik) end nyeon_eo_japiik,

       case when I.ipgeum_gubun = 4 then sum(geumaek) end nyeon_sg_geumaek,
       sum(geumaek) nyeon_ipgeum, sum(halin_geumaek) nyeon_halin, sum(japiik) nyeon_japiik
     into #tmp_13
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
    where I.ymd >= '2020-01-01'
      and I.ymd <= '2020-04-29'
 group by C.cust_gubun_2, I.ipgeum_gubun

select case when cust_gubun_2 = 1 then sum(nyeon_h_i_geumaek) end nyeon_min_h_i_geumaek,
       case when cust_gubun_2 = 3 then sum(nyeon_h_i_geumaek) end nyeon_gwan_h_i_geumaek,
       case when cust_gubun_2 = 4 then sum(nyeon_h_i_geumaek) end nyeon_su_h_i_geumaek,

       case when cust_gubun_2 = 1 then sum(nyeon_eo_geumaek) end nyeon_min_eo_geumaek,
       case when cust_gubun_2 = 3 then sum(nyeon_eo_geumaek) end nyeon_gwan_eo_geumaek,
       case when cust_gubun_2 = 4 then sum(nyeon_eo_geumaek) end nyeon_su_eo_geumaek,

       case when cust_gubun_2 = 1 then sum(nyeon_sg_geumaek) end nyeon_min_sg_geumaek,
       case when cust_gubun_2 = 3 then sum(nyeon_sg_geumaek) end nyeon_gwan_sg_geumaek,
       case when cust_gubun_2 = 4 then sum(nyeon_sg_geumaek) end nyeon_su_sg_geumaek,

       case when cust_gubun_2 = 1 then sum(nyeon_ipgeum) end nyeon_min_ipgeum,
       case when cust_gubun_2 = 3 then sum(nyeon_ipgeum) end nyeon_gwan_ipgeum,
       case when cust_gubun_2 = 4 then sum(nyeon_ipgeum) end nyeon_su_ipgeum,

       case when cust_gubun_2 = 1 then sum(nyeon_halin) end nyeon_min_halin,
       case when cust_gubun_2 = 3 then sum(nyeon_halin) end nyeon_gwan_halin,
       case when cust_gubun_2 = 4 then sum(nyeon_halin) end nyeon_su_halin,

       case when cust_gubun_2 = 1 then sum(nyeon_japiik) end nyeon_min_japiik,
       case when cust_gubun_2 = 3 then sum(nyeon_japiik) end nyeon_gwan_japiik,
       case when cust_gubun_2 = 4 then sum(nyeon_japiik) end nyeon_su_japiik
     into #tmp_14
     from #tmp_13
 group by cust_gubun_2

select sum(nyeon_min_h_i_geumaek) nyeon_min_h_i_geumaek, sum(nyeon_gwan_h_i_geumaek) nyeon_gwan_h_i_geumaek, sum(nyeon_su_h_i_geumaek) nyeon_su_h_i_geumaek,
       sum(nyeon_min_eo_geumaek) nyeon_min_eo_geumaek, sum(nyeon_gwan_eo_geumaek) nyeon_gwan_eo_geumaek, sum(nyeon_su_eo_geumaek) nyeon_su_eo_geumaek,
       sum(nyeon_min_sg_geumaek) nyeon_min_sg_geumaek, sum(nyeon_gwan_sg_geumaek) nyeon_gwan_sg_geumaek, sum(nyeon_su_sg_geumaek) nyeon_su_sg_geumaek,
       sum(nyeon_min_ipgeum) nyeon_min_ipgeum, sum(nyeon_gwan_ipgeum) nyeon_gwan_ipgeum, sum(nyeon_su_ipgeum) nyeon_su_ipgeum,
       sum(nyeon_min_halin) nyeon_min_halin, sum(nyeon_gwan_halin) nyeon_gwan_halin, sum(nyeon_su_halin) nyeon_su_halin,
       sum(nyeon_min_japiik) nyeon_min_japiik, sum(nyeon_gwan_japiik) nyeon_gwan_japiik, sum(nyeon_su_japiik) nyeon_su_japiik
     into #tmp_15
     from #tmp_14

select T2.*, T4.*, T6.*, T9.*, T12.*, T15.*,      
       (isnull(T2.dang_min_p_suryang,0) + isnull(T2.dang_gwan_p_suryang,0) + isnull(T2.dang_su_p_suryang,0)) tot_dang_p_suryang,
       (isnull(T2.dang_min_p_geumaek,0) + isnull(T2.dang_gwan_p_geumaek,0) + isnull(T2.dang_su_p_geumaek,0)) tot_dang_p_geumaek,
       (isnull(T2.dang_min_p_seaek,0) + isnull(T2.dang_gwan_p_seaek,0) + isnull(T2.dang_su_p_seaek,0)) tot_dang_seaek,
       (isnull(T2.dang_min_p_hapgye,0) + isnull(T2.dang_gwan_p_hapgye,0) + isnull(T2.dang_su_p_hapgye,0)) tot_dang_hapgye,

       (isnull(T4.wol_min_p_suryang,0) + isnull(T4.wol_gwan_p_suryang,0) + isnull(T4.wol_su_p_suryang,0)) tot_wol_p_suryang,
       (isnull(T4.wol_min_p_geumaek,0) + isnull(T4.wol_gwan_p_geumaek,0) + isnull(T4.wol_su_p_geumaek,0)) tot_wol_p_geumaek,
       (isnull(T4.wol_min_p_seaek,0) + isnull(T4.wol_gwan_p_seaek,0) + isnull(T4.wol_su_p_seaek,0)) tot_wol_seaek,
       (isnull(T4.wol_min_p_hapgye,0) + isnull(T4.wol_gwan_p_hapgye,0) + isnull(T4.wol_su_p_hapgye,0)) tot_wol_hapgye,

       (isnull(T6.nyeon_min_p_suryang,0) + isnull(T6.nyeon_gwan_p_suryang,0) + isnull(T6.nyeon_su_p_suryang,0)) tot_nyeon_p_suryang,
       (isnull(T6.nyeon_min_p_geumaek,0) + isnull(T6.nyeon_gwan_p_geumaek,0) + isnull(T6.nyeon_su_p_geumaek,0)) tot_nyeon_p_geumaek,
       (isnull(T6.nyeon_min_p_seaek,0) + isnull(T6.nyeon_gwan_p_seaek,0) + isnull(T6.nyeon_su_p_seaek,0)) tot_nyeon_seaek,
       (isnull(T6.nyeon_min_p_hapgye,0) + isnull(T6.nyeon_gwan_p_hapgye,0) + isnull(T6.nyeon_su_p_hapgye,0)) tot_nyeon_hapgye,

       (isnull(T9.dang_min_h_i_geumaek,0) + isnull(T9.dang_gwan_h_i_geumaek,0) + isnull(T9.dang_su_h_i_geumaek,0)) tot_dang_h_i_geumaek,
       (isnull(T9.dang_min_eo_geumaek,0) + isnull(T9.dang_gwan_eo_geumaek,0) + isnull(T9.dang_su_eo_geumaek,0)) tot_dang_eo_geumaek,
       (isnull(T9.dang_min_sg_geumaek,0) + isnull(T9.dang_gwan_sg_geumaek,0) + isnull(T9.dang_su_sg_geumaek,0)) tot_dang_sg_geumaek,
       (isnull(T9.dang_min_ipgeum,0) + isnull(T9.dang_gwan_ipgeum,0) + isnull(T9.dang_su_ipgeum,0)) tot_dang_ipgeum,
       (isnull(T9.dang_min_halin,0) + isnull(T9.dang_gwan_halin,0) + isnull(T9.dang_su_halin,0)) tot_dang_halin,
       (isnull(T9.dang_min_japiik,0) + isnull(T9.dang_gwan_japiik,0) + isnull(T9.dang_su_japiik,0)) tot_dang_japiik,
       cast(null as numeric(19,0)) tot_dang_min_sugeum,
       cast(null as numeric(19,0)) tot_dang_gwan_sugeum,
       cast(null as numeric(19,0)) tot_dang_su_sugeum,
       cast(null as numeric(19,0)) tot_dang_sugeum,

       (isnull(T12.wol_min_h_i_geumaek,0) + isnull(T12.wol_gwan_h_i_geumaek,0) + isnull(T12.wol_su_h_i_geumaek,0)) tot_wol_h_i_geumaek,
       (isnull(T12.wol_min_eo_geumaek,0) + isnull(T12.wol_gwan_eo_geumaek,0) + isnull(T12.wol_su_eo_geumaek,0)) tot_wol_eo_geumaek,
       (isnull(T12.wol_min_sg_geumaek,0) + isnull(T12.wol_gwan_sg_geumaek,0) + isnull(T12.wol_su_sg_geumaek,0)) tot_wol_sg_geumaek,
       (isnull(T12.wol_min_ipgeum,0) + isnull(T12.wol_gwan_ipgeum,0) + isnull(T12.wol_su_ipgeum,0)) tot_wol_ipgeum,
       (isnull(T12.wol_min_halin,0) + isnull(T12.wol_gwan_halin,0) + isnull(T12.wol_su_halin,0)) tot_wol_halin,
       (isnull(T12.wol_min_japiik,0) + isnull(T12.wol_gwan_japiik,0) + isnull(T12.wol_su_japiik,0)) tot_wol_japiik,
       cast(null as numeric(19,0)) tot_wol_min_sugeum,
       cast(null as numeric(19,0)) tot_wol_gwan_sugeum,
       cast(null as numeric(19,0)) tot_wol_su_sugeum,
       cast(null as numeric(19,0)) tot_wol_sugeum,

       (isnull(T15.nyeon_min_h_i_geumaek,0) + isnull(T15.nyeon_gwan_h_i_geumaek,0) + isnull(T15.nyeon_su_h_i_geumaek,0)) tot_nyeon_h_i_geumaek,
       (isnull(T15.nyeon_min_eo_geumaek,0) + isnull(T15.nyeon_gwan_eo_geumaek,0) + isnull(T15.nyeon_su_eo_geumaek,0)) tot_nyeon_eo_geumaek,
       (isnull(T15.nyeon_min_sg_geumaek,0) + isnull(T15.nyeon_gwan_sg_geumaek,0) + isnull(T15.nyeon_su_sg_geumaek,0)) tot_nyeon_sg_geumaek,
       (isnull(T15.nyeon_min_ipgeum,0) + isnull(T15.nyeon_gwan_ipgeum,0) + isnull(T15.nyeon_su_ipgeum,0)) tot_nyeon_ipgeum,
       (isnull(T15.nyeon_min_halin,0) + isnull(T15.nyeon_gwan_halin,0) + isnull(T15.nyeon_su_halin,0)) tot_nyeon_halin,
       (isnull(T15.nyeon_min_japiik,0) + isnull(T15.nyeon_gwan_japiik,0) + isnull(T15.nyeon_su_japiik,0)) tot_nyeon_japiik,
       cast(null as numeric(19,0)) tot_nyeon_min_sugeum,
       cast(null as numeric(19,0)) tot_nyeon_gwan_sugeum,
       cast(null as numeric(19,0)) tot_nyeon_su_sugeum,
       cast(null as numeric(19,0)) tot_nyeon_sugeum
     into #tmp_16
     from #tmp_02 T2, #tmp_04 T4, #tmp_06 T6, #tmp_09 T9, #tmp_12 T12, #tmp_15 T15

update #tmp_16 set tot_dang_min_sugeum = isnull(dang_min_h_i_geumaek,0) + isnull(dang_min_eo_geumaek,0) + isnull(dang_min_sg_geumaek,0) + isnull(dang_min_halin,0) - isnull(dang_min_japiik,0)
update #tmp_16 set tot_dang_gwan_sugeum = isnull(dang_gwan_h_i_geumaek,0) + isnull(dang_gwan_eo_geumaek,0) + isnull(dang_gwan_sg_geumaek,0) + isnull(dang_gwan_halin,0) - isnull(dang_gwan_japiik,0)
update #tmp_16 set tot_dang_su_sugeum = isnull(dang_su_h_i_geumaek,0) + isnull(dang_su_eo_geumaek,0) + isnull(dang_su_sg_geumaek,0) + isnull(dang_su_halin,0) - isnull(dang_su_japiik,0)
update #tmp_16 set tot_dang_sugeum = isnull(tot_dang_h_i_geumaek,0) + isnull(tot_dang_eo_geumaek,0) + isnull(tot_dang_sg_geumaek,0) + isnull(tot_dang_halin,0) - isnull(tot_dang_japiik,0)

update #tmp_16 set tot_wol_min_sugeum = isnull(wol_min_h_i_geumaek,0) + isnull(wol_min_eo_geumaek,0) + isnull(wol_min_sg_geumaek,0) + isnull(wol_min_halin,0) - isnull(wol_min_japiik,0)
update #tmp_16 set tot_wol_gwan_sugeum = isnull(wol_gwan_h_i_geumaek,0) + isnull(wol_gwan_eo_geumaek,0) + isnull(wol_gwan_sg_geumaek,0) + isnull(wol_gwan_halin,0) - isnull(wol_gwan_japiik,0)
update #tmp_16 set tot_wol_su_sugeum = isnull(wol_su_h_i_geumaek,0) + isnull(wol_su_eo_geumaek,0) + isnull(wol_su_sg_geumaek,0) + isnull(wol_su_halin,0) - isnull(wol_su_japiik,0)
update #tmp_16 set tot_wol_sugeum = isnull(tot_wol_h_i_geumaek,0) + isnull(tot_wol_eo_geumaek,0) + isnull(tot_wol_sg_geumaek,0) + isnull(tot_wol_halin,0) - isnull(tot_wol_japiik,0)

update #tmp_16 set tot_nyeon_min_sugeum = isnull(nyeon_min_h_i_geumaek,0) + isnull(nyeon_min_eo_geumaek,0) + isnull(nyeon_min_sg_geumaek,0) + isnull(nyeon_min_halin,0) - isnull(nyeon_min_japiik,0)
update #tmp_16 set tot_nyeon_gwan_sugeum = isnull(nyeon_gwan_h_i_geumaek,0) + isnull(nyeon_gwan_eo_geumaek,0) + isnull(nyeon_gwan_sg_geumaek,0) + isnull(nyeon_gwan_halin,0) - isnull(nyeon_gwan_japiik,0)
update #tmp_16 set tot_nyeon_su_sugeum = isnull(nyeon_su_h_i_geumaek,0) + isnull(nyeon_su_eo_geumaek,0) + isnull(nyeon_su_sg_geumaek,0) + isnull(nyeon_su_halin,0) - isnull(nyeon_su_japiik,0)
update #tmp_16 set tot_nyeon_sugeum = isnull(tot_nyeon_h_i_geumaek,0) + isnull(tot_nyeon_eo_geumaek,0) + isnull(tot_nyeon_sg_geumaek,0) + isnull(tot_nyeon_halin,0) - isnull(tot_nyeon_japiik,0)

select *
     from #tmp_16

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




