declare @companyCode varchar(7), @ymd_1 varchar(10), @ymd_2 varchar(10)

set @companyCode = 'SB_301'
set @ymd_1 = '2015-01-01'
set @ymd_2 = '2020-06-08'

select I.company_code, I.ymd, I.maeip_cust, C.sangho_yakeo sangho,
       min(I.jajae_name) jajae_name,
       sum(I.suryang) suryang, sum(I.geumaek) geumaek, sum(I.seaek) seaek, sum(I.hapgye) hapgye,
       count(*) cnt
     into #tmp_01
     from sb_ipgo I left outer join cm_cust C
                                  on C.cust_code = I.maeip_cust
    where I.company_code = @companyCode
      and I.ymd >= @ymd_1
      and I.ymd <= @ymd_2
 group by I.company_code, I.ymd, I.maeip_cust, C.sangho_yakeo

update #tmp_01 set jajae_name = jajae_name + ' ©э ' + cast(cnt - 1 as varchar(10)) where cnt > 1

select cast(0 as tinyint) hapGubun, cast(0 as tinyint) lineDis, cast(0 as tinyint) sortGubun1,
       T.*, cast(convert(char(10), T.ymd, 120) as varchar(20)) strYmd
     into #tmp_02
     from #tmp_01 T

select cast(1 as tinyint) hapGubun, cast(1 as tinyint) lineDis, cast(1 as tinyint) sortGubun1,
       cast(null as varchar(7)) company_code,
       cast(null as smalldatetime) ymd, cast(null as varchar(5)) maeip_cust,
       cast(null as varchar(70)) sangho,
       cast(null as varchar(100)) jajae_name, sum(suryang) suryang,
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye) hapgye, sum(cnt) cnt,
       cast('[ гу ╟Х ]' as varchar(20)) strYmd
     into #tmp_03
     from #tmp_02

select * into #tmp_04 from #tmp_02 union all
select *              from #tmp_03

select *
     from #tmp_04
 order by sortGubun1, ymd, sangho

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04