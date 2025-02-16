declare @ymd varchar(10)

set @ymd = '2020-02-28'

select P.ymd, C.nno, P.cust_code, C.car_code, C.car_no, C.suryang, C.sigan,
       CC.sangho, C.magam_chk
     from yu_chulha_plan P left outer join yu_chulha C
                                        on C.ymd = P.ymd 
                                       and C.chulha_plan_no = P.nno
                           left outer join cm_cust CC
                                        on CC.cust_code = P.cust_code
   where P.ymd = @ymd

