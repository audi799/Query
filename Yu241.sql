declare @ymd varchar(10)

set @ymd = '2020-02-28'

select P.ymd, P.cust_code, PJ.pummok_code, PJ.jepum_code,
       C.car_code, C.car_no, JP.suryang,
       CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo
     from yu_chulha_plan P left outer join yu_chulha_plan_jp PJ
                                        on PJ.ymd = P.ymd
                                       and PJ.nno = P.nno
                           left outer join yu_chulha C
                                        on C.ymd = P.ymd
                                       and C.chulha_plan_no = P.nno
                           left outer join yu_chulha_JP JP
                                        on JP.ymd = PJ.ymd
                                       and JP.chulha_plan_no = PJ.nno
                                       and JP.chulha_plan_sno = PJ.sno
                           left outer join cm_cust CC
                                        on CC.cust_code = P.cust_code
                           left outer join cm_pummok K
                                        on K.pummok_code = PJ.pummok_code
                           left outer join cm_pummok_gubun G
                                        on G.pummoK_gubun = K.pummok_gubun
                           left outer join cm_jepum J
                                        on J.pummok_code = PJ.pummok_code
                                       and J.jepum_code = PJ.jepum_code
    where P.ymd = @ymd
      and isnull(C.hoecha_chk,'') = ''