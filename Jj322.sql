declare @companyCode varchar(7), @startProgYmd varchar(10), @ymd_1 varchar(10), @ymd_2 varchar(10), @jajaeCode varchar(20)

set @companyCode = 'BO_301'
set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-12-31'
set @jajaeCode = '0000000001'


select 1 sortGubun, 1 sortGubun2, ymd, convert(varchar(10), ymd, 120) strYmd, convert(varchar(7), ymd, 120) ym, jajae_code, sum(suryang) chulgo_su
     into #tmp_01
     from jj_chulgo
    where company_code = @companyCode
      and jajae_code = @jajaeCode
      and ymd >= @ymd_1
      and ymd < @ymd_2
 group by ymd, jajae_code

select 1 sortGubun, 2 sortGubun2, cast(null as varchar(10)) ymd, cast(ym + ' 소계' as varchar(20)) strYmd , ym, cast(null as int) jajae_code, sum(chulgo_su) chulgo_su
     into #tmp_02
     from #tmp_01
 group by ym

select 2 sortGubun, 1 sortGubun2, cast(null as varchar(10)) ymd, cast('합계' as varchar(20)) strYmd, cast(null as varchar(7)) ym, cast(null as int) jajae_code, sum(chulgo_su) chulgo_su
     into #tmp_03
     from #tmp_02

select * into #tmp_04 from #tmp_01 union all
select *              from #tmp_02 union all
select *              from #tmp_03

select T.*, J.jajae_name
     from #tmp_04 T left outer join jj_jajae J
                                 on J.jajae_code = T.jajae_code
 order by T.sortGubun, T.ym, T.sortGubun2

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04