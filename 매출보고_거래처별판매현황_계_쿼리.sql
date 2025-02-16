declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)
declare @custCode varchar(5)

set @ymd_1 = '2020-03-01'
set @ymd_2 = '2020-04-30'
set @custCode = '10045'

select C.cust_gubun_1, cast(G.gubun_name + ' ÇÕ°è' as varchar(30)) gubun_name, sum(P.suryang) suryang, sum(P.geumaek) geumaek, sum(P.seaek) seaek, sum(P.hapgye_geumaek) hapgye_geumaek
     into #tmp_01
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_cust_gubun G
                                   on G.cust_gubun = C.cust_gubun_1
    where P.ymd >= @ymd_1
      and P.ymd <= @ymd_2
 group by C.cust_gubun_1, G.gubun_name

select C.cust_gubun_1, P.cust_code
     into #tmp_02
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_cust_gubun G
                                   on G.cust_gubun = C.cust_gubun_1
    where P.ymd >= @ymd_1
      and P.ymd <= @ymd_2
 group by C.cust_gubun_1, P.cust_code

select cust_gubun_1, count(*) cnt
     into #tmp_03
     from #tmp_02
 group by cust_gubun_1

select 1 sortGubun, T.*, T3.cnt
     into #tmp_04
     from #tmp_01 T left outer join #tmp_03 T3
                                 on T3.cust_gubun_1 = T.cust_gubun_1

select 2 sortGubun, cast(null as tinyint) cust_gubun_1, cast('[ÃÑ  °è]' as varchar(20)) gubun_name,
       sum(suryang) suryang, sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek, sum(cnt) cnt
     into #tmp_05
     from #tmp_04

select * into #tmp_06 from #tmp_04 union all
select *              from #tmp_05

select T.*,
       T5. suryang tot_suryang, T5.hapgye_geumaek tot_hapgye_geumaek,
       round(T.suryang / T5.suryang * 100, 2) s_biyul,
       round(T.hapgye_geumaek / T5.hapgye_geumaek * 100, 2) h_g_biyul
     from #tmp_06 T, #tmp_05 T5

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06