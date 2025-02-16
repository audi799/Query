/*
declare @ymd varchar(10)

set @ymd = '2020-02-27'

select C.Ymd, C.Nno, C.Chulha_Plan_No, C.Car_Code, C.Car_No, C.Suryang, C.Sigan, C.Sangpum_Gubun, C.Hoecha_Chk, C.Magam_Chk, C.Print_Ymd,
       C.Dochak_Ymd, C.Bigo,
       P.cust_code vt_cust_code, CC.sangho vt_sangho
     from yu_chulha C left outer join yu_chulha_plan P
                                   on P.ymd = C.ymd
                                  and P.nno = C.chulha_plan_no
                      left outer join cm_cust CC
                                   on CC.cust_code = P.cust_code
    where C.ymd = @ymd
*/

declare @ymd varchar(10)

set @ymd = '2020-02-27'

select JP.Ymd, JP.Nno, JP.Chulha_Plan_No, JP.Chulha_Plan_Sno, JP.Suryang, JP.Bigo,
       PJ.pummok_code vt_pummok_code, PJ.jepum_code vt_jepum_code,
       G.gubun_name vt_gubun_name,
       J.jepum_yakeo vt_jepum_yakeo
     from yu_chulha_jp JP left outer join yu_chulha_plan_jp PJ
                                       on PJ.ymd = JP.ymd
                                      and PJ.nno = JP.chulha_plan_no
                                      and PJ.sno = JP.chulha_plan_sno
                          left outer join cm_pummok K
                                       on K.pummok_code = PJ.pummok_code
                          left outer join cm_pummok_gubun G
                                       on G.pummok_gubun = K.pummok_gubun
                          left outer join cm_jepum J
                                       on J.pummok_code = PJ.pummok_code
                                      and J.jepum_code = PJ.jepum_code
    where JP.ymd = @ymd

