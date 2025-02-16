/*

select J.*,
       C.sangho vt_sangbo
     from yu_jumun J left outer join cm_cust C
                                  on C.cust_code = J.cust_code

*/

select JP.*,
       C.sangho vt_sangho, K.pummok_name vt_pummok_name,
       G.gubun_name, J.jepum_yakeo
     from yu_jumun_jp JP left outer join cm_cust C
                                      on C.cust_code = JP.cust_code
                         left outer join cm_pummok K
                                      on K.pummok_code = JP.pummok_code
                         left outer join cm_pummok_gubun G
                                      on G.pummok_gubun = K.pummok_gubun
                         left outer join cm_jepum J
                                      on J.pummok_code = JP.pummok_code
                                     and J.jepum_code = JP.jepum_code

