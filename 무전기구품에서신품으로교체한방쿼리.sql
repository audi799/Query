/*
Johap-DB에서 하기

(1)구품단말 SKR_Gps.dbo.cm_car 삭제쿼리
delete
     from BladeDB3.skr_gps.dbo.cm_car
    where factory_code = 'RM_6C1'
      and gps_number in ('1089830274','1089830287','1089830385','1089830463','1089830469','1089830472','1089830481','1089830544','1089830571')

delete
     from BladeDB3.skr_gps.dbo.compare_gps
    where factory_code = 'RM_6C1'
      and gps_number in ('1089830274','1089830287','1089830385','1089830463','1089830469','1089830472','1089830481','1089830544','1089830571')


(2) 단말기관리에서 무전기 해약 잡기
insert into gps_cust values ('SK00952', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00953', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00954', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00955', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00956', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00957', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00958', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00959', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00960', '2022-04-26', 'GM_001', null, null, '구품해약', 9)
insert into gps_cust values ('SK00961', '2022-04-26', 'GM_001', null, null, '구품해약', 9)


(3) MGM 관제 계산서 반영하는부분에서도 해약잡고, 신품단말 추가하기.
select maeip_danga, maechul_danga, sum(suryang) suryang
     from bladedb2.MGM.dbo.gps_cust_list_jp
    where cust_code = 'RM_6C1'
 group by maeip_danga, maechul_danga

insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-26', 'ZZ_069', 2, -9, 13500, 27000, 1, '구품해약', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-26', 'ZZ_069', 2, -1, 13500, 18000, 1, '구품해약', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-27', 'ZZ_069', 2, 9, 13500, 27000, 1, '신품무전+Gps', '2022-05-01')
insert into bladedb2.MGM.dbo.gps_cust_list_jp values ('RM_6C1', '2022-04-28', 'ZZ_069', 2, 1, 13500, 18000, 1, '신품무전만', '2022-05-01')

(4) 업체DB의 cm_car에서 관제번호 null로 업데이트처리 및 car_status 초기화
update BladeDB3.RM_6C1.dbo.cm_car set gps_number = null
    where gps_number is not null

delete
     from BladeDB3.RM_6C1.dbo.car_status

(5) 단말기관리에 신품단말 개별등록(샘플쿼리에서 돌리기)

(6) SKR_Gps.dbo.cm_car에 신품단말 등록하기.
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071050956', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051439', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051572', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051610', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051620', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051635', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051643', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051653', 'RM_6C1', null, 'RM_6C1')
insert into BladeDB3.skr_gps.dbo.cm_car values ('1071051697', 'RM_6C1', null, 'RM_6C1')


(7) 업체DB에 차량등록에 관제번호 등록하기
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




