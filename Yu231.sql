/*
declare @ymd varchar(10)

set @ymd = '2020-02-28'

select P.ymd, P.nno, JP.sno, P.Company_Code, P.unban_gubun, P.cust_code,
       JP.pummok_code, JP.jepum_code, JP.danga,
       sum(CP.suryang) suryang, 
       cast(null as numeric(18,0)) geumaek, cast(null as numeric(9,0)) seaek, cast(null as numeric(9,0)) hapgye_geumaek,
       CC.vat_gubun, CC.sangho, 
       K.pummok_name,
       G.gubun_name,
       J.jepum_yakeo
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
    where P.ymd = @ymd
      and isnull(C.hoecha_chk,'') = ''
 group by P.ymd, P.nno, JP.sno, P.Company_Code, P.unban_gubun, P.cust_code, JP.pummok_code, JP.jepum_code, JP.danga, CC.vat_gubun, 
          CC.sangho, K.pummok_name, G.gubun_name, J.jepum_yakeo

update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga * 1.1) where vat_gubun = 1
update #tmp_01 set hapgye_geumaek = ceiling(suryang * danga)       where vat_gubun = 2
update #tmp_01 set geumaek        = ceiling(hapgye_geumaek / 1.1)
update #tmp_01 set seaek          = hapgye_geumaek - geumaek

select *
     from #tmp_01
 order by ymd, nno, sno

drop table #tmp_01

*/

declare @ymd varchar(10)

set @ymd = '2020-02-29'

select P.Ymd, P.Nno, P.Company_Code, P.Cust_Code, P.Pummok_Code, P.Jepum_Code, P.Suryang, P.Danga, P.Geumaek, P.Seaek, P.Hapgye_Geumaek, P.Unban_Gubun,
       P.Chulha_Plan_Ymd, P.Chulha_Plan_No, P.Chulha_Plan_Sno, P.Magam_Chk, P.Gyesanseo_Gubun, P.Gyesanseo_Yy, P.Gyesanseo_Mm, P.Gyesanseo_No,
       C.sangho vt_sangho,
       K.pummok_name vt_pummok_name,
       G.gubun_name vt_gubun_name,
       j.jepum_yakeo vt_jepum_yakeo
     from yu_panmae P left outer join cm_cust C
                                   on C.cust_code = P.cust_code
                      left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where ymd = @ymd
