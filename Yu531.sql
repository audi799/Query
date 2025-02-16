declare @ymd_1 varchar(10), @ymd_2 varchar(10), @custCode varchar(5), @hyeonjangCode varchar(5)

set @ymd_1 = '2014-06-01'
set @ymd_2 = '2020-06-25'

select cast(1 as tinyint) sortGubun1, cast(1 as tinyint) sortGubun2, 
       cast(convert(varchar(10), I.ymd, 120) as varchar(20)) strYmd, 
       I.Ymd, I.Cust_Code, C.sangho vt_Sangho,
       I.Ipgeum_Gubun, G.Ipgeum_name vt_Ipgeum_Name,
       sum(I.geumaek) Geumaek, sum(I.halin_geumaek) Halin_Geumaek, sum(I.japiik) Japiik, 
       sum(isnull(I.geumaek,0) + isnull(I.halin_geumaek,0) + isnull(japiik,0)) Ipgeum,
       Bill_No, cast(0 as tinyint) lineDis 
     into #tmp_01 
     from yu_ipgeum I left outer join cm_cust C
                                   on C.cust_code = I.cust_code
                      left outer join cm_ipgeum_gubun G
                                   on G.ipgeum_gubun = I.ipgeum_gubun
    where I.ymd >= @ymd_1
      and I.ymd <= @ymd_2
 group by I.ymd, I.cust_code, C.sangho, I.ipgeum_gubun, G.ipgeum_name, bill_no 

select cast(1 as tinyint) sortGubun1, cast(2 as tinyint) sortGubun2, 
       cast(convert(varchar(10), ymd, 120) as varchar(20)) strYmd, 
       ymd, cast(null as varchar(5)) cust_code, cast('[ ÇÕ  °è ]' as varchar(70)) vt_sangho, 
       cast(null as smallint) ipgeum_gubun, cast(null as varchar(20)) vt_ipgeum_name, 
       sum(geumaek) geumaek, sum(halin_geumaek) halin_geumaek, sum(japiik) japiik, 
       sum(ipgeum) ipgeum, 
       cast(null as varchar(50)) bill_no, cast(1 as tinyint) lineDis 
     into #tmp_02 
     from #tmp_01 
 group by ymd 

select * into #tmp_03 from #tmp_01 union all 
select *              from #tmp_02 

select *
from #tmp_03
order by sortGubun1, ymd, sortGubun2 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
