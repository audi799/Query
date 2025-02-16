declare @companyCode varchar(7), @year varchar(4)

set @companyCode = 'BO_301'
set @year = '2017'

select @companyCode company_code, @year yy, jajae_code
     into #tmp_01
     from jj_jajae
    where isnull(jaego_use,0) = 1

select *
     into #tmp_02
     from jj_sisan
    where company_code = @companyCode
      and yy = @year

select company_code, yy, jajae_code into #tmp_03 from #tmp_01 union
select company_code, yy, jajae_code              from #tmp_02

select T.company_code, T.yy, T.jajae_code, isnull(S.suryang, 0) suryang,
       J.jajae_gubun vt_jajae_gubun, J.vt_jajae_gubun_name, J.jajae_name vt_jajae_name
     from #tmp_03 T left outer join #tmp_02 S
                                 on S.company_code = T.company_code
                                and S.yy = T.yy
                                and S.jajae_code = T.jajae_code
                    left outer join vw_jajae J
                                 on J.jajae_code = T.jajae_code
 order by J.vt_jajae_gubun_name, J.jajae_name

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03

