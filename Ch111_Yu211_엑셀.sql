declare @ymd varchar(10)
declare @custCode varchar(5)

set @ymd = '2020-03-06'
set @custCode = '10001'

select C.sangho, C.sangho_yakeo, C.juso, JP.suryang,
       case when isnull(C.tel,'') <> '' then C.tel else C.tel_1 end tel,
       G.gubun_name, J.jepum_name, J.jepum_yakeo
     from yu_chulha_plan P left outer join yu_chulha_plan_jp PP 
                                        on PP.ymd = P.ymd
                                       and PP.nno = P.nno
                           left outer join yu_chulha_jp JP
                                        on JP.ymd = PP.ymd
                                       and JP.chulha_plan_no = PP.nno
                                       and JP.chulha_plan_sno = PP.sno
                           left outer join cm_cust C
                                        on C.cust_code = P.cust_code
                           left outer join cm_pummok K
                                        on K.pummok_code = PP.pummok_code
                           left outer join cm_jepum J
                                        on J.pummok_code = PP.pummok_code
                                       and J.jepum_code = PP.jepum_code
                           left outer join cm_pummok_gubun G
                                        on G.pummok_gubun = K.pummok_gubun
                                            
   where PP.ymd = @ymd
     and P.cust_code = @custCode
