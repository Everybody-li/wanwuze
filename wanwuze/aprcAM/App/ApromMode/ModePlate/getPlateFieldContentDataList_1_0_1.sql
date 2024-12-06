-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求页面加载-板块字段名称-查询字段名称下的字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate_field_formal t1,coz_model_am_aprom_plate_field_settings_formal t2,coz_model_am_aprom_plate_field_content_formal t3
-- ##CallType[QueryData]

-- ##input content string[50] NULL;字段内容，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output content string[50] 字段内容;
-- ##output relateFieldGuid char[36] 关联字段名称guid：有关联则有值，该字段内容被选中，则该字段名称要展示出来;

select
*
from
(
select
t.name as content
,t.relate_field_guid as relateFieldGuid
,t.norder
from
coz_model_am_aprom_plate_field_content_formal t
where 
t.plate_field_guid='{plateFieldGuid}' and t.del_flag='0' and (t.name like '%{content}%' or '{content}'='')
union all
select 
t3.value as content
,'' as relateFieldGuid
,t4.norder
from 
coz_model_fixed_data t2
inner join 
coz_model_fixed_data_value t3
on t2.guid = t3.fixed_data_guid
inner join 
coz_model_am_aprom_plate_field_formal t4
on t2.guid = t4.content_fixed_data_guid 
where t4.guid = '{plateFieldGuid}' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and (t3.value like '%{content}%' or '{content}'='')
)t
order by t.norder
Limit {compute:[({page}-1)*{size}]/compute},{size};