declare @year smallint 
declare @year_1 smallint 
declare @startYmd smalldatetime 
declare @ymd_1 smalldatetime 
declare @ymd_2 smalldatetime 

set @year = 2020 
set @year_1 = @year + 1 
set @startYmd = '2020-04-01' 
set @ymd_1 = cast(@year as varchar(4)) + '-01-01' 
set @ymd_2 = cast(@year as varchar(4)) + '-12-31' 

-- delete 
--      from yu_jaego 
--     where year = @year_1 

select company_code, pummok_code, jepum_code, sum(suryang) sisan 
     into #tmp_01 
     from yu_jaego 
    where year = @year 
 group by company_code, pummok_code, jepum_code 

select pummok_code, jepum_code, 
       case when isnull(ipgo_gubun, 'N') in ('N')                then sum(suryang) end ipgo, 
       case when isnull(ipgo_gubun, 'N') = 'U'                   then sum(suryang) end up_ipgo, 
       case when isnull(ipgo_gubun, 'N') in ('D', 'B', 'S', 'P') then sum(suryang) end down_ipgo 
     into #tmp_02 
     from yu_ipgo 
    where ymd >= @startYmd 
      and ymd >= @ymd_1 
      and ymd <= @ymd_2 
 group by pummok_code, jepum_code, ipgo_gubun 

select 'BO_301' company_code, pummok_code, jepum_code, 
       sum(ipgo) ipgo, sum(up_ipgo) up_ipgo, sum(down_ipgo) down_ipgo 
     into #tmp_03 
     from #tmp_02 
 group by pummok_code, jepum_code 

select P.company_code, PP.pummok_code, PP.jepum_code, sum(JP.suryang) chulgo 
     into #tmp_04 
     from yu_chulha_plan P, yu_chulha_jp JP left outer join yu_chulha_plan_jp PP 
                                                         on PP.ymd = JP.ymd 
                                                        and PP.nno = JP.chulha_plan_no 
                                                        and PP.sno = JP.chulha_plan_sno 
                                            left outer join yu_chulha C 
                                                         on C.ymd = JP.ymd 
                                                        and C.nno = JP.nno 
                                                        and C.chulha_plan_no = JP.chulha_plan_no 
    where P.ymd = JP.ymd
      and P.nno = JP.nno
      and JP.ymd >= @startYmd 
      and JP.ymd >= @ymd_1 
      and JP.ymd <= @ymd_2 
      and isnull(C.hoecha_chk, '') = '' 
 group by P.company_code, PP.pummok_code, PP.jepum_code 

select company_code, pummok_code, jepum_code, sum(suryang) minus_suryang
     into #tmp_05
     from move_jaego
    where ymd >= @ymd_1
      and ymd <= @ymd_2
 group by company_code, pummok_code, jepum_code

select move_company company_code, pummok_code, jepum_code, sum(suryang) plus_suryang
     into #tmp_06
     from move_jaego
    where ymd >= @ymd_1
      and ymd <= @ymd_2
 group by move_company, pummok_code, jepum_code


select company_code, pummok_code, jepum_code into #tmp_07 from #tmp_01 union 
select company_code, pummok_code, jepum_code              from #tmp_03 union 
select company_code, pummok_code, jepum_code              from #tmp_04 union
select company_code, pummok_code, jepum_code              from #tmp_05 union 
select company_code, pummok_code, jepum_code              from #tmp_06 

select T7.company_code, T7.pummok_code, T7.jepum_code, T1.sisan, T3.ipgo, T3.up_ipgo, T3.down_ipgo, T4.chulgo, 
       T5.minus_suryang, T6.plus_suryang,
       cast(null as numeric(18,0)) jaego 
     into #tmp_08 
     from #tmp_07 T7 left outer join #tmp_01 T1 
                                  on T1.company_code = T7.company_code
                                 and T1.pummok_code = T7.pummok_code 
                                 and T1.jepum_code = T7.jepum_code 
                     left outer join #tmp_03 T3 
                                  on T3.company_code = T7.company_code
                                 and T3.pummok_code = T7.pummok_code 
                                 and T3.jepum_code = T7.jepum_code 
                     left outer join #tmp_04 T4 
                                  on T4.company_code = T7.company_code
                                 and T4.pummok_code = T7.pummok_code 
                                 and T4.jepum_code = T7.jepum_code 
                     left outer join #tmp_05 T5
                                  on T5.company_code = T7.company_code
                                 and T5.pummok_code = T7.pummok_code 
                                 and T5.jepum_code = T7.jepum_code 
                     left outer join #tmp_06 T6
                                  on T6.company_code = T7.company_code
                                 and T6.pummok_code = T7.pummok_code 
                                 and T6.jepum_code = T7.jepum_code 

update #tmp_08 set sisan = 0 where sisan is null 
update #tmp_08 set ipgo = 0 where ipgo is null 
update #tmp_08 set up_ipgo = 0 where up_ipgo is null 
update #tmp_08 set down_ipgo = 0 where down_ipgo is null 
update #tmp_08 set chulgo = 0 where chulgo is null 
update #tmp_08 set minus_suryang = 0 where minus_suryang is null
update #tmp_08 set plus_suryang = 0 where plus_suryang is null
update #tmp_08 set jaego = sisan + ipgo + up_ipgo - down_ipgo - chulgo + plus_suryang - minus_suryang

--insert into yu_jaego 
select @year_1 year, company_code, pummok_code, jepum_code, jaego 
     from #tmp_08
 order by company_code, pummok_code, jepum_code

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05 
drop table #tmp_06 
drop table #tmp_07
drop table #tmp_08 
