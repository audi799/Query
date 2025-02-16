declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-12-31'

select 1 gubun, M.company_code, M.move_company, M.pummok_code, M.jepum_code, sum(M.suryang) suryang, 
       C.sangho company_sangho, CC.sangho move_sangho, K.pummok_name, G.gubun_name,
       J.jepum_yakeo, J.jepum_name
     into #tmp_01
     from move_jaego M left outer join cm_company C
                                    on C.company_code = M.company_code
                       left outer join cm_company CC
                                    on CC.company_code = M.move_company
                       left outer join cm_pummok K
                                    on K.pummok_code = M.pummok_code
                       left outer join cm_pummok_gubun G
                                    on G.pummok_gubun = K.pummok_gubun
                       left outer join cm_jepum J
                                    on J.pummok_code = M.pummok_code
                                   and J.jepum_code = M.jepum_code
    where M.ymd >= @ymd_1
      and M.ymd <= @ymd_2
 group by M.company_code, M.move_company, M.pummok_code, M.jepum_code, 
          C.sangho, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, J.jepum_name

select 2 gubun, company_code, cast(null as varchar(7)) move_company, pummok_code,
       jepum_code, sum(suryang) suryang,
       cast(company_sangho + '[출고계]' as varchar(30)) company_sangho, cast(null as varchar(30)) move_sangho, pummok_name,
       gubun_name, jepum_yakeo, jepum_name
     into #tmp_02
     from #tmp_01
 group by company_code, pummok_code, jepum_code, company_sangho, pummok_name, gubun_name, jepum_yakeo, jepum_name

select 3 gubun, cast(null as varchar(7)) company_code, move_company, pummok_code,
       jepum_code, sum(suryang) suryang,
       cast(null as varchar(30)) company_sangho, cast(move_sangho + '[입고계]' as varchar(30)) move_sangho, pummok_name,
       gubun_name, jepum_yakeo, jepum_name
     into #tmp_03
     from #tmp_01
 group by move_company, pummok_code, jepum_code, move_sangho, pummok_name, gubun_name, jepum_yakeo, jepum_name

select * into #tmp_04 from #tmp_02 union all
select *              from #tmp_03

update #tmp_04 set suryang = suryang * -1 where gubun = 2

select 4 gubun, 
       case when company_code is null then move_company else company_code end company_code,
       cast(null as varchar(7)) move_company, pummok_code,
       jepum_code, sum(suryang) suryang, 
       cast(null as varchar(30)) company_sangho, cast(null as varchar(30)) move_sangho, pummok_name,
       gubun_name, jepum_yakeo, jepum_name
     into #tmp_05
     from #tmp_04
 group by company_code, move_company, pummok_code, jepum_code, pummok_name, gubun_name, jepum_yakeo, jepum_name

select T.gubun, 
       T.company_code,
       T.move_company, T.pummok_code,
       T.jepum_code, sum(T.suryang) suryang, 
       cast('[입/출고계]' as varchar(30)) company_sangho, C.sangho move_sangho, T.pummok_name,
       T.gubun_name, T.jepum_yakeo, T.jepum_name
     into #tmp_06
     from #tmp_05 T left outer join cm_company C
                                 on C.company_code = T.company_code
 group by T.gubun, T.company_code, T.move_company, T.pummok_code, T.jepum_code, T.move_sangho, 
          T.pummok_name, T.gubun_name, T.jepum_yakeo, T.jepum_name, C.sangho

select * into #tmp_07 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03 union all
select *              from #tmp_06

select *
     from #tmp_07
 order by gubun, company_code, move_company, pummok_code, jepum_code

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07
