declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)
declare @jajaeCode varchar(5)
declare @Danga int
declare @changeDanga int

set @ymd_1 = '2019-01-01'
set @ymd_2 = '2019-10-08'
set @jajaeCode = '101'
--set @danga = 58000
set @changeDanga = 58000

select M.*,
       J.maeip_danwi vt_maeip_danwi, J.sosujeom vt_sosujeom,
       C.vat_gubun vt_custvat, CA.jeongsan_gubun vt_jeongsangubun
     into #tmp_01
     from jj_maeip M left outer join jj_jajae J
                                  on J.jajae_code = M.jajae_code
                     left outer join cm_cust C
                                  on C.cust_code = M.maeip_cust
                     left outer join jj_car CA
                                  on CA.car_code = M.car_code
    where M.ymd >= @ymd_1
      and M.ymd <= @ymd_2
      and M.jajae_code = @jajaeCode
--      and M.maeip_danga = @danga

update #tmp_01 set maeip_danga = @changeDanga
update #tmp_01 set maeip_hapgye = round(maeip_suryang * maeip_danga * 1.1, 0) where vt_custVat = 1
update #tmp_01 set maeip_hapgye = round(maeip_suryang * maeip_danga, 0) where vt_custVat <> 1
update #tmp_01 set maeip_geumaek = round(maeip_hapgye / 1.1, 0)
update #tmp_01 set maeip_seaek = maeip_hapgye - maeip_geumaek

update jj_maeip set maeip_danga = T.maeip_danga, maeip_geumaek = T.maeip_geumaek, maeip_seaek = T.maeip_seaek, maeip_hapgye = T.maeip_hapgye
     from jj_maeip P, #tmp_01 T
    where P.ymd = T.ymd
      and P.nno = T.nno

drop table #tmp_01


select *
     from jj_maeip
    where jajae_code = '101'
      and ymd >= '2019-01-23'
      and ymd <= '2019-05-17'