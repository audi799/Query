declare @companyCode varchar(7), @ymd smalldatetime 

set @companyCode = 'BO_301' 
set @ymd = '2020-03-04' 

select C.*, S.seolbi_name vt_seolbi_name, S.seolbi_yakeo vt_seolbi_yakeo, S.seolbi_gubun vt_seolbi_gubun, SG.gubun_name vt_seolbi_gubun_name
     into #tmp_01 
     from jj_chulgo C left outer join jj_seolbi S 
                                   on S.seolbi_code = C.seolbi_code 
                      left outer join jj_seolbi_gubun SG 
                                   on SG.seolbi_gubun = S.seolbi_gubun 
    where C.company_code = @companyCode 
      and C.ymd = @ymd 

select * 
     from #tmp_01 

drop table #tmp_01 
