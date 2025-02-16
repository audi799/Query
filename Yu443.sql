declare @ymd_1 varchar(10)
declare @ymd_2 varchar(10)

set @ymd_1 = '2020-02-01'
set @ymd_2 = '2020-03-09'


select ymd, pummok_code, jepum_code, box_code, sum(box_suryang) box_suryang
     into #tmp_01
     from yu_panmae
    where ymd >= @ymd_1
      and ymd <= @ymd_2
 group by ymd, pummok_code, jepum_code, box_code

select T.*,
       K.pummok_name, J.jepum_yakeo, B.box_name
     from #tmp_01 T left outer join cm_pummok K
                                 on K.pummok_code = T.pummok_code
                    left outer join cm_jepum J
                                 on J.pummok_code = T.pummok_code
                                and J.jepum_code = T.jepum_code
                    left outer join cm_box B
                                 on B.box_code = T.box_code

drop table #tmp_01