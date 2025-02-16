declare @CompanyCode varchar(6)
declare @StartYmd varchar(10)
declare @EndYmd varchar(10)

set @CompanyCode = 'RM_177'
set @StartYmd = '2024-06-18'
set @EndYmd = '2024-06-25'

select CompanyCode, InvoiceYmd, InvoiceNo, max(OrderNo) OrderNo
     into #tmp_01
     from Dbser1.RemiconRadio.dbo.Rr_OrderResult
    where CompanyCode = @CompanyCode
      and InvoiceYmd >= @StartYmd
      and InvoiceYmd <= @EndYmd
 group by CompanyCode, InvoiceYmd, InvoiceNo

select R.*
     into #tmp_02
     from #tmp_01 T, Dbser1.RemiconRadio.dbo.Rr_OrderResult R
    where R.CompanyCode = T.CompanyCode
      and R.InvoiceYmd = T.InvoiceYmd
      and R.InvoiceNo = T.InvoiceNo
      and R.OrderNo = T.OrderNo

select C.Ymd, C.Nno, C.Chulha_Plan_No, C.Car_Code, C.Suryang,
       T.OrderNo, 
       convert(varchar(8), T.AcceptOrderTime, 108) StartToHyeonjangTIme,
       convert(varchar(8), T.EnterSiteTIme, 108) ArrivedHyeonjangTime,
       convert(varchar(8), T.ExitSiteTime, 108) StartToFactoryTime,
       convert(varchar(8), T.ArrivedFactoryTime, 108) ArrivedFactoryTime,
       T.ToFactoryDistance, T.ToHyeonjangDistance,
       cast(null as int) TotalDistance,
       cast(null as numeric(9,3)) ConvertToFactoryDistance,
       cast(null as numeric(9,3)) ConvertToHyeonjangDistance,
       cast(null as numeric(9,3)) ConvertTotalDistance,
       ToHyeonjangTIme, ToFactoryTime, cast(null as int) TotalTime, StayedInSiteTIme, 
       cast(null as varchar(8)) ConvertToHyeonjangTIme,
       cast(null as varchar(8)) ConvertToFactoryTime,
       cast(null as varchar(8)) ConvertTotalTime,
       cast(null as varchar(8)) ConvertStayedInSiteTIme,
       convert(varchar(8), T.PumpedTime, 108) PumpedTIme
     into #tmp_03
     from yu_chulha C left outer join #tmp_02 T
                                   on T.CompanyCode = C.company_code 
                                  and T.InvoiceYmd = C.ymd 
                                  and T.Invoiceno = C.nno 
    where C.Company_Code = @CompanyCode
      and C.Ymd >= @StartYmd
      and C.ymd <= @EndYmd

update #tmp_03 set ToFactoryDistance = ToFactoryDistance - ToHyeonjangDistance 
             where ToFactoryDistance is not null 
               and ToFactoryDistance > ToHyeonjangDistance

update #tmp_03 set ToFactoryTime = ToFactoryTime - ToHyeonjangTIme 
             where ToFactoryTime is not null 
               and ToFactoryTime > ToHyeonjangTIme

update #tmp_03 set TotalDistance = isnull(ToFactoryDistance,0) + isnull(ToHyeonjangDistance,0)
update #tmp_03 set ConvertToFactoryDistance = isnull(ToFactoryDistance,0) / 1000.0 
update #tmp_03 set ConvertToHyeonjangDistance = isnull(ToHyeonjangDistance,0) / 1000.0 
update #tmp_03 set ConvertTotalDistance = TotalDistance / 1000 

update #tmp_03 set TotalTime = isnull(ToHyeonjangTIme,0) + isnull(ToFactoryTime,0) + isnull(StayedInSiteTIme,0)
update #tmp_03 set ConvertToHyeonjangTIme = stuff(convert(varchar, dateadd(s, ToHyeonjangTIme, ''), 108), 1, 2, ToHyeonjangTIme / 3600)
update #tmp_03 set ConvertToFactoryTime = stuff(convert(varchar, dateadd(s, ToFactoryTime, ''), 108), 1, 2, ToFactoryTime / 3600)
update #tmp_03 set ConvertTotalTime = stuff(convert(varchar, dateadd(s, TotalTime, ''), 108), 1, 2, TotalTime / 3600)
update #tmp_03 set ConvertStayedInSiteTIme = stuff(convert(varchar, dateadd(s, StayedInSiteTIme, ''), 108), 1, 2, StayedInSiteTIme / 3600)

update #tmp_03 set ConvertToHyeonjangTIme = '0' + ConvertToHyeonjangTIme where len(ConvertToHyeonjangTIme) = 7
update #tmp_03 set ConvertToFactoryTime = '0' + ConvertToFactoryTime where len(ConvertToFactoryTime) = 7
update #tmp_03 set ConvertTotalTime = '0' + ConvertTotalTime where len(ConvertTotalTime) = 7
update #tmp_03 set ConvertStayedInSiteTIme = '0' + ConvertStayedInSiteTIme where len(ConvertStayedInSiteTIme) = 7

-- insert into Yu_Driving_Result (Ymd, Nno, OrderNo, Chulha_Plan_No, Car_Code, StartToHyeonjangTime, ArrivedHyeonjangTime, StartToFactoryTime, ArrivedFactoryTime, TotalDistance, PumpedTime, StayedInSiteTIme, TotalTime)
-- select Ymd, Nno, OrderNo, Chulha_Plan_No, Car_Code, StartToHyeonjangTime, ArrivedHyeonjangTime, StartToFactoryTime, ArrivedFactoryTime, ConvertTotalDistance, PumpedTime, ConvertStayedInSiteTIme, ConvertTotalTime 
select *
     from #tmp_03

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03


/*

Yu_Driving_Result (차량 운행 결과 조회)

[Ymd] 			smalldatatime
[Nno] 			int
[OrderNo] 		int
Chulha_Plan_No		int
StartToHyeonjangTime	varchar(8)
ArrivedHyeonjangTime	varchar(8)
StartToFactoryTime	varchar(8)
ArrivedFactoryTime	varchar(8)
TotalDistance		numeric(9,3) / ConvertTotalDistance
ReviceDistance		numeric(9,3)
PumpedTime		varchar(8)   / 타설시간
StayedInSiteTIme	varchar(8)   / ConvertStayedInSiteTIme
TotalTime		varchar(8)   / ConvertTotalTime
EditedYmd		datetime
Published		bit	/ 0:기본값


                   공장에서현장으로    현장에서공장으로
일자 / 차량번호 / 출발시간|도착시간 / 출발시간|도착시간 / 운행거리|[보정거리] / 합산거리 / 타설시간 / 현장잔류시간 / [운행시간] / 출하량 / 현장명 / 게시여부

*/

