declare @year varchar(4)
declare @cust_gubun int

set @year = '2016'     --- 변경할 단가년도
set @cust_gubun = 1    --- 변경할 관급,사급 (관급:3, 사급:1)

--------------거래처

update cm_cust set danga_year = @year
    where cust_gubun_2 = @cust_gubun 

-------------현장
select H.*
     into #tmp_01
     from cm_hyeonjang H left outer join cm_cust C
                                      on H.cust_code = C.cust_code
    where C.cust_gubun_2 = @cust_gubun 

update #tmp_01 set danga_year = @year


update cm_hyeonjang set danga_year = T.danga_year
     from cm_hyeonjang H, #tmp_01 T
    where H.cust_code = T.cust_code
      and H.hyeonjang_code = T.hyeonjang_code


drop table #tmp_01
