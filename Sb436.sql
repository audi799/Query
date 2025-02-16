select company_code, year, pummok_code, jepum_code, sum(suryang) sisan
     into #tmp_01
     from yu_jaego
    where year = '2020'
 group by company_code, year, pummok_code, jepum_code

select 'BO_301' company_code, pummok_code, jepum_code,
       case when isnull(ipgo_gubun, 'N') in ('N', 'M') then sum(suryang) end jeon_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'U'         then sum(suryang) end up_jeon_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'D'         then sum(suryang) end down_jeon_ipgo
     into #tmp_02
     from yu_ipgo
    where ymd >= '2020-01-01'
      and ymd <= '2020-06-25'
      and isnull(ipgo_gubun, 'N') in ('N', 'M', 'U', 'D')
 group by pummok_code, jepum_code, ipgo_gubun

select company_code, pummok_code, jepum_code,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo
     into #tmp_03
     from #tmp_02
 group by company_code, pummok_code, jepum_code

select P.company_code, PP.pummok_code, PP.jepum_code, sum(JP.suryang) jeon_chulgo
     into #tmp_04
     from yu_chulha_jp JP left outer join yu_chulha_plan P 
                                       on P.ymd = JP.ymd
                                      and P.nno = JP.chulha_plan_no
                          left outer join yu_chulha_plan_jp PP
                                       on PP.ymd = JP.ymd
                                      and PP.nno = JP.chulha_plan_no 
                                      and PP.sno = JP.chulha_plan_sno
                          left outer join yu_chulha C
                                       on C.ymd = JP.ymd 
                                      and C.nno = JP.nno
                                      and C.chulha_plan_no = JP.chulha_plan_no
    where JP.ymd >= '2020-01-01'
      and JP.ymd <= '2020-06-25'
      and isnull(C.hoecha_chk, '') = ''
 group by P.company_code, PP.pummok_code, PP.jepum_code

select company_code, pummok_code, jepum_code, sum(suryang) jeon_move_down_suryang
     into #tmp_05
     from move_jaego
    where ymd >= '2020-01-01'
      and ymd <= '2020-06-25'
 group by company_code, pummok_code, jepum_code

select move_company company_code, pummok_code, jepum_code, sum(suryang) jeon_move_up_suryang
     into #tmp_06
     from move_jaego
    where ymd >= '2020-01-01'
      and ymd <= '2020-06-25'
 group by move_company, pummok_code, jepum_code

select 'BO_301' company_code, pummok_code, jepum_code,
       case when isnull(ipgo_gubun, 'N') in ('N', 'M') then sum(suryang) end dang_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'U'         then sum(suryang) end up_dang_ipgo,
       case when isnull(ipgo_gubun, 'N') = 'D'         then sum(suryang) end down_dang_ipgo
     into #tmp_07
     from yu_ipgo
    where ymd >= '2020-06-26'
      and ymd <= '2020-06-26'
      and isnull(ipgo_gubun, 'N') in ('N', 'M', 'U', 'D')
 group by pummok_code, jepum_code, ipgo_gubun

select company_code, pummok_code, jepum_code,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo
     into #tmp_08
     from #tmp_07
 group by company_code, pummok_code, jepum_code

select P.company_code, PP.pummok_code, PP.jepum_code, sum(JP.suryang) dang_chulgo
     into #tmp_09
     from yu_chulha_jp JP left outer join yu_chulha_plan P
                                       on P.ymd = JP.ymd
                                      and P.nno = JP.chulha_plan_no
                          left outer join yu_chulha_plan_jp PP
                                       on PP.ymd = JP.ymd
                                      and PP.nno = JP.chulha_plan_no 
                                      and PP.sno = JP.chulha_plan_sno
                          left outer join yu_chulha C
                                       on C.ymd = JP.ymd 
                                      and C.nno = JP.nno
                                      and C.chulha_plan_no = JP.chulha_plan_no
    where JP.ymd >= '2020-06-26'
      and JP.ymd <= '2020-06-26'
      and isnull(C.hoecha_chk, '') = ''
 group by P.company_code, PP.pummok_code, PP.jepum_code

select company_code, pummok_code, jepum_code, sum(suryang) dang_move_down_suryang
     into #tmp_10
     from move_jaego
    where ymd >= '2020-06-26'
      and ymd <= '2020-06-26'
 group by company_code, pummok_code, jepum_code

select move_company company_code, pummok_code, jepum_code, sum(suryang) dang_move_up_suryang
     into #tmp_11
     from move_jaego
    where ymd >= '2020-06-26'
      and ymd <= '2020-06-26'
 group by move_company, pummok_code, jepum_code


select company_code, pummok_code, jepum_code into #tmp_12 from #tmp_01 union 
select company_code, pummok_code, jepum_code              from #tmp_03 union 
select company_code, pummok_code, jepum_code              from #tmp_04 union 
select company_code, pummok_code, jepum_code              from #tmp_05 union 
select company_code, pummok_code, jepum_code              from #tmp_06 union 
select company_code, pummok_code, jepum_code              from #tmp_08 union
select company_code, pummok_code, jepum_code              from #tmp_09 union
select company_code, pummok_code, jepum_code              from #tmp_10 union
select company_code, pummok_code, jepum_code              from #tmp_11 

select 1 Gubun, 1 Gubun2,
       T.company_code, T.Pummok_Code, T.Jepum_Code,
       T1.Sisan, 
       T3.Jeon_Ipgo, T3.Up_Jeon_Ipgo, T3.Down_Jeon_Ipgo, T4.Jeon_Chulgo,
       T5.jeon_move_down_suryang, T6. jeon_move_up_suryang,
       T8.Dang_Ipgo, T8.Up_Dang_Ipgo, T8.Down_Dang_Ipgo, T9.Dang_Chulgo,
       T10.dang_move_down_suryang, T11.dang_move_up_suryang,
       isnull(T1.sisan,0) + isnull(T3.jeon_ipgo,0) + isnull(T3.up_jeon_ipgo,0) - isnull(T3.down_jeon_ipgo,0) - isnull(T4.jeon_chulgo,0) - isnull(T5.jeon_move_down_suryang,0) + isnull(T6.jeon_move_up_suryang,0) Jeon_Jaego,
       isnull(T1.sisan,0) + isnull(T3.jeon_ipgo,0) + isnull(T3.up_jeon_ipgo,0) - isnull(T3.down_jeon_ipgo,0) - isnull(T4.jeon_chulgo,0) - isnull(T5.jeon_move_down_suryang,0) + isnull(T6.jeon_move_up_suryang,0) +
       isnull(T8.dang_ipgo,0) + isnull(T8.up_dang_ipgo,0) - isnull(T8.down_dang_ipgo,0) - isnull(T9.dang_chulgo,0) - isnull(T10.dang_move_down_suryang,0) + isnull(T11.dang_move_up_suryang,0) Jaego,
       K.Pummok_Name, G.Pummok_Gubun, G.Gubun_Name, J.Jepum_Yakeo, J.Danwi, C.sangho company_name
     into #tmp_13
     from #tmp_12 T left outer join #tmp_01 T1
                                 on T1.company_code = T.company_code
                                and T1.pummok_code = T.pummok_code
                                and T1.jepum_code = T.jepum_code
                    left outer join #tmp_03 T3
                                 on T3.company_code = T.company_code
                                and T3.pummok_code = T.pummok_code
                                and T3.jepum_code = T.jepum_code
                    left outer join #tmp_04 T4
                                 on T4.company_code = T.company_code
                                and T4.pummok_code = T.pummok_code
                                and T4.jepum_code = T.jepum_code
                    left outer join #tmp_05 T5
                                 on T5.company_code = T.company_code
                                and T5.pummok_code = T.pummok_code
                                and T5.jepum_code = T.jepum_code
                    left outer join #tmp_06 T6
                                 on T6.company_code = T.company_code
                                and T6.pummok_code = T.pummok_code
                                and T6.jepum_code = T.jepum_code
                    left outer join #tmp_08 T8
                                 on T8.company_code = T.company_code
                                and T8.pummok_code = T.pummok_code
                                and T8.jepum_code = T.jepum_code
                    left outer join #tmp_09 T9
                                 on T9.company_code = T.company_code
                                and T9.pummok_code = T.pummok_code
                                and T9.jepum_code = T.jepum_code
                    left outer join #tmp_10 T10
                                 on T10.company_code = T.company_code
                                and T10.pummok_code = T.pummok_code
                                and T10.jepum_code = T.jepum_code
                    left outer join #tmp_11 T11
                                 on T11.company_code = T.company_code
                                and T11.pummok_code = T.pummok_code
                                and T11.jepum_code = T.jepum_code
                    left outer join cm_company C
                                 on C.company_code = T.company_code
                    left outer join cm_pummok K
                                 on K.pummok_code = T.pummok_code
                    left outer join cm_pummok_gubun G
                                 on G.pummok_gubun = K.pummok_gubun
                    left outer join cm_jepum J
                                 on J.pummok_code = T.pummok_code
                                and J.jepum_code = T.jepum_code

select 1 gubun, 2 gubun2,
       company_code, pummok_code, cast(null as int) jepum_code,
       sum(sisan) sisan,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo, sum(jeon_chulgo) jeon_chulgo, sum(jeon_move_down_suryang) jeon_move_down_suryang, sum(jeon_move_up_suryang) jeon_move_up_suryang,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo, sum(dang_chulgo) dang_chulgo, sum(dang_move_down_suryang) dang_move_down_suryang, sum(dang_move_up_suryang) dang_move_up_suryang,
       sum(jeon_jaego) jeon_jaego,
       sum(jaego) jaego,
       pummok_name, pummok_gubun, cast(null as varchar(50)) gubun_name, cast('[소계]' as varchar(50)) jepum_yakeo, cast(null as varchar(10)) danwi, company_name
     into #tmp_14
     from #tmp_13
 group by company_code, pummok_code, pummok_name, pummok_gubun, company_name

select 2 gubun, 1 gubun2,
       company_code, cast(null as varchar(4)) pummok_code, cast(null as int) jepum_code,
       sum(sisan) sisan,
       sum(jeon_ipgo) jeon_ipgo, sum(up_jeon_ipgo) up_jeon_ipgo, sum(down_jeon_ipgo) down_jeon_ipgo, sum(jeon_chulgo) jeon_chulgo, sum(jeon_move_down_suryang) jeon_move_down_suryang, sum(jeon_move_up_suryang) jeon_move_up_suryang,
       sum(dang_ipgo) dang_ipgo, sum(up_dang_ipgo) up_dang_ipgo, sum(down_dang_ipgo) down_dang_ipgo, sum(dang_chulgo) dang_chulgo, sum(dang_move_down_suryang) dang_move_down_suryang, sum(dang_move_up_suryang) dang_move_up_suryang,
       sum(jeon_jaego) jeon_jaego,
       sum(jaego) jaego,
       cast(null as varchar(50)) pummok_name, cast(null as int) pummok_gubun, cast(null as varchar(50)) gubun_name, cast(company_name + '[합계]' as varchar(50)) jepum_yakeo, cast(null as varchar(10)) danwi, company_name
     into #tmp_15
     from #tmp_14
 group by company_code, company_name

select * into #tmp_16 from #tmp_13 union all
select *              from #tmp_14 union all
select *              from #tmp_15

select *
     from #tmp_16
 order by company_name, gubun, pummok_code, gubun2

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