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
drop table #tmp_02 -- 출하횟수, 물차횟수, 출하수량
drop table #tmp_03 -- 현장거리, 총횟수
drop table #tmp_04 -- nno 만들어냄
drop table #tmp_05

-- yu_unbanbi_naeyeok (필요한 필드내역)
-- 주유소구분(아시아, 명당, 현대, 자가)   - 라디오버튼
-- 유종구분  (등유, 경유, 휘발유)         - 라디오버튼
-- 주유량    (리터)                       - DBEdit (입력필드)
-- 일대비필드(금액)                       - DBEdit (입력필드)
-- 통행료필드(금액)                       - DBEdit (입력필드)
-- OT/철야필드(금액)                      - DBEdit (입력필드)
-- 지원필드(금액)                         - DBEdit (입력필드)
-- 지원회전(횟수)                         - DBEdit (입력필드)
-- 유류현금지급(금액)                     - DBEdit (입력필드)
-- 운송거리(km)                           - DBEdit (계산입력필드)
-- 운송횟수(출하횟수)                     - DBEdit (계산입력필드)
-- 운송횟수(물차횟수)                     - DBEdit (계산입력필드)
-- 출하수량(수량)                         - DBEdit (계산입력필드)

-- 유류환산(금액)                         - DBEdit (계산입력필드) -- * 리포트에서 계산해야할항목

-- cm_unbanbi_jogeon
--  - 회전당단가
--  - 보장회전수
--  - 경유단가

/*

*계산식
  - 유류환산             : (운행키로수 * 0.6) + 20 - 주유량 - 보관/현금정산 // 버림처리
  - 유류환산(부가세포함) : IF 주유량 > 0 THEN 0 
                                         ELSE 유류환산 * 1200

  - 일대차운반비         : 일대비 + 철야/OT
  - 지입차운반비         : IF(운송횟수 < 기본보장(80회전) THEN 1회전(45,000원) * 기본보장(80회전) 
                                                          ELSE 1회전(45,000원) * 운송횟수

* 필요항목들
  - 레미콘 운송비 내역
  - 지입차량집계표
  - 일대차량집계표
  - 일자별 일대차량 운송 내역
  - 일자별 지입차량 운송 내역
  - 유류 집계표 (경유, 휘발유, 등유)
  - 일자별 유류 사용내역

*/


-- cm_unbanbi_jogeon
--  - 회전당단가
--  - 보장회전수
--  - 경유단가