select P.*, 
       C.sangho vt_sangho, C.sangho_yakeo vt_sangho_yakeo,
       C.georae_gubun vt_georae_gubun, C.gyeoljae_jogeon vt_gyeoljae_jogeon, C.danga_policy vt_danga_policy,
       C.danga_year vt_danga_year, C.danga_beonho vt_danga_beonho, C.danga_yul vt_danga_yul, C.danga_mark vt_danga_mark,
       C.danga_round vt_danga_round, C.vat_gubun vt_vat
     from yu_chulha_plan P left outer join cm_cust C
                                        on C.cust_code = P.cust_code




select JP.*,
       J.jepum_name vt_jepum_name, J.Jepum_yakeo vt_jepum_yakeo, J.jepum_type vt_jepum_type, J.danwi vt_danwi,
       PM.Pummok_name vt_pummok_name, G.gubun_name vt_gubun_name
     from yu_chulha_plan_jp JP left outer join cm_jepum J
                                            on J.pummok_code = JP.pummok_code
                                           and J.jepum_code = JP.jepum_code
                               left outer join cm_pummok PM
                                            on PM.pummok_code = JP.pummok_code
                               left outer join cm_pummok_gubun G
                                            on G.pummok_gubun = PM.pummok_gubun


