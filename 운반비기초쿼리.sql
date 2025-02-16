declare @ymd varchar(10)

set @ymd = '2020-05-26'

select car_code, car_no, 
       case when chulha_gubun = 0 then count(*) else 0 end chulha_cnt, 
       case when chulha_gubun = 2 then count(*) else 0 end mul_cnt,
       sum(suryang) chulha_suryang
     into #tmp_01
     from yu_chulha 
    where ymd = @ymd
      and (hoecha_chk is null or hoecha_chk = 'Y')
 group by car_code, car_no, chulha_gubun

select car_code, car_no, 
       sum(chulha_cnt) chulha_cnt, sum(mul_cnt) mul_cnt, sum(chulha_suryang) chulha_suryang
     into #tmp_02
     from #tmp_01
 group by car_code, car_no

select C.car_code, C.car_no,
       sum(P.hyeonjang_geori) hyeonjang_geori, count(*) total_cnt
     into #tmp_03
     from yu_chulha_plan P, yu_chulha C
    where P.ymd = @ymd
      and P.ymd = C.ymd
      and P.nno = C.chulha_plan_no
      and (C.hoecha_chk is null or C.hoecha_chk = 'Y')
 group by C.car_code, C.car_no

select car_code, car_no into #tmp_04 from #tmp_02 union
select car_code, car_no              from #tmp_03

select identity(int, 1, 1) nno, T.car_code, T.car_no,
       T2.chulha_cnt, T2.mul_cnt, T2.chulha_suryang,
       round(T3.hyeonjang_geori, 0) hyeonjang_geori, T3.total_cnt,
       round( isnull(T3.hyeonjang_geori,0) / isnull(T3.total_cnt,0), 0 ) ave_geori,
       C.gubun, C.gisa_name, G.gubun_name
     into #tmp_05
     from #tmp_04 T left outer join #tmp_02 T2
                                 on T2.car_code = T.car_code
                    left outer join #tmp_03 T3
                                 on T3.car_code = T.car_code
                    left outer join cm_car C
                                 on C.car_code = T.car_code
                    left outer join cm_car_gubun G
                                 on G.car_gubun = C.gubun

--insert into yu_unbanbi_naeyeok (ymd, nno, car_code, cnt_chulha, total_geori, total_suryang, cnt_mul, juyuso_gubun, yujong_gubun 
select @ymd ymd, nno, car_code, chulha_cnt, hyeonjang_geori, chulha_suryang, mul_cnt, 4 juyuso_gubun, 2 yujong_gubun
     from #tmp_05

drop table #tmp_01
drop table #tmp_02 -- ����Ƚ��, ����Ƚ��, ���ϼ���
drop table #tmp_03 -- ����Ÿ�, ��Ƚ��
drop table #tmp_04 -- nno ����
drop table #tmp_05

-- yu_unbanbi_naeyeok (�ʿ��� �ʵ峻��)
-- �����ұ���(�ƽþ�, ���, ����, �ڰ�)   - ������ư
-- ��������  (����, ����, �ֹ���)         - ������ư
-- ������    (����)                       - DBEdit (�Է��ʵ�)
-- �ϴ���ʵ�(�ݾ�)                       - DBEdit (�Է��ʵ�)
-- ������ʵ�(�ݾ�)                       - DBEdit (�Է��ʵ�)
-- OT/ö���ʵ�(�ݾ�)                      - DBEdit (�Է��ʵ�)
-- �����ʵ�(�ݾ�)                         - DBEdit (�Է��ʵ�)
-- ����ȸ��(Ƚ��)                         - DBEdit (�Է��ʵ�)
-- ������������(�ݾ�)                     - DBEdit (�Է��ʵ�)
-- ��۰Ÿ�(km)                           - DBEdit (����Է��ʵ�)
-- ���Ƚ��(����Ƚ��)                     - DBEdit (����Է��ʵ�)
-- ���Ƚ��(����Ƚ��)                     - DBEdit (����Է��ʵ�)
-- ���ϼ���(����)                         - DBEdit (����Է��ʵ�)

-- ����ȯ��(�ݾ�)                         - DBEdit (����Է��ʵ�) -- * ����Ʈ���� ����ؾ����׸�

-- cm_unbanbi_jogeon
--  - ȸ����ܰ�
--  - ����ȸ����
--  - �����ܰ�

/*

*����
  - ����ȯ��             : (����Ű�μ� * 0.6) + 20 - ������ - ����/�������� // ����ó��
  - ����ȯ��(�ΰ�������) : IF ������ > 0 THEN 0 
                                         ELSE ����ȯ�� * 1200

  - �ϴ�����ݺ�         : �ϴ�� + ö��/OT
  - ��������ݺ�         : IF(���Ƚ�� < �⺻����(80ȸ��) THEN 1ȸ��(45,000��) * �⺻����(80ȸ��) 
                                                          ELSE 1ȸ��(45,000��) * ���Ƚ��

* �ʿ��׸��
  - ������ ��ۺ� ����
  - ������������ǥ
  - �ϴ���������ǥ
  - ���ں� �ϴ����� ��� ����
  - ���ں� �������� ��� ����
  - ���� ����ǥ (����, �ֹ���, ����)
  - ���ں� ���� ��볻��

*/


-- cm_unbanbi_jogeon
--  - ȸ����ܰ�
--  - ����ȸ����
--  - �����ܰ�