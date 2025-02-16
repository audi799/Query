declare @nowYmd varchar(10) 
declare @startYmd varchar(10) 
declare @yy varchar(40) 

set @nowYmd = '2020-03-10' 
set @yy = '2020' 
set @startYmd = '2020-01-01' 

select pummok_code, jepum_code, sum(suryang) sisan 
     into #tmp_01 
     from yu_jaego 
    where year = @yy 
 group by pummok_code, jepum_code 

select pummok_code, jepum_code, 
       case when ymd >= @startYmd and ymd <= @nowYmd and isnull(ipgo_gubun,'N') in ('N')                 then sum(suryang) end ipgo, 
       case when ymd >= @startYmd and ymd <= @nowYmd and isnull(ipgo_gubun, 'N') = 'U'                   then sum(suryang) end up_ipgo, 
       case when ymd >= @startYmd and ymd <= @nowYmd and isnull(ipgo_gubun, 'N') in ('D', 'B', 'S', 'P') then sum(suryang) end down_ipgo, 

       case when ymd = @nowYmd and isnull(ipgo_gubun,'N') in ('N')            then sum(suryang) end dang_ipgo, 
       case when ymd = @nowYmd and isnull(ipgo_gubun, 'N') = 'U'              then sum(suryang) end dang_up_ipgo, 
       case when ymd = @nowYmd and isnull(ipgo_gubun, 'N') in ('D', 'B', 'P') then sum(suryang) end dang_down_ipgo, 
       case when ymd = @nowYmd and isnull(ipgo_gubun, 'N') = 'S'              then sum(suryang) end dang_down_s_ipgo 
     into #tmp_02 
     from yu_ipgo 
    where ymd >= @startYmd 
      and ymd <= @nowYmd 
 group by pummok_code, jepum_code, ipgo_gubun, ymd 

select pummok_code, jepum_code, sum(ipgo) ipgo, sum(up_ipgo) up_ipgo, sum(down_ipgo) down_ipgo, sum(dang_ipgo) dang_ipgo, sum(dang_up_ipgo) dang_up_ipgo, sum(dang_down_ipgo) dang_down_ipgo, sum(dang_down_s_ipgo) dang_down_s_ipgo 
     into #tmp_03 
     from #tmp_02 
 group by pummok_code, jepum_code 

select PP.pummok_code, PP.jepum_code, 
       case when PP.ymd >= @startYmd and PP.ymd <= @nowYmd then sum(CP.suryang) end chulgo, 
       case when PP.ymd = @nowYmd                             then sum(CP.suryang) end dang_chulha 
     into #tmp_04 
     from yu_chulha_plan_jp PP left outer join yu_chulha_jp CP 
                                            on CP.ymd = PP.ymd 
                                           and CP.chulha_plan_no = PP.nno 
                                           and CP.chulha_plan_sno = PP.sno 
                               left outer join yu_chulha C 
                                            on C.ymd = PP.ymd 
                                           and C.chulha_plan_no = PP.nno 
    where isnull(C.hoecha_chk,'') = '' 
      and PP.ymd >= @startYmd 
      and PP.ymd <= @nowYmd 
 group by PP.pummok_code, PP.jepum_code, PP.ymd 

select pummok_code, jepum_code, sum(chulgo) chulgo, sum(dang_chulha) dang_chulha 
     into #tmp_05 
     from #tmp_04 
 group by pummok_code, jepum_code 

select pummok_code, jepum_code into #tmp_06 from #tmp_01 union 
select pummok_code, jepum_code              from #tmp_03 union 
select pummok_code, jepum_code              from #tmp_05 

select 1 sortGubun, 1 sortGubun2, T.pummok_code, T.jepum_code, T1.sisan, T3.ipgo, T3.up_ipgo, T3.down_ipgo, T5.chulgo, T5.dang_chulha, T3.dang_ipgo, T3.dang_up_ipgo, T3.dang_down_ipgo, T3.dang_down_s_ipgo, 
       isnull(T3.dang_ipgo,0) + isnull(T3.dang_up_ipgo,0) - isnull(T3.dang_down_ipgo,0) - isnull(T3.dang_down_s_ipgo,0) dang_total_ipgo, 
       isnull(T1.sisan,0) + isnull(T3.ipgo,0) + isnull(T3.up_ipgo,0) - isnull(T3.down_ipgo,0) - isnull(T5.chulgo,0) jaego, 
       K.pummok_name, J.jepum_yakeo 
     into #tmp_07 
     from #tmp_06 T left outer join #tmp_01 T1 
                                 on T1.pummok_code = T.pummok_code 
                                and T1.jepum_code = T.jepum_code 
                    left outer join #tmp_03 T3 
                                 on T3.pummok_code = T.pummok_code 
                                and T3.jepum_code = T.jepum_code 
                    left outer join #tmp_05 T5 
                                 on T5.pummok_code = T.pummok_code 
                                and T5.jepum_code = T.jepum_code 
                    left outer join cm_pummok K 
                                 on K.pummok_code = T.pummok_code 
                    left outer join cm_jepum J 
                                 on J.pummok_code = T.pummok_code 
                                and J.jepum_code = T.jepum_code 
    where isnull(T3.ipgo,0) <> 0 
       or isnull(T5.dang_chulha,0) <> 0 

select 1 sortGubun, 2 sortGubun2, pummok_code, cast(null as int) jepum_code, 
       sum(sisan) sisan, sum(ipgo) ipgo, sum(up_ipgo) up_ipgo, sum(down_ipgo) down_ipgo, sum(dang_ipgo) dang_ipgo, sum(dang_up_ipgo) dang_up_ipgo, sum(dang_down_ipgo) dang_down_ipgo, 
       sum(dang_down_s_ipgo) dang_down_s_ipgo, sum(dang_total_ipgo) dang_total_ipgo, sum(chulgo) chulgo, sum(dang_chulha) dang_chulha, sum(jaego) jaego, 
       cast(' [ 소 계 ] ' as varchar(50)) pummok_name, cast(null as varchar(50)) jepum_yakeo 
     into #tmp_08 
     from #tmp_07 
 group by pummok_code 

select 2 sortGubun, 1 sortGubun2, cast(null as varchar(20)) pummok_code, cast(null as int) jepum_code, 
       sum(sisan) sisan, sum(ipgo) ipgo, sum(up_ipgo) up_ipgo, sum(down_ipgo) down_ipgo, sum(dang_ipgo) dang_ipgo, sum(dang_up_ipgo) dang_up_ipgo, sum(dang_down_ipgo) dang_down_ipgo, 
       sum(dang_down_s_ipgo) dang_down_s_ipgo, sum(dang_total_ipgo) dang_total_ipgo, sum(chulgo) chulgo, sum(dang_chulha) dang_chulha, sum(jaego) jaego, 
       cast(' [ ** 합 계 ** ] ' as varchar(50)) pummok_name, cast(null as varchar(50)) jepum_yakeo 
     into #tmp_09 
     from #tmp_08 

select * into #tmp_10 from #tmp_07 union all 
select *              from #tmp_08 union all 
select *              from #tmp_09 

select * 
     from #tmp_10 
 order by sortGubun, pummok_code, sortGubun2 

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
