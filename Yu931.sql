declare @startProgYmd varchar(10) 
declare @yy_1 varchar(4) 
declare @yy_2 varchar(4) 
declare @ymd_1 varchar(10) 
declare @ymd_2 varchar(10) 
declare @custCode varchar(5) 

set @startProgYmd = '2015-01-01' 
set @yy_1 = 2020 
set @yy_2 = 2021 
set @ymd_1 = @yy_1 + '-01-01' 
set @ymd_2 = @yy_1 + '-12-31' 

delete 
     from yu_sisan 
    where year = @yy_2 

select cust_code 
     into #tmp_01
     from cm_cust 

select T.cust_code, sum(S.geumaek) sisan 
     into #tmp_02
     from yu_sisan S, #tmp_01 T
    where S.year = @yy_1
 group by T.cust_code

select P.cust_code, sum(P.hapgye_geumaek) panmae 
     into #tmp_03
     from yu_panmae P, #tmp_01 T 
    where P.ymd >= @startProgYmd 
      and P.ymd >= @ymd_1 
      and P.ymd <= @ymd_2 
      and P.cust_code = T.cust_code 
 group by P.cust_code 

select I.cust_code, sum(I.geumaek) ipgeum, sum(I.halin_geumaek) halin, sum(I.japiik) japiik 
     into #tmp_04
     from yu_ipgeum I, #tmp_01 T 
    where I.ymd >= @startProgYmd 
      and I.ymd >= @ymd_1 
      and I.ymd <= @ymd_2 
      and T.cust_code = I.cust_code 
 group by I.cust_code 

select cust_code into #tmp_05 from #tmp_02    union 
select cust_code              from #tmp_03    union 
select cust_code              from #tmp_04 

select T5.cust_code, T2.sisan, T3.panmae, T4.ipgeum, T4.halin, T4.japiik,
       cast(null as numeric(18,0)) misu
     into #tmp_06
     from #tmp_05 T5 left outer join #tmp_01 T1
                                  on T1.cust_code = T5.cust_code
                     left outer join #tmp_02 T2
                                  on T1.cust_code = T2.cust_code
                     left outer join #tmp_03 T3
                                  on T1.cust_code = T3.cust_code
                     left outer join #tmp_04 T4
                                  on T1.cust_code = T4.cust_code
                                 
update #tmp_06 set sisan = 0 where sisan is null 
update #tmp_06 set panmae = 0 where panmae is null 
update #tmp_06 set ipgeum = 0 where ipgeum is null 
update #tmp_06 set halin = 0 where halin is null 
update #tmp_06 set japiik = 0 where japiik is null 
update #tmp_06 set misu = sisan + panmae - (ipgeum + halin - japiik)

-- insert into yu_sisan (year, cust_code, geumaek)
select @yy_2, cust_code, misu
     from #tmp_06
    where misu <> 0 

drop table #tmp_01
drop table #tmp_02
drop table #tmp_03
drop table #tmp_04
drop table #tmp_05
drop table #tmp_06





