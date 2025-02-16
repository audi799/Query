select ymd, cust_code, hyeonjang_code, 
       case when ipgeum_gubun = 1 then isnull(sum(geumaek),0) + isnull(sum(japiik),0) end hyeongeum,
       case when ipgeum_gubun = 2 then isnull(sum(geumaek),0) + isnull(sum(japiik),0) end eoeum,
       case when ipgeum_gubun = 3 then isnull(sum(geumaek),0) + isnull(sum(japiik),0) end ipgeum,
       sum(halin_geumaek) halin, sum(japiik) japiik,
       ipgeum_gubun, bill_no, ipgeum_no, jeokyo, jisi_gubun, jisi_beonho 
     into #tmp_01 
     from yu_ipgeum
    where ymd = '2020-04-14' 
 group by ymd, cust_code, hyeonjang_code, ipgeum_gubun, bill_no, ipgeum_no, jeokyo, jisi_gubun, jisi_beonho 

select ymd, cust_code, hyeonjang_code, sum(hyeongeum) hyeongeum, sum(eoeum) eoeum, sum(ipgeum) ipgeum, sum(halin) halin, sum(japiik) japiik,
       ipgeum_gubun, bill_no, ipgeum_no, jeokyo, jisi_gubun, jisi_beonho,
       cast(null as numeric(19,0)) h_ipgeum, cast(null as numeric(19,0)) ipgeumHap
     into #tmp_02
     from #tmp_01
 group by ymd, cust_code, hyeonjang_code, ipgeum_gubun, bill_no, ipgeum_no, jeokyo, jisi_gubun, jisi_beonho

update #tmp_02 set ipgeumHap = isnull(hyeongeum,0) + isnull(eoeum,0) + isnull(ipgeum,0) + isnull(halin,0) + isnull(japiik,0)
update #tmp_02 set h_ipgeum  = isnull(hyeongeum,0) + isnull(ipgeum,0)

select distinct bill_no 
     into #tmp_03 
     from #tmp_02

select B.beonho, B.jongryu, B.balhaeng_ilja, B.mangi_ilja, B.balhaeng_cust_code, B.balhaeng_sangho, B.bank_cust_code, B.bank_sangho 
     into #tmp_04 
     from #tmp_03 T, yu_bill B 
    where T.bill_no = B.beonho 

select T.*, T4.* 
     into #tmp_05 
     from #tmp_02 T left outer join #tmp_04 T4
                                 on T4.beonho = T.bill_no 

select T.*, C1.sangho, C2.sangho balhaeng_name, C3.sangho bank_name, H.hyeonjang_name, 
       case when C1.hyeonjang_gubun = 1 then C1.sawon_code else H.sawon_code end sawon_code, S.sawon_name,
       G.ipgeum_name, C1.cust_gubun_2
     from #tmp_05 T left outer join cm_cust C1 
                                 on C1.cust_code = T.cust_code 
                    left outer join cm_cust C2 
                                 on C2.cust_code = T.balhaeng_cust_code 
                    left outer join cm_cust C3 
                                 on C3.cust_code = T.bank_cust_code 
                    left outer join cm_hyeonjang H 
                                 on H.cust_code = T.cust_code 
                                and H.hyeonjang_code = T.hyeonjang_code 
                    left outer join cm_sawon S 
                                 on S.sawon_code = (case when C1.hyeonjang_gubun = 1 then C1.sawon_code else H.sawon_code end ) 
                    left outer join cm_ipgeum_gubun G
                                 on G.ipgeum_gubun = T.ipgeum_gubun
 order by C1.sangho, T.ymd, T.cust_code, T.hyeonjang_code 

drop table #tmp_01 
drop table #tmp_02 
drop table #tmp_03 
drop table #tmp_04 
drop table #tmp_05


