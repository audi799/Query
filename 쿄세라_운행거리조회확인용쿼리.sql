declare @CompanyCode varchar(6)
declare @Ymd varchar(10)
declare @CarCode varchar(4)
declare @DeviceId int

set @CompanyCode = 'RM_B02'
set @Ymd = '2023-02-16'
set @CarCode = '5379'
set @DeviceId = (select DeviceId
                      from dbser1.RemiconRadio.dbo.Rr_OrderResult
                     where CompanyCode = @CompanyCode
                       and InvoiceYmd = @Ymd
                       and InvoiceCarCode = @CarCode
                  group by DeviceId)

-- DeviceId ��俩�� Ȯ��
select C.car_code, C.car_no, C.gisa_name, C.gisa_tel, C.DeviceId, C.gubun, G.gubun_name
     from cm_car C left outer join cm_car_gubun G
                                on G.car_gubun = C.gubun
    where C.car_code = @CarCode

-- ���Ͽ� �켼������ڷ� �񱳴���
select *
     from yu_chulha
    where ymd = @Ymd
      and car_code = @CarCode

select *
     from dbser1.RemiconRadio.dbo.Rr_OrderResult
    where CompanyCode = @CompanyCode
      and invoiceYmd = @Ymd
      and invoiceCarCode = @CarCode

-- �ش�ð��뿡 �̺�Ʈ �α� Ȯ��
select *
     from dbser1.RemiconRadio.dbo.Rr_Event
    where CompanyCode = @CompanyCode
      and deviceId = @DeviceId
      and issueTime >= @ymd + ' 00:00:00'
      and issueTime <= @ymd + ' 23:59:59'
order by issueTime 