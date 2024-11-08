-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-创建型号-查询字段名称下的字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate_field_content_formal t1
-- ##Describe 排序：字段名称的顺序升序
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input content string[50] NULL;字段内容，非必填

-- ##output plateFieldContentGuid char[36] 字段内容guid;字段内容guid
-- ##output content string[50] 字段内容;
-- ##output relateFieldGuid char[36] 关联字段名称guid：有关联则有值，该字段内容被选中，则该字段名称要展示出来;
-- ##output valueGuid char[36] 板块字段内容候选项guid;板块字段内容候选项guid

select
*
from
(
select
t.guid as plateFieldContentGuid
,t.name as content
,t.relate_field_guid as relateFieldGuid
,t.norder
,'' as valueGuid
from
coz_model_am_aprom_plate_field_content_formal t
where 
t.plate_field_guid='{plateFieldGuid}' and t.del_flag='0' and (t.name like '%{content}%' or '{content}'='')
union all
select 
t3.guid as plateFieldContentGuid
,t3.value as content
,'' as relateFieldGuid
,t4.norder
,t3.guid as valueGuid
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