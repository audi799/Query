declare @startProgYmd varchar(10), @ymd_1 varchar(10), @ymd_2 varchar(10), @custCode_1 varchar(5), @custCode_2 varchar(5)

set @startProgYmd = '2014-01-01'
set @custCode_1 = '10001'
set @custCode_2 = '90001'
set @ymd_1 = '2020-02-28'
set @ymd_2 = '2020-12-31'


declare @startYearYmd varchar(10)
set @startYearYmd = substring(@ymd_1, 1,4) + '-01-01'

select cust_code, sum(geumaek) sisan
     into #tmp_01
     from yu_sisan
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and year = substring(@startYearYmd, 1,4)
 group by cust_code

select cust_code, sum(hapgye_geumaek) j_panmae
     into #tmp_02
     from yu_panmae 
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and ymd >= @startProgYmd
      and ymd >= @startYearYmd
      and ymd < @ymd_1
 group by cust_code

select cust_code, sum(isnull(geumaek, 0) + isnull(halin_geumaek,0) - isnull(japiik,0)) j_ipgeum
     into #tmp_03
     from yu_ipgeum
    where cust_code >= @custCode_1
      and cust_code <= @custCode_2
      and ymd >= @startProgYmd
      and ymd >= @startYearYmd
      and ymd < @ymd_1
 group by cust_code

select cust_code into #tmp_04 from #tmp_01 union
select cust_code              from #tmp_02 union
select cust_code              from #tmp_03

select T.cust_code, (isnull(T1.sisan,0) + isnull(T2.j_panmae,0) - isnull(T3.j_ipgeum, 0)) misu
    into #tmp_05
    from #tmp_04 T left outer join #tmp_01 T1
                                on T1.cust_code = T.cust_code
                   left outer join #tmp_02 T2
                                on T2.cust_code = T.cust_code
                   left outer join #tmp_03 T3
                                on T3.cust_code = T.cust_code

select cust_code, cast('iwol' as varchar(7)) ym, cast(null as smalldatetime) ymd, 
       cast(0 as tinyint) sortGubun1, 
       cast(null as varchar(4)) pummok_code, cast(null as varchar(100)) vt_pummok_name,
       cast(null as int) jepum_code, cast('이월 금액' as varchar(50)) vt_jepum_yakeo,
       cast(0 as numeric(9,3)) suryang, cast(null as varchar(10)) vt_danwi, cast(0 as int) danga,
       cast(0 as numeric(18,0)) geumaek, cast(0 as numeric(18,0)) seaek, cast(0 as numeric(18,0)) hapgye_geumaek, 
       cast(0 as numeric(18,0)) ipgeum, misu, 
       cast(null as varchar(10)) bigo,
       cast(null as varchar(50)) vt_gubun_name
     into #tmp_06 
     from #tmp_05

select P.cust_code, convert(varchar(7), P.ymd, 120) ym, P.ymd, 
       cast(1 as tinyint) sortGubun1, 
       P.pummok_code, K.pummok_name vt_pummok_name, 
       P.jepum_code, J.jepum_yakeo vt_jepum_yakeo, 
       P.suryang, J.danwi vt_danwi, P.danga, 
       P.geumaek, P.seaek, P.hapgye_geumaek, 
       cast(0 as numeric(18,0)) ipgeum, cast(0 as numeric(18,0)) misu,
       case when P.sangpum_gubun = 2 then cast('상품' as varchar(10)) else cast(null as varchar(10)) end bigo,
       G.gubun_name vt_gubun_name
     into #tmp_07
     from yu_panmae P left outer join cm_pummok K
                                   on K.pummok_code = P.pummok_code
                      left outer join cm_pummok_gubun G
                                   on G.pummok_gubun = K.pummok_gubun
                      left outer join cm_jepum J
                                   on J.pummok_code = P.pummok_code
                                  and J.jepum_code = P.jepum_code
    where P.cust_code >= @custCode_1
      and P.cust_code <= @custCode_2
      and P.ymd >= @startProgYmd
      and P.ymd >= @ymd_1
      and P.ymd <= @ymd_2

select I.cust_code, convert(varchar(7), I.ymd, 120) ym, I.ymd,
       cast(1 as tinyint) sortGubun1, 
       cast(null as varchar(4)) pummok_code, cast('수금' as varchar(100)) vt_pummok_name,
       cast(null as int) jepum_code, G.ipgeum_name vt_jepum_yakeo,
       cast(0 as numeric(9,3)) suryang, cast(null as varchar(10)) vt_danwi, cast(0 as int) danga,
       cast(0 as numeric(18,0)) geumaek, cast(0 as numeric(18,0)) seaek, cast(0 as numeric(18,0)) hapgye_geumaek, 
       isnull(I.geumaek,0) + isnull(I.halin_geumaek,0) - isnull(japiik,0) ipgeum, cast(0 as numeric(18,0)) misu,     
       cast(null as varchar(10)) bigo,
       cast(null as varchar(50)) vt_gubun_name
     into #tmp_08
     from yu_ipgeum I left outer join cm_ipgeum_gubun G
                                   on G.ipgeum_gubun = I.ipgeum_gubun
    where I.cust_code >= @custCode_1
      and I.cust_code <= @custCode_2
      and I.ymd >= @startProgYmd
      and I.ymd >= @ymd_1
      and I.ymd <= @ymd_2

select * into #tmp_09 from #tmp_06 union all
select *              from #tmp_07 union all
select *              from #tmp_08 

select identity(int, 1, 1) as sno, *
     into #tmp_10
     from #tmp_09 
 order by cust_code, ymd, sortGubun1

update #tmp_10 set misu = (select sum(T10.misu + T10.hapgye_geumaek - T10.ipgeum) 
                                from #tmp_10 T10
                               where T10.cust_code = #tmp_10.cust_code
                                 and T10.sno <= #tmp_10.sno)

select cust_code, min(ym) chkym
     into #tmp_11
     from #tmp_10
    where ym <> 'iwol'
 group by cust_code

update #tmp_10 set ym = T11.chkym
    from #tmp_10 T10, #tmp_11 T11
   where T11.cust_code = T10.cust_code
     and T10.ym = 'iwol'

select cust_code, ym, ymd, sortGubun1, cast(convert(varchar(10), ymd, 120) as varchar(20)) strYmd,
       pummok_code, vt_pummok_name, jepum_code, vt_jepum_yakeo, 
       suryang, vt_danwi, danga,
       geumaek, seaek, hapgye_geumaek,
       ipgeum, misu, bigo, vt_gubun_name, cast(0 as tinyint) LineDis
     into #tmp_12
     from #tmp_10

select cust_code, ym, ymd, cast(3 as tinyint) sortGubun1, cast('[**일 계**]' as varchar(20)) strYmd,
       cast(null as varchar(4)) pummok_code, cast(null as varchar(100)) vt_pummok_name,
       cast(null as int) jepum_code, cast(null as varchar(50)) vt_jepum_yakeo, 
       sum(suryang) suryang, cast(null as varchar(10)) vt_danwi, cast(0 as int) danga,      
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       sum(ipgeum) ipgeum, cast(null as numeric(18,0)) misu, cast(null as varchar(10)) bigo, cast(null as varchar(50)) vt_gubun_name, cast(1 as tinyint) LineDis
     into #tmp_13
     from #tmp_12
 group by cust_code, ym, ymd

select cust_code, ym, max(ymd) ymd, cast(4 as tinyint) sortGubun1, cast('[**월 계**]' as varchar(20)) strYmd,
       cast(null as varchar(4)) pummok_code, cast(null as varchar(100)) vt_pummok_name,
       cast(null as int) jepum_code, cast(null as varchar(50)) vt_jepum_yakeo, 
       sum(suryang) suryang, cast(null as varchar(10)) vt_danwi, cast(0 as int) danga,      
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       sum(ipgeum) ipgeum, cast(null as numeric(18,0)) misu, cast(null as varchar(10)) bigo, cast(null as varchar(50)) vt_gubun_name, cast(1 as tinyint) LineDis
     into #tmp_14
     from #tmp_13
 group by cust_code, ym

select cust_code, max(ym) ym, max(ymd) ymd, cast(5 as tinyint) sortGubun1, cast('[**누 계**]' as varchar(20)) strYmd,
       cast(null as varchar(4)) pummok_code, cast(null as varchar(100)) vt_pummok_name,
       cast(null as int) jepum_code, cast(null as varchar(50)) vt_jepum_yakeo, 
       sum(suryang) suryang, cast(null as varchar(10)) vt_danwi, cast(0 as int) danga,      
       sum(geumaek) geumaek, sum(seaek) seaek, sum(hapgye_geumaek) hapgye_geumaek,
       sum(ipgeum) ipgeum, cast(null as numeric(18,0)) misu, cast(null as varchar(10)) bigo, cast(null as varchar(50)) vt_gubun_name, cast(1 as tinyint) LineDis
     into #tmp_15
     from #tmp_14
 group by cust_code

select * into #tmp_16 from #tmp_12 union all
select *              from #tmp_13 union all
select *              from #tmp_14 union all
select *              from #tmp_15

select *
     from #tmp_16
 order by cust_code, ymd, sortGubun1

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06
drop table #tmp_07
drop table #tmp_08
drop table #tmp_09
drop table #tmp_10
drop table #tmp_11
drop table #tmp_12
drop table #tmp_13
drop table #tmp_14
drop table #tmp_15
drop table #tmp_16
