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

--//���������״�� ���ϵǸ�, ���Ͽ�����Ͽ��� ����� �ݾ�,����,�հ�ݾ� �״�� ������. ����: �հ�ݾ��� ������ �����ϴ°�� �����Ͱ��� ����.
--//������������ �� ���ų� �� ���� ���ϵǸ�, �ŷ�ó����� �ΰ������п� ���� �ڿ˰���Ͽ� �ݾ�ǥ����.
--//�������ǥ���ʵ� : �ŷ�ó��, ���и�, ǰ���, ��ǰ��, ����, �ܰ�, �ݾ�, ����, �հ�ݾ�
--//�̷��� ���·� ����ɰ��, ���ϸ���(Yu231)�� ���ĵ� �Ʒ�����ó�� �����ؾ���

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