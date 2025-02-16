declare @CompanyCode varchar(6)
declare @CarCode varchar(10)
declare @Ymd varchar(10)
declare @DeviceId int

set @CompanyCode = 'RM_C26'
set @CarCode = '7830'
set @Ymd = getdate()
set @DeviceId = (select CC.deviceId 
                      from yu_chulha C left outer join cm_car CC
                                                    on CC.car_code = C.car_code
                     where C.ymd = @Ymd
                       and C.nno = (select max(nno)
                                       from yu_chulha 
                                      where ymd = @Ymd
                                        and car_code = @CarCode) )

-- �����ڷ� �� GPS��ȣ��ȸ
select C.ymd, C.nno, C.chulha_plan_no, C.car_code, C.car_no, C.chulha_gubun, C.suryang, C.sigan, C.songjang_no,
       CC.sangho, H.hyeonjang_name, J.jepum_name,
       R.OrderNo, R.DeviceId, R.AcceptOrderTime, R.ExitFactoryTime, R.EnterSiteTime, R.ArrivedHyeonjangTIme, R.StartWaitingPumpTime, R.PumpedTIme,
       R.PumpedLat, R.PumpedLng, R.StayedInSiteTime, R.ExitSiteTIme, R.ArrivedFactoryTime, R.ToHyeonjangDistance, R.ToFactoryDistance, R.ToHyeonjangTIme,
       R.ToFactoryTime, R.FinishType, R.FinishTime
     from yu_chulha C left outer join yu_chulha_plan P
                                   on P.ymd = C.ymd
                                  and P.nno = C.chulha_plan_no
                      left outer join cm_cust CC
                                   on CC.cust_code = P.cust_code
                      left outer join cm_hyeonjang H
                                   on H.cust_code = P.cust_code
                                  and H.hyeonjang_code = P.hyeonjang_code
                      left outer join cm_jepum J
                                   on J.jepum_code = P.jepum_code
                      left outer join dbser1.RemiconRadio.dbo.rr_orderResult R
                                   on R.CompanyCode = @CompanyCode
                                  and R.invoiceYmd = C.ymd
                                  and R.invoiceNo = C.nno
    where C.ymd = @Ymd
      and C.car_code = @CarCode
 order by C.nno

--cm_car�� DeviceId ��Ͽ��� ��ȸ
select CA.car_code, CA.car_no, CA.gubun, CA.gisa_tel, CA.gisa_name, CA.unhaeng_yeobu, CA.deviceId, CA.cust_code, CG.gubun_name, C.sangho as unban_sangho
     from cm_car CA left outer join cm_car_gubun CG
                                 on CG.car_gubun = CA.gubun
                    left outer join cm_cust C
                                 on C.cust_code = CA.cust_code
    where CA.car_code = @CarCode

--Rr_Device�� �����ȸ
select *
     from dbser1.RemiconRadio.dbo.rr_device
    where CompanyCode = @CompanyCode
      and CarNo = @CarCode

--Rr_Operation�� �ǽð� �ڷ᰻�� ��ȸ
select *, case when GpsConnected = 0 then 'False' else 'True' end GPS�������
     from dbser1.RemiconRadio.dbo.Rr_Operation
    where CompanyCode = @CompanyCode
      and DeviceId = @DeviceId

/* Rr_Operation - State
STATE_NONE       = 0  (�⺻��)
STATE_IN_FACTORY = 1  (�����)
STATE_TO_SITE    = 2  (������)
STATE_IN_SITE    = 3  (�����)
STATE_TO_FACTORY = 4  (������)
STATE_GPS_ERROR  = -1 (GPS����)
*/
