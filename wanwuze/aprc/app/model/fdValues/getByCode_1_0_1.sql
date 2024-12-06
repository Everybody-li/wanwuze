-- ##Title app-查询固化库字段内容列表
-- ##Author lith
-- ##CreateTime 2022-08-04
-- ##Describe app-查询固化库字段内容列表
-- ##CallType[QueryData]

-- ##input contentFDCode string[10] NULL; 固化内容code，必填
-- ##input curUserId char[36] NOTNULL;  登录用户id，必填
-- ##input plateFieldGuid char[36] NULL;  登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output key string[10] c10003; 固化内容key
-- ##output display string[50] 桶; 固化内容字符串值


PREPARE q1 FROM '
select
*
from
(
select t1.code as `key`, t2.value as display,t1.id
from coz_model_fixed_data t1
         inner join coz_model_fixed_data_value t2
                    on t1.guid = t2.fixed_data_guid
where t1.del_flag = ''0''
  and t2.del_flag = ''0''
  and (t1.code = ''{contentFDCode}'')
union all
select t.content as `key`,t.content as display,t.id
from coz_model_plate_field_content_formal t
left join
coz_model_plate_field_formal t1
on t.plate_field_formal_guid=t1.guid
where t.del_flag = ''0'' and t1.content_source<>''3''
  and (t.plate_field_formal_guid = ''{plateFieldGuid}'' and ''{contentFDCode}''='''')
union all
select t2.content as `key`,t2.content as display,t2.id
from coz_model_plate_field_formal t
inner join
coz_model_plate_field_formal t1
on t.biz_type=t1.biz_type  and t.category_guid=t1.category_guid and t.name=t1.name and t.cat_tree_code=''supply'' and t1.cat_tree_code=''demand''
inner join
coz_model_plate_field_content_formal t2
on t1.guid=t2.plate_field_formal_guid
where t2.del_flag = ''0'' and t.content_source=''3''
  and (t.guid = ''{plateFieldGuid}'' and ''{contentFDCode}''='''')
	)t
order by id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
