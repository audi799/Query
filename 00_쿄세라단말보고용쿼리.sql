use MGM

declare @applyYmd varchar(10)

set @applyYmd = '2023-10-01' -- 이하아님 미만임..! 즉, 2023-09-01 이전인 8월말까지!!

select *
     into #tmp_01
     from gps_cust_list
    where model_telecom = 'Kyocera Radio'

select T.cust_code, P.maeip_cust, P.maeip_gubun, sum(P.suryang) suryang, P.maechul_danga, P.vat_gubun,
       cast(null as varchar(10)) vat_gubun_name,
       cast(0 as int) geumaek, cast(0 as int) seaek, cast(0 as int) hapgye
     into #tmp_02
     from #tmp_01 T left outer join gps_cust_list_jp P
                                 on P.cust_code = T.cust_code
    where P.maeip_cust = 'CM_085'
      and P.maeip_gubun = 2
      and gyesan_ymd < @applyYmd
 group by T.cust_code, P.maeip_cust, P.maeip_gubun, P.maechul_danga, P.vat_gubun

update #tmp_02 set vat_gubun_name = '별도' where vat_gubun = 1
update #tmp_02 set vat_gubun_name = '포함' where vat_gubun = 2

--부가세별도
update #tmp_02 set geumaek = isnull(suryang,0) * isnull(maechul_danga,0) where vat_gubun = 1
update #tmp_02 set seaek = geumaek * 0.1 where vat_gubun = 1
update #tmp_02 set hapgye = geumaek + seaek where vat_gubun = 1

--부가세포함
update #tmp_02 set hapgye = isnull(suryang,0) * isnull(maechul_danga,0) where vat_gubun = 2
update #tmp_02 set geumaek = hapgye / 1.1 where vat_gubun = 2
update #tmp_02 set seaek = hapgye - geumaek where vat_gubun = 2

select 1 sortGubun, C.sangho, CU.sangho as maeip_sangho, T.*
     into #tmp_03
     from #tmp_02 T left outer join johap_db.gimaek.dbo.cm_cust C
                                 on C.cust_code = T.cust_code
                    left outer join johap_db.gimaek.dbo.cm_cust CU
                                 on CU.cust_code = T.maeip_cust

select 2 sortGubun, cast('[단가별소계]' as varchar(100)) sangho, cast(null as varchar(100)) maeip_sangho,
       cast(null as varchar(5)) cust_code, cast(null as varchar(5)) maeip_cust, cast(null as int) maeip_gubun,
       sum(suryang) suryang, maechul_danga, cast(null as int) vat_gubun, cast(null as varchar(4)) vat_gubun_name,
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye) hapgye
     into #tmp_04
     from #tmp_03
  group by maechul_danga

select 3 sortGubun, cast('[총계]' as varchar(100)) sangho, cast(null as varchar(100)) maeip_sangho,
       cast(null as varchar(5)) cust_code, cast(null as varchar(5)) maeip_cust, cast(null as int) maeip_gubun,
       sum(suryang) suryang, cast(null as int) maechul_danga, cast(null as int) vat_gubun, cast(null as varchar(4)) vat_gubun_name,
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye) hapgye
     into #tmp_05
     from #tmp_03

select * into #tmp_06 from #tmp_03 union all
select *              from #tmp_04 union all
select *              from #tmp_05 

select identity(int, 1, 1) nno, *
     into #tmp_07
     from #tmp_06
 order by sortGubun, cust_code

update #tmp_07 set cust_code = '' where cust_code is null
update #tmp_07 set vat_gubun_name = '' where vat_gubun_name is null

-- select *
select nno, cust_code, sangho, suryang, isnull(cast(maechul_danga as varchar(10)),'') maechul_danga, vat_gubun_name, geumaek, seaek, hapgye
     from #tmp_07
 order by nno

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07


