declare @originCarCode varchar(4)
declare @changeCarCode varchar(4)
declare @gpsNumber varchar(5)

set @originCarCode = '1051'
set @changeCarCode = '1645'
set @gpsNumber = (select gps_number
                       from bladedb1.GJ_A38.dbo.cm_car
                      where car_code = @originCarCode)

/*

-- (1)�������� ������ȣ ���ֱ�.
update bladedb1.GJ_A38.dbo.cm_car set gps_number = null
    where car_code = @originCarCode

update bladedb1.AS_A38.dbo.cm_car set gps_number = null
    where car_code = @originCarCode

update bladedb1.AS_A43.dbo.cm_car set gps_number = null
    where car_code = @originCarCode 


-- (2) �������� �������� ���ֱ�.
delete
     from bladedb1.GJ_A38.dbo.car_status
    where car_code = @originCarCode 

delete
     from bladedb1.AS_A38.dbo.car_status
    where car_code = @originCarCode 

delete
     from bladedb1.AS_A43.dbo.car_status
    where car_code = @originCarCode 


-- (3) ������������ ������ȣ �о�ֱ�
update bladedb1.GJ_A38.dbo.cm_car set gps_number = @gpsNumber
    where car_code = @changeCarCode

update bladedb1.AS_A38.dbo.cm_car set gps_number = @gpsNumber
    where car_code = @changeCarCode

update bladedb1.AS_A43.dbo.cm_car set gps_number = @gpsNumber
    where car_code = @changeCarCode

*/


