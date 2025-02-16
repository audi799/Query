declare @ymd varchar(10)
declare @chulhaPlanNo tinyint

set @ymd = '2020-03-11'
set @chulhaPlanNo = 1

select P.cust_code, PP.pummok_code, PP.jepum_code, PP.suryang plan_suryang, JP.suryang chulha_suryang, PP.danga, PP.geumaek, PP.seaek, PP.hapgye_geumaek,
       CC.vat_gubun, CC.sangho, K.pummok_gubun, K.pummok_name, G.gubun_name, J.jepum_yakeo
     into #tmp_01
     from yu_chulha C left outer join yu_chulha_plan P
                                   on P.ymd = C.ymd
                                  and P.nno = C.chulha_plan_no
                      left outer join yu_chulha_plan_jp PP
                                   on PP.ymd = C.ymd
                                  and PP.nno = C.chulha_plan_no
                      left outer join yu_chulha_jp JP
                                   on JP.ymd = PP.ymd
                                  and JP.chulha_plan_no = PP.nno
                                  and JP.chulha_plan_sno = PP.sno
                      left outer join cm_cust CC
                                   on CC.cust_code = P.cust_code
                      left outer join cm_pummok K
                                   on K.pummok_code = PP.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = PP.pummok_code
                                  and J.jepum_code = PP.jepum_code
    where C.ymd = @ymd
      and C.chulha_plan_no = @chulhaPlanNo

--//예정수량그대로 출하되면, 출하예정등록에서 등록한 금액,세액,합계금액 그대로 가져옴. 사유: 합계금액을 강제로 조정하는경우 있을것같기 때문.
--//예정수량보다 더 많거나 더 적게 출하되면, 거래처등록의 부가세구분에 따라서 자옹계산하여 금액표현함.
--//예상송장표시필드 : 거래처명, 구분명, 품목명, 제품명, 수량, 단가, 금액, 세액, 합계금액
--//이러한 형태로 진행될경우, 출하마감(Yu231)의 계산식도 아래형태처럼 변경해야함

update #tmp_01 set hapgye_geumaek = ceiling(chulha_suryang * danga * 1.1) 
             where isnull(plan_suryang,0) <> isnull(chulha_suryang,0)
               and vat_gubun = 1

update #tmp_01 set hapgye_geumaek = ceiling(chulha_suryang * danga) 
             where isnull(plan_suryang,0) <> isnull(chulha_suryang,0)
               and vat_gubun = 2

update #tmp_01 set geumaek = ceiling(hapgye_geumaek / 1.1) 
             where isnull(plan_suryang,0) <> isnull(chulha_suryang,0)

update #tmp_01 set seaek = hapgye_geumaek - geumaek
             where isnull(plan_suryang,0) <> isnull(chulha_suryang,0)

select *
     from #tmp_01
 order by pummok_gubun, pummok_code, jepum_code

drop table #tmp_01