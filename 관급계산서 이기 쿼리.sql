/*-- cm_cust
select *
     from cm_cust

select cust_code, 3 cust_gubun_1, saeopja_beonho, sangho, daepyo, juso, eoptae, jongmok, 
       buseo_name_1, damdangja_1, tel_1, e_mail_1,
       buseo_name_2, damdangja_2, tel_2, e_mail_2,
       fax
 --   into #tmp_01
    from bladedb2.RJ_002.dbo.cust_cm_cust
   where company_code = 'RM_2C3'

update #tmp_01 set cust_code = '30001' where cust_code = '1111111'
update #tmp_01 set cust_code = '90002' where cust_code = '999-002'
update #tmp_01 set cust_code = '90003' where cust_code = '3'

insert into cm_cust
(cust_code, 3 cust_gubun_1, saeopja_beonho, sangho, daepyo, juso, eoptae, jongmok, 
       buseo_name_1, damdangja_1, tel_1, e_mail_1,
       buseo_name_2, damdangja_2, tel_2, e_mail_2,
       fax)
select * from #tmp_01

drop table #tmp_01
*/

/*-- gs_maechul
select * 
    into #tmp_01
    from bladedb2.RJ_002.dbo.cust_gs_maechul
   where company_code = 'RM_2C3'


--update #tmp_01 set cust_code = '90002' where cust_code = '999-002'
update #tmp_01 set cust_code = '30001' where cust_code = '1111111'
--update #tmp_01 set cust_code = '90003' where cust_code = '3'

insert into gs_maechul
(company_code, company_bunryu, yy, mm, gubun, no, cust_gubun, cust_code, jumin_beonho, person_name, person_mail, geumaek, seaek, hapgye, suryang, gyesanseo_ilja,
 gyesanseo_jongryu, gyesanseo_bunryu, yeongsu_cheonggu, sujeong_sayu, bigo_1, bigo_2, bigo_3, 
 taxinvoice_create_ilja, taxinvoice_send_ilja, taxinvoice_return_ilja, taxinvoice_esero_ilja)
select company_code, company_bunryu, yy, mm, gubun, no, cust_gubun, cust_code, jumin_beonho, person_name, person_mail, geumaek, seaek, hapgye, suryang, gyesanseo_ilja,
 gyesanseo_jongryu, gyesanseo_bunryu, yeongsu_cheonggu, sujeong_sayu, bigo_1, bigo_2, bigo_3, 
 taxinvoice_create_ilja, taxinvoice_send_ilja, taxinvoice_return_ilja, taxinvoice_esero_ilja
    from #tmp_01

drop table #tmp_01
*/

/*--gs_maechul_jp
select * 
    into #tmp_02
    from bladedb2.RJ_002.dbo.cust_gs_maechul_jp
   where company_code = 'RM_2C3'


insert into gs_maechul_jp
(company_code, company_bunryu, yy, mm, gubun, no ,sno, naeyeok, gyugyeok, bigo, suryang, danga, geumaek, seaek, hapgye)
select company_code, company_bunryu, yy, mm, gubun, no ,sno, naeyeok, gyugyeok, bigo, suryang, danga, geumaek, seaek, hapgye
    from #tmp_02

drop table #tmp_02
*/

/*-- gs_maeip
select * 
    into #tmp_03
    from bladedb2.RJ_002.dbo.cust_gs_maeip
   where company_code = 'RM_2C3'


--update #tmp_03 set cust_code = '90002' where cust_code = '999-002'
update #tmp_03 set cust_code = '30001' where cust_code = '1111111'
--update #tmp_03 set cust_code = '90003' where cust_code = '3'

insert into gs_maeip
(company_code, company_bunryu, yy, mm, gubun, no, cust_code, geumaek, seaek, hapgye, gyesanseo_ilja,
 gyesanseo_jongryu, gyesanseo_bunryu, yeongsu_cheonggu, sujeong_sayu, bigo_1, bigo_2, bigo_3, exchange_id)
select company_code, company_bunryu, yy, mm, gubun, no, cust_code, geumaek, seaek, hapgye, gyesanseo_ilja,
 gyesanseo_jongryu, gyesanseo_bunryu, yeongsu_cheonggu, sujeong_sayu, bigo_1, bigo_2, bigo_3, exchange_id
    from #tmp_03

drop table #tmp_03
*/

/*-- gs_maeip_jp
select * 
    into #tmp_04
    from bladedb2.RJ_002.dbo.cust_gs_maeip_jp
   where company_code = 'RM_2C3'

insert into gs_maeip_jp
(company_code, company_bunryu, yy, mm, gubun, no, sno, gonggeup_ilja, naeyeok, gyugyeok, bigo, suryang, danga, geumaek, seaek, hapgye)
select company_code, company_bunryu, yy, mm, gubun, no, sno, gonggeup_ilja, naeyeok, gyugyeok, bigo, suryang, danga, geumaek, seaek, hapgye
    from #tmp_04

drop table #tmp_04
*/