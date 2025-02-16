declare @ymd_1 varchar(10), @ymd_2 varchar(10),
        @custCode varchar(5), @hyeonjangCode varchar(4),
        @jepumCode int, @danga int

set @ymd_1 = '2017-06-01'
set @ymd_2 = '2017-06-15'
set @custCode = '10007'
set @hyeonjangCode = '0001'
set @jepumCode = 250210120
-- 변경단가로 수정
set @danga = 20000

select P.*,
       case when C.hyeonjang_gubun = 1 then C.vat_gubun else H.vat_gubun end vat_gubun
     into #tmp_01
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_hyeonjang H
                                   on H.cust_code = P.cust_code
                                  and H.hyeonjang_code = P.hyeonjang_code
    where P.ymd >= @ymd_1
      and P.ymd <= @ymd_2
      and P.cust_code = @custCode
      and P.hyeonjang_code = @hyeonjangCode
      and P.jepum_code = @jepumCode

update #tmp_01 set danga = @danga

select ymd, nno, cust_code, hyeonjang_code, jepum_code, vat_gubun,
       danga,
       geumaek, seaek,
       case when vat_gubun = 1 then round(suryang * danga * 1.1, 0)
                               else round(suryang * danga, 0) end hapgye_geumaek
     into #tmp_02
     from #tmp_01

update #tmp_02 set geumaek = round(hapgye_geumaek / 1.1, 0)
update #tmp_02 set seaek = hapgye_geumaek - geumaek

update yu_panmae set danga = T.danga,
                     geumaek = T.geumaek,
                     seaek = T.seaek,
                     hapgye_geumaek = T.hapgye_geumaek
     from yu_panmae P, #tmp_02 T
    where T.ymd = P.ymd
      and T.nno = P.nno
      and T.cust_code = P.cust_code
      and T.hyeonjang_code = P.hyeonjang_code
      and T.jepum_code = P.jepum_code

drop table #tmp_01
drop table #tmp_02