select year, pummok_code, jepum_code, sum(suryang) sisan
     into #tmp_01
     from yu_jaego
    where year = '2020'
 group by year, pummok_code, jepum_code

select pummok_code, jepum_code,
       case when isnull(ipgo_gubun, 'N') in ('N', 'M') then sum(suryang) end jeon_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'U'         then sum(suryang) end up_jeon_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'D'         then sum(suryang) end down_jeon_ipgo
     into #tmp_02
     from yu_ipgo
    where ymd >= '2020-01-01'
      and ymd <= '2020-02-27'
      and isnull(ipgo_gubun, 'N') in ('N', 'M', 'U', 'D')
 group by pummok_code, jepum_code, ipgo_gubun

select pummok_code, jepum_code,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo
     into #tmp_03
     from #tmp_02
 group by pummok_code, jepum_code

select PP.pummok_code, PP.jepum_code, sum(JP.suryang) jeon_chulgo
     into #tmp_04
     from yu_chulha_jp JP left outer join yu_chulha_plan_jp PP
                                       on PP.ymd = JP.ymd
                                      and PP.nno = JP.chulha_plan_no 
                                      and PP.sno = JP.chulha_plan_sno
                          left outer join yu_chulha C
                                       on C.ymd = JP.ymd 
                                      and C.nno = JP.nno
                                      and C.chulha_plan_no = JP.chulha_plan_no
    where JP.ymd >= '2020-01-01'
      and JP.ymd <= '2020-02-27'
      and isnull(C.hoecha_chk, '') = ''
 group by PP.pummok_code, PP.jepum_code

select pummok_code, jepum_code,
       case when isnull(ipgo_gubun, 'N') in ('N', 'M') then sum(suryang) end dang_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'U'         then sum(suryang) end up_dang_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'D'         then sum(suryang) end down_dang_ipgo
     into #tmp_05
     from yu_ipgo
    where ymd >= '2020-02-28'
      and ymd <= '2020-02-28'
      and isnull(ipgo_gubun, 'N') in ('N', 'M', 'U', 'D')
 group by pummok_code, jepum_code, ipgo_gubun

select pummok_code, jepum_code,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo
     into #tmp_06
     from #tmp_05
 group by pummok_code, jepum_code

select PP.pummok_code, PP.jepum_code, sum(JP.suryang) dang_chulgo
     into #tmp_07
     from yu_chulha_jp JP left outer join yu_chulha_plan_jp PP
                                       on PP.ymd = JP.ymd
                                      and PP.nno = JP.chulha_plan_no 
                                      and PP.sno = JP.chulha_plan_sno
                          left outer join yu_chulha C
                                       on C.ymd = JP.ymd 
                                      and C.nno = JP.nno
                                      and C.chulha_plan_no = JP.chulha_plan_no
    where JP.ymd >= '2020-02-28'
      and JP.ymd <= '2020-02-28'
      and isnull(C.hoecha_chk, '') = ''
 group by PP.pummok_code, PP.jepum_code

select pummok_code, jepum_code into #tmp_08 from #tmp_01 union 
select pummok_code, jepum_code              from #tmp_03 union 
select pummok_code, jepum_code              from #tmp_04 union 
select pummok_code, jepum_code              from #tmp_06 union 
select pummok_code, jepum_code              from #tmp_07

select 1 Gubun, 1 Gubun2,
       T8.Pummok_Code, T8.Jepum_Code,
       T1.Sisan, 
       T3.Jeon_Ipgo, T3.Up_Jeon_Ipgo, T3.Down_Jeon_Ipgo, T4.Jeon_Chulgo,
       T6.Dang_Ipgo, T6.Up_Dang_Ipgo, T6.Down_Dang_Ipgo, T7.Dang_Chulgo,
       isnull(T1.sisan,0) + isnull(T3.jeon_ipgo,0) + isnull(T3.up_jeon_ipgo,0) - isnull(T3.down_jeon_ipgo,0) - isnull(T4.jeon_chulgo,0) Jeon_Jaego,
       isnull(T1.sisan,0) + isnull(T3.jeon_ipgo,0) + isnull(T3.up_jeon_ipgo,0) - isnull(T3.down_jeon_ipgo,0) - isnull(T4.jeon_chulgo,0) +
       isnull(T6.dang_ipgo,0) + isnull(T6.up_dang_ipgo,0) - isnull(T6.down_dang_ipgo,0) - isnull(T7.dang_chulgo,0) Jaego,
       K.Pummok_Name, G.Pummok_Gubun, G.Gubun_Name, J.Jepum_Yakeo, J.Danwi
     into #tmp_09
     from #tmp_08 T8 left outer join #tmp_01 T1
                                  on T1.pummok_code = T8.pummok_code
                                 and T1.jepum_code = T8.jepum_code
                     left outer join #tmp_03 T3
                                  on T3.pummok_code = T8.pummok_code
                                 and T3.jepum_code = T8.jepum_code
                     left outer join #tmp_04 T4
                                  on T4.pummok_code = T8.pummok_code
                                 and T4.jepum_code = T8.jepum_code
                     left outer join #tmp_06 T6
                                  on T6.pummok_code = T8.pummok_code
                                 and T6.jepum_code = T8.jepum_code
                     left outer join #tmp_07 T7
                                  on T7.pummok_code = T8.pummok_code
                                 and T7.jepum_code = T8.jepum_code
                     left outer join cm_pummok K
                                  on K.pummok_code = T8.pummok_code
                     left outer join cm_pummok_gubun G
                                  on G.pummok_gubun = K.pummok_gubun
                     left outer join cm_jepum J
                                  on J.pummok_code = T8.pummok_code
                                 and J.jepum_code = T8.jepum_code

select 1 gubun, 2 gubun2,
       pummok_code, cast(null as int) jepum_code,
       sum(sisan) sisan,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo, sum(jeon_chulgo) jeon_chulgo,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo, sum(dang_chulgo) dang_chulgo,
       sum(jeon_jaego) jeon_jaego,
       sum(jaego) jaego,
       pummok_name, pummok_gubun, cast(null as varchar(50)) gubun_name, cast('소계' as varchar(50)) jepum_yakeo, cast(null as varchar(10)) danwi
     into #tmp_10
     from #tmp_09
 group by pummok_code, pummok_name, pummok_gubun

select 2 gubun, 1 gubun2,
       cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code,
       sum(sisan) sisan,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo, sum(jeon_chulgo) jeon_chulgo,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo, sum(dang_chulgo) dang_chulgo,
       sum(jeon_jaego) jeon_jaego,
       sum(jaego) jaego,
       cast(null as varchar(50)) pummok_name, cast(null as int) pummok_gubun, cast(null as varchar(50)) gubun_name, cast('합계' as varchar(50)) jepum_yakeo, cast(null as varchar(10)) danwi
     into #tmp_11
     from #tmp_10

select * into #tmp_12 from #tmp_09 union all
select *              from #tmp_10 union all
select *              from #tmp_11

select *
     from #tmp_12
 order by gubun, pummok_code, gubun2

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

