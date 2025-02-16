declare @ymd varchar(10) 

set @ymd = '2020-10-19' 

select P.ymd, P.nno, JP.sno, P.company_code, P.unban_gubun, P.cust_code, JP.pummok_code, JP.jepum_code, JP.danga, JP.chulha_gubun, JP.suryang plan_suryang, 
       sum(CP.suryang) suryang, JP.geumaek, JP.seaek, JP.hapgye_geumaek, CC.vat_gubun, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, CG.gubun_name chulha_gubun_name, CM.sangho company_name 
     from yu_chulha C, yu_chulha_jp CP left outer join yu_chulha_plan P
                                                    on P.ymd = CP.ymd
                                                   and P.nno = CP.chulha_plan_no
                                       left outer join yu_chulha_plan_jp JP
                                                    on JP.ymd = CP.ymd
                                                   and JP.nno = CP.chulha_plan_no
                                                   and JP.sno = CP.chulha_plan_sno
                                       left outer join cm_cust CC 
                                                    on CC.cust_code = P.cust_code 
                                       left outer join cm_pummok K 
                                                    on K.pummok_code = JP.pummok_code 
                                       left outer join cm_pummok_gubun G 
                                                    on G.pummok_gubun = K.pummok_gubun 
                                       left outer join cm_jepum J 
                                                    on J.pummok_code = JP.pummok_code 
                                                   and J.jepum_code = JP.jepum_code 
                                       left outer join cm_chulha_gubun CG 
                                                    on CG.chulha_gubun = JP.chulha_gubun 
                                       left outer join cm_company CM 
                                                    on CM.company_code = P.company_code 
    where C.ymd = CP.ymd
      and C.nno = CP.nno
      and CP.ymd = @ymd
      and isnull(C.hoecha_chk,'') = '' 
 group by P.ymd, P.nno, JP.sno, P.company_code, P.unban_gubun, P.cust_code, JP.pummok_code, JP.jepum_code, JP.danga, JP.chulha_gubun, JP.suryang, JP.geumaek, JP.seaek, JP.hapgye_geumaek, 
          CC.vat_gubun, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, CG.gubun_name, CM.sangho 


select P.ymd, P.nno, JP.sno, P.company_code, P.unban_gubun, P.cust_code, JP.pummok_code, JP.jepum_code, JP.danga, JP.chulha_gubun, JP.suryang plan_suryang, 
       sum(CP.suryang) suryang, JP.geumaek, JP.seaek, JP.hapgye_geumaek, CC.vat_gubun, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, CG.gubun_name chulha_gubun_name, CM.sangho company_name 
     into #tmp_01 
     from yu_chulha_plan P left outer join yu_chulha_plan_jp JP 
                                        on JP.ymd = P.ymd 
                                       and JP.nno = P.nno 
                           left outer join yu_chulha C 
                                        on C.ymd = P.ymd 
                                       and C.chulha_plan_no = P.nno 
                           left outer join yu_chulha_jp CP 
                                        on CP.ymd = P.ymd 
                                       and CP.chulha_plan_no = JP.nno 
                                       and CP.chulha_plan_sno = JP.sno 
                           left outer join cm_cust CC 
                                        on CC.cust_code = P.cust_code 
                           left outer join cm_pummok K 
                                        on K.pummok_code = JP.pummok_code 
                           left outer join cm_pummok_gubun G 
                                        on G.pummok_gubun = K.pummok_gubun 
                           left outer join cm_jepum J 
                                        on J.pummok_code = JP.pummok_code 
                                       and J.jepum_code = JP.jepum_code 
                           left outer join cm_chulha_gubun CG 
                                        on CG.chulha_gubun = JP.chulha_gubun 
                           left outer join cm_company CM 
                                        on CM.company_code = P.company_code 
    where P.ymd = @ymd 
      and isnull(C.hoecha_chk,'') = '' 
 group by P.ymd, P.nno, JP.sno, P.company_code, P.unban_gubun, P.cust_code, JP.pummok_code, JP.jepum_code, JP.danga, JP.chulha_gubun, JP.suryang, JP.geumaek, JP.seaek, JP.hapgye_geumaek, 
          CC.vat_gubun, CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo, CG.gubun_name, CM.sangho 

update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga * 1.1) where isnull(plan_suryang,0) <> isnull(suryang,0) and vat_gubun = 1 
update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga) where isnull(plan_suryang,0) <> isnull(suryang,0) and vat_gubun = 2 
update #tmp_01 set geumaek = ceiling(hapgye_geumaek / 1.1) where isnull(plan_suryang,0) <> isnull(suryang,0) 
update #tmp_01 set seaek = hapgye_geumaek - geumaek where isnull(plan_suryang,0) <> isnull(suryang,0) 

select * 
     from #tmp_01 
 order by ymd, nno, sno 

drop table #tmp_01 