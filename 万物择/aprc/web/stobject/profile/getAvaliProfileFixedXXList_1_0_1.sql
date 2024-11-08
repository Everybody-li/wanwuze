-- ##Title web-查询可添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询可添加的信息名称列表
-- ##CallType[QueryData]

-- ##input name string[20] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input objectOrgGuid string[36] NOTNULL;机构类型guid(个人信息时前端固定传"noorg")，必填
-- ##input objectGuid string[36] NOTNULL;机构类型guid(个人信息时前端固定传"noorg")，必填
-- ##input profileTemplateGuid char[36] NOTNULL;档案模板guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.guid as fixedDataGuid
,t1.name
,t1.code
,case when (exists(select 1 from coz_target_object_profile where third_dynamic_gcode=t1.code and del_flag=''0'' and object_org_guid=''{objectOrgGuid}'' and object_guid=''{objectGuid}'' and profile_template_guid=''{profileTemplateGuid}'')) then ''1'' else ''0'' end as selected
from 
coz_model_fixed_data t1
where 
(t1.name like''%{name}%'' or ''{name}''='''') and t1.del_flag=''0'' and t1.display_type in (''1'',''2'') and biz_type=''6''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;