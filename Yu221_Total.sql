declare @ymd varchar(10)

set @ymd = '2020-03-09'

select J.jepum_yakeo, sum(JP.suryang) chulha_suryang
     from yu_chulha_plan_jp PP left outer join yu_chulha C
                                            on C.ymd = PP.ymd
                                           and C.chulha_plan_no = PP.nno
                               left outer join yu_chulha_JP JP
                                            on JP.ymd = PP.ymd
                                           and JP.chulha_plan_no = PP.nno
                                           and JP.chulha_plan_sno = PP.sno
                               left outer join cm_jepum J 
                                            on J.pummok_code = PP.pummok_code
                                           and J.jepum_code = PP.jepum_code
    where PP.ymd = @ymd
      and isnull(C.hoecha_chk, '') = ''
 group by J.jepum_yakeo