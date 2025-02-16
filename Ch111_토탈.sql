declare @ymd varchar(10)

set @ymd = '2020-02-27'

select sum(suryang) vt_suryang
     into #tmp_01
     from yu_chulha_plan JP
    where ymd = @ymd

select sum(suryang) vt_chulha_suryang, count(*) vt_chulha_cnt
     into #tmp_02
     from yu_chulha_jp
    where ymd = @ymd 

select T1.vt_suryang,
       T2.vt_chulha_suryang, vt_chulha_cnt,
       isnull(T1.vt_suryang,0) - isnull(T2.vt_chulha_suryang,0) vt_janryang
     from #tmp_01 T1, #tmp_02 T2

drop table #tmp_01
drop table #tmp_02