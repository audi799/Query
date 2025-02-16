declare @companyCode varchar(7), @startProgYmd varchar(10), @ymd_1 varchar(10), @ymd_2 varchar(10)

set @companyCode = 'BO_301'
set @startProgYmd = '2015-01-01'
set @ymd_1 = '2020-01-01'
set @ymd_2 = '2020-03-04'

select jajae_code, sum(suryang) j_sisan_su
     into #tmp_00
     from jj_sisan
    where company_code = @companyCode
      and yy = left(@ymd_1, 4)
 group by jajae_code

select S.jajae_code, sum(S.suryang) j_ipgo_su
     into #tmp_01
     from jj_maeip S, jj_jajae J
    where S.company_code = @companyCode
      and J.jajae_code = S.jajae_code
      and J.jaego_use = 1
      and S.ymd >= @startProgYmd
      and S.ymd < @ymd_1
 group by S.jajae_code

select S.jajae_code, sum(S.suryang) j_chulgo_su
     into #tmp_02
     from jj_chulgo S, jj_jajae J
    where S.company_code = @companyCode
      and J.jajae_code = S.jajae_code
      and J.jaego_use = 1
      and S.ymd >= @startProgYmd
      and S.ymd < @ymd_1
 group by S.jajae_code 

select S.jajae_code, sum(S.suryang) ipgo_su
     into #tmp_03
     from jj_maeip S, jj_jajae J
    where S.company_code = @companyCode
      and J.jajae_code = S.jajae_code
      and J.jaego_use = 1
      and S.ymd >= @ymd_1
      and S.ymd <= @ymd_2
 group by S.jajae_code

select S.jajae_code, sum(S.suryang) chulgo_su
     into #tmp_04
     from jj_chulgo S, jj_jajae J
    where S.company_code = @companyCode
      and J.jajae_code = S.jajae_code
      and J.jaego_use = 1
      and S.ymd >= @ymd_1
      and S.ymd <= @ymd_2
 group by S.jajae_code 

select jajae_code into #tmp_05 from #tmp_00 union
select jajae_code              from #tmp_01 union
select jajae_code              from #tmp_02 union
select jajae_code              from #tmp_03 union
select jajae_code              from #tmp_04

select T.jajae_code, 
       isnull(JS.j_sisan_su,0) + isnull(JI.j_ipgo_su,0) - isnull(JC.j_chulgo_su,0) j_su,
       isnull(I.ipgo_su,0) ipgo_su, isnull(C.chulgo_su,0) chulgo_su,
       isnull(JS.j_sisan_su,0) + isnull(JI.j_ipgo_su,0) - isnull(JC.j_chulgo_su,0) + isnull(I.ipgo_su,0) - isnull(C.chulgo_su,0) jaego_su
     into #tmp_06
     from #tmp_05 T left outer join #tmp_00 JS
                                 on JS.jajae_code = T.jajae_code
                    left outer join #tmp_01 JI
                                 on JI.jajae_code = T.jajae_code
                    left outer join #tmp_02 JC
                                 on JC.jajae_code = T.jajae_code
                    left outer join #tmp_03 I
                                 on I.jajae_code = T.jajae_code
                    left outer join #tmp_04 C
                                 on C.jajae_code = T.jajae_code

select T.*, J.jajae_gubun, J.vt_jajae_gubun_name, J.jajae_name, J.vt_jajae
     from #tmp_06 T left outer join vw_jajae J
                                 on J.jajae_code = T.jajae_code
 order by J.jajae_gubun, J.jajae_name

drop table #tmp_00
drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
