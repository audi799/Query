select pummok_code, jepum_code, sum(suryang) sisan
     into #tmp_01
     from yu_jaego
    where year = '2020'
 group by pummok_code, jepum_code

select pummok_code, jepum_code,
       case when isnull(ipgo_gubun, 'N') in ('N', 'M')           then sum(suryang) end ipgo, 
       case when isnull(ipgo_gubun, 'N') = 'U'                   then sum(suryang) end up_ipgo, 
       case when isnull(ipgo_gubun, 'N') in ('D', 'B', 'T', 'P') then sum(suryang) end down_ipgo 
     into #tmp_02
     from yu_ipgo
 group by pummok_code, jepum_code, ipgo_gubun

select pummok_code, jepum_code,
       sum(ipgo) ipgo, sum(up_ipgo) up_ipgo, sum(down_ipgo) down_ipgo
     into #tmp_03
     from #tmp_02
 group by pummok_code, jepum_code

select PP.pummok_code, PP.jepum_code, sum(JP.suryang) chulgo 
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
      and JP.ymd <  '2020-12-31'
      and isnull(C.hoecha_chk, '') = ''
 group by PP.pummok_code, PP.jepum_code 

select pummok_code, jepum_code into #tmp_05 from #tmp_01 union 
select pummok_code, jepum_code              from #tmp_03 union
select pummok_code, jepum_code              from #tmp_04

select T5.pummok_code, T5.jepum_code,
       T1.sisan, T3.ipgo, T3.up_ipgo, T3.down_ipgo,
       T4.chulgo,
       cast(null as numeric(18,0)) jaego
     into #tmp_06
     from #tmp_05 T5 left outer join #tmp_01 T1
                                  on T1.pummok_code = T5.pummok_code
                                 and T1.jepum_code = T5.jepum_code
                     left outer join #tmp_03 T3
                                  on T3.pummok_code = T5.pummok_code
                                 and T3.jepum_code = T5.jepum_code
                     left outer join #tmp_04 T4
                                  on T4.pummok_code = T5.pummok_code
                                 and T4.jepum_code = T5.jepum_code

update #tmp_06 set sisan = 0 where sisan is null
update #tmp_06 set ipgo = 0 where ipgo is null
update #tmp_06 set up_ipgo = 0 where up_ipgo is null
update #tmp_06 set down_ipgo = 0 where down_ipgo is null
update #tmp_06 set chulgo = 0 where chulgo is null
update #tmp_06 set jaego = sisan + ipgo + up_ipgo - down_ipgo - chulgo

insert into yu_jaego
select '2021', pummok_code, jepum_code, jaego
     from #tmp_06
                 
drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
