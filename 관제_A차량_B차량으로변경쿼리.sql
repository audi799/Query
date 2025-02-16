declare @orgCarCode varchar(4)
declare @chgCarCode varchar(4)

--����������ȣ
set @orgCarCode = '6978'
--����������ȣ
set @chgCarCode = '9763'

if (select count(*) from cm_car where car_code = @orgCarCode and isnull(gps_number,'') <> '' ) > 0
begin
  if (select count(*) from cm_car where car_code = @chgCarCode) > 0 
  begin
    select '������_��������' title, car_code, gps_number
         from cm_car
        where car_code = @orgCarCode

    update cm_car set gps_number = (select gps_number
                                         from cm_car
                                        where car_code = @orgCarCode)
                where car_code = @chgCarCode

    update cm_car set gps_number = null
        where car_code = @orgCarCode

    select '������_��������' title, car_code, gps_number
         from cm_car
        where car_code = @orgCarCode

    select '��������_ó���Ϸ�' title, car_code, gps_number
         from cm_car
        where car_code = @chgCarCode

    delete
         from car_status
        where car_code = @orgCarCode
  end
  else
  begin
    select '��������_������ϾȵǾ�����'
  end
end
else
begin
  select '��������_������ȣ���ų�_������ϾȵǾ�����'
end

