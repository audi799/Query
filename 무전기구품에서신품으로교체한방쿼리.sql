/*
Johap-DB���� �ϱ�

(1)��ǰ�ܸ� SKR_Gps.dbo.cm_car ��������
delete
     from BladeDB3.skr_gps.dbo.cm_car
    where factory_code = 'RM_6C1'
      and gps_number in ('1089830274','1089830287','1089830385','1089830463','1089830469','1089830472','1089830481','1089830544','1089830571')

delete
     from BladeDB3.skr_gps.dbo.compare_gps
    where factory_code = 'RM_6C1'
      and gps_number in ('1089830274','1089830287','1089830385','1089830463','1089830469','1089830472','1089830481','1089830544','1089830571')


(2) �ܸ���������� ������ �ؾ� ���
insert into gps_cust values ('SK00952', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00953', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00954', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00955', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00956', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00957', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00958', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00959', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00960', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)
insert into gps_cust values ('SK00961', '2022-04-26', 'GM_001', null, null, '��ǰ�ؾ�', 9)


(3) MGM ���� ��꼭 �ݿ��ϴºκп����� �ؾ����, ��ǰ�ܸ� �߰��ϱ�.
select maeip_danga, maechul_danga, sum(suryang) suryang
     from bladedb2.MGM.dbo.gps_cust_list_jp
    where cust_code = 'RM_6C1'
 group by maeip_danga, maechul_danga

insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-26', 'ZZ_069', 2, -9, 13500, 27000, 1, '��ǰ�ؾ�', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-26', 'ZZ_069', 2, -1, 13500, 18000, 1, '��ǰ�ؾ�', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-27', 'ZZ_069', 2, 9, 13500, 27000, 1, '��ǰ����+Gps', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-28', 'ZZ_069', 2, 1, 13500, 18000, 1, '��ǰ������', '2022-05-01')

(4) ��üDB�� cm_car���� ������ȣ null�� ������Ʈó�� �� car_status �ʱ�ȭ
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = null
    where gps_number is not null

delete
     from BladeDB3.RM_6C1.dbo.car_status

(5) �ܸ�������� ��ǰ�ܸ� �������(������������ ������)

(6) SKR_Gps.dbo.cm_car�� ��ǰ�ܸ� ����ϱ�.
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071050956', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051439', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051572', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051610', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051620', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051635', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051643', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051653', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051697', 'RM_6C1', null, 'RM_6C1')


(7) ��üDB�� ������Ͽ� ������ȣ ����ϱ�
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-0956' where car_code = '3262'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1439' where car_code = '3264'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1572' where car_code = '4122'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1610' where car_code = '3942'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1620' where car_code = '3265'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1635' where car_code = '3263'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1643' where car_code = '3261'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1653' where car_code = '3608'
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = '010-7105-1697' where car_code = '3607'


*/




