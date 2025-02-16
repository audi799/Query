delete 
     from yu_unbanbi_naeyeok 
    where ymd = '2024-03-08' 

declare @ymd varchar(10)
declare @companyCode varchar(6)

set @ymd = '2024-03-08' 
set @companyCode = 'RM_1BG'

select max(OrderNo) OrderNo, CompanyCode, InvoiceYmd, InvoiceNo 
     into #tmp_01
     from dbser1.RemiconRadio.dbo.Rr_OrderResult 
    where CompanyCode = @companyCode 
      and invoiceYmd = @ymd 
 group by CompanyCode, InvoiceYmd, InvoiceNo 

select T.*,
       round(R.ToFactoryDistance / 1000.0, 2) total_km
     into #tmp_02
     from #tmp_01 T, dbser1.RemiconRadio.dbo.Rr_OrderResult R
    where R.OrderNo = T.OrderNo 
      and R.CompanyCode = T.CompanyCode 
      and R.InvoiceYmd = T.InvoiceYmd 
      and R.InvoiceNo = T.InvoiceNo 

select C.car_code, C.suryang, C.ymd, C.nno, C.chulha_plan_no, P.jepum_code, P.hyeonjang_geori plan_geori, C.chulha_gubun, O.revise_distance
     into #tmp_03
     from yu_chulha_plan P, yu_chulha C left outer join car_correction O
                                                     on O.company_code = @companyCode
                                                    and O.ymd = C.ymd
                                                    and O.nno = C.nno
    where C.ymd = P.ymd 
      and C.chulha_plan_no = P.nno 
      and P.ymd = @ymd 
      and (C.hoecha_chk <> 'N' or C.hoecha_chk is null ) 
      and (C.chulha_gubun = 0 or C.chulha_gubun is null or C.chulha_gubun = 2) 

update #tmp_03 set suryang = 0 where suryang is null 
update #tmp_03 set plan_geori = 0 where plan_geori is null 

select T1.car_code, T1.suryang, T1.chulha_gubun, T1.jepum_code, T1.chulha_plan_no, 
       case when isnull(T2.total_km,0) + isnull(T1.revise_distance,0) <> 0 then isnull(T2.total_km,0) + isnull(T1.revise_distance,0)
            when isnull(T1.plan_geori,0) <> 0 then T1.plan_geori end total_geori 
     into #tmp_04 
     from #tmp_03  T1 left outer join #tmp_02 T2
                                  on T2.InvoiceYmd = T1.ymd 
                                 and T2.InvoiceNo = T1.nno 

update #tmp_04 set total_geori = 0 where total_geori is null 

select car_code, sum(suryang) total_suryang, round(sum(total_geori), 2) total_geori, 
       sum(case when chulha_gubun <> 2 then 1 else 0 end) cnt_chulha, 
       sum(case when chulha_gubun = 2 then 1 else 0 end) cnt_mul 
     into #tmp_05
     from #tmp_04
 group by car_code 

select identity(int , 1, 1) nno, T.*, CA.gas_gubun 
     into #tmp_06 
     from #tmp_05 T left outer join cm_car CA 
                                 on CA.car_code = T.car_code 
 order by CA.gubun, T.car_code 

select @ymd ymd, nno, car_code, total_suryang, total_geori, cnt_chulha, cnt_mul, gas_gubun 
     from #tmp_06

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04
drop table #tmp_05 
drop table #tmp_06
