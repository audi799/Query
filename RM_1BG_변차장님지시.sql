/*

[ �������� status ���� �� �ǹ� ]
  * 1: ���峻 ����
  * 2: ���忡�� �� ����� ��       (��ȫ)
  * 3: �������ΰ�����.             (����)
  * 4: �������ΰ��� �� ��� ����   (���� + �巳 ȸ��)
  * 5: ���峻 ����                 (����)
  * 6: ���忡�� �����̱� ��������  (�ʷ�)
  * 7: �������� ���ƿ�����         (���)
  * 8: ���忡������ �� ��� ���� (��� + �巳 ȸ��)

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