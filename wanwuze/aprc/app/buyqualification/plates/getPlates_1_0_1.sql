-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]


select
t.status
,'4' as bizType
,t.plate_norder as norder
,t.plate_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.qualification_user_guid as qualificationUserGuid
,CONCAT('{ChildRows_aprc\\app\\buyqualification\\plates\\getPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `field`
from
coz_category_buy_qualification_user_plate t
where
t.qualification_user_guid='{qualificationUserGuid}' and t.del_flag='0'
group by t.status,t.plate_norder,t.plate_formal_alias,t.plate_formal_guid,t.qualification_user_guid