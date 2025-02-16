declare @orgCarCode varchar(4)
declare @chgCarCode varchar(4)

--기존차량번호
set @orgCarCode = '6978'
--변경차량번호
set @chgCarCode = '9763'

if (select count(*) from cm_car where car_code = @orgCarCode and isnull(gps_number,'') <> '' ) > 0
begin
  if (select count(*) from cm_car where car_code = @chgCarCode) > 0 
  begin
    select '변경전_기존차량' title, car_code, gps_number
         from cm_car
        where car_code = @orgCarCode

    update cm_car set gps_number = (select gps_number
                                         from cm_car
                                        where car_code = @orgCarCode)
                where car_code = @chgCarCode

    update cm_car set gps_number = null
        where car_code = @orgCarCode

    select '변경후_기존차량' title, car_code, gps_number
         from cm_car
        where car_code = @orgCarCode

    select '변경차량_처리완료' title, car_code, gps_number
         from cm_car
        where car_code = @chgCarCode

    delete
         from car_status
        where car_code = @orgCarCode
  end
  else
  begin
    select '변경차량_차량등록안되어있음'
  end
end
else
begin
  select '기존차량_관제번호없거나_차량등록안되어있음'
end

