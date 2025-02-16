select ymd, pummok_code, jepum_code, ipgo_gubun, sum(suryang) suryang
     into #tmp_01
     from yu_ipgo
    where ymd >= '2020-01-01'
      and ymd <= '2020-03-31'
 group by ymd, pummok_code, jepum_code, ipgo_gubun

select T.ymd, T.pummok_code, T.jepum_code, T.ipgo_gubun, T.suryang,
       K.pummok_name, J.jepum_yakeo, J.jepum_name, G.gubun_name,
       case when ipgo_gubun = 'N' then '정상'
            when ipgo_gubun = 'B' then '불량'
            when ipgo_gubun = 'R' then '반품'
            when ipgo_gubun = 'P' then '반품(폐기)'
            when ipgo_gubun = 'S' then '영업샘플'
            when ipgo_gubun = 'U' then '기타증가'
            when ipgo_gubun = 'D' then '기타감소' end ipgo_gubun_name
     from #tmp_01 T left outer join cm_pummok K
                                 on K.pummok_code = T.pummok_code
                    left outer join cm_jepum J
                                 on J.pummok_code = T.pummok_code
                                and J.jepum_code = T.jepum_code
                    left outer join cm_pummok_gubun G
                                 on G.pummok_gubun = K.pummok_gubun

drop table #tmp_01


