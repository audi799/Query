/*

[ 차량색깔별 status 순번 및 의미 ]
  * 1: 공장내 차량
  * 2: 공장에서 막 출발한 차       (분홍)
  * 3: 현장으로가는차.             (빨강)
  * 4: 현장으로가는 중 잠시 정차   (빨강 + 드럼 회색)
  * 5: 현장내 차량                 (검정)
  * 6: 현장에서 움직이기 시작한차  (초록)
  * 7: 공장으로 돌아오는차         (노랑)
  * 8: 공장에들어오는 중 잠시 정차 (노랑 + 드럼 회색)

*/


select *,
       cast(null as tinyint) status
     into #tmp_01
     from car_operation 
    where ymd = '2023-08-25'

update #tmp_01 set status = 1
             where operation_start_time is not null
               and operation_end_time is not null

update #tmp_01 set status = 3
             where operation_start_time is not null
               and operation_end_time is null
               and spot_arrival_time is null
               and spot_start_time is null

update #tmp_01 set status = 5
             where operation_start_time is not null
               and operation_end_time is null
               and spot_arrival_time is not null
               and spot_start_time is null

update #tmp_01 set status = 7
             where operation_start_time is not null
               and operation_end_time is null
               and spot_arrival_time is not null
               and spot_start_time is not null

select ymd, nno, car_code, gps_number, status
     from #tmp_01

drop table #tmp_01

select * from car_operation