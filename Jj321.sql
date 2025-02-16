declare @companyCode varchar(7), @startProgYmd varchar(10), @ymd_1 varchar(10), @ymd_2 varchar(10), @jajaeCode varchar(20)

set @companyCode = 'BO_301'
set @startProgYmd = '2015-01-01'
set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-12-31'
set @jajaeCode = '0000000001'

select jajae_code, sum(suryang) j_sisan_su
     into #tmp_00
     from jj_sisan
    where company_code = @companyCode
      and yy = left(@startProgYmd, 4)
 group by jajae_code

select jajae_code, sum(suryang) j_ipgo_su
     into #tmp_01
     from jj_maeip
    where company_code = @companyCode
      and jajae_code = @jajaeCode
      and ymd >= @startProgYmd
      and ymd < @ymd_1
 group by jajae_code

select jajae_code, sum(suryang) j_chulgo_su
     into #tmp_02
     from jj_chulgo
    where company_code = @companyCode
      and jajae_code = @jajaeCode
      and ymd >= @startProgYmd
      and ymd < @ymd_1
 group by jajae_code

select J.jajae_code, isnull(JS.j_sisan_su,0) + isnull(JI.j_ipgo_su, 0) - isnull(JC.j_chulgo_su,0) j_su
     into #tmp_03
     from vw_jajae J left outer join #tmp_00 JS
                                  on JS.jajae_code = J.jajae_code
                     left outer join #tmp_01 JI
                                  on JI.jajae_code = J.jajae_code
                     left outer join #tmp_02 JC
                                  on JC.jajae_code = J.jajae_code
    where J.jajae_code = @jajaeCode

select S.jajae_code, cast(0 as tinyint) hapGubun, 
       cast(1 as tinyint) sortGubun1, cast(1 as tinyint) sortGubun2, cast(0 as tinyint) lineDis,
       S.ymd, cast( convert(char(10), S.ymd, 120) as varchar(20)) strYmd, 
       S.maeip_cust, C.sangho_yakeo sangho, sum(S.suryang) ipgo, cast(0 as numeric(18,3)) chulgo, 
       cast(0 as numeric(18,3)) jaego, S.bigo
     into #tmp_04
     from jj_maeip S left outer join cm_cust C
                                 on C.cust_code = S.maeip_cust
    where S.company_code = @companyCode
      and S.jajae_code = @jajaeCode
      and S.ymd >= @ymd_1
      and S.ymd <= @ymd_2
 group by S.jajae_code, S.ymd, S.maeip_cust, C.sangho_yakeo, S.bigo

select S.jajae_code, cast(0 as tinyint) hapGubun, 
       cast(1 as tinyint) sortGubun1, cast(2 as tinyint) sortGubun2, cast(0 as tinyint) lineDis,
       S.ymd, cast( convert(char(10), S.ymd, 120) as varchar(20)) strYmd, 
       cast(null as varchar(5)) maeip_cust, cast(null as varchar(70)) sangho, 
       cast(0 as numeric(18,3)) ipgo, sum(S.suryang) chulgo, 
       cast(0 as numeric(18,3)) jaego, S.bigo
     into #tmp_05
     from jj_chulgo S
    where S.company_code = @companyCode
      and S.jajae_code = @jajaeCode
      and S.ymd >= @ymd_1
      and S.ymd <= @ymd_2
 group by S.jajae_code, S.ymd, S.bigo

select * into #tmp_06 from #tmp_04 union all
select *              from #tmp_05

select T.*, J.vt_jajae_gubun_name, J.jajae_name,
       identity(int, 1, 1) sno
     into #tmp_07
     from #tmp_06 T left outer join vw_jajae J
                                 on J.jajae_code = T.jajae_code
 order by T.jajae_code, T.ymd, T.sortGubun2

update #tmp_07 set jaego = (select isnull(j_su,0) from #tmp_03 )
                         + (select sum(ipgo - chulgo) from #tmp_07 T where T.sno <= #tmp_07.sno)

select jajae_code, cast(1 as tinyint) hapGubun, 
       cast(2 as tinyint) sortGubun1, cast(2 as tinyint) sortGubun2, cast(1 as tinyint) lineDis,
       cast(null as smalldatetime) ymd, cast('ÇÕ°è' as varchar(20)) strYmd, 
       cast(null as varchar(5)) maeip_cust, cast(null as varchar(70)) sangho, 
       sum(ipgo) ipgo, sum(chulgo) chulgo, 
       cast(0 as numeric(18,3)) jaego, cast(null as varchar(50)) bigo,
       vt_jajae_gubun_name, jajae_name, max(sno) sno
     into #tmp_08
     from #tmp_07
 group by jajae_code, vt_jajae_gubun_name, jajae_name

select * from #tmp_07 union all
select * from #tmp_08
order by sortGubun1, ymd, sortgubun2

drop table #tmp_00
drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07
drop table #tmp_08
