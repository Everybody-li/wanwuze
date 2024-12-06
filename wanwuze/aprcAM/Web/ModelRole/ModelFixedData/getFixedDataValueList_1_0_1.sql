-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-查询
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 根据关联的t1的guid查
-- ##CallType[QueryData]

-- ##input parentGuid string[36] NOTNULL;父字节内容guid（前端判断，没有上一段字节内容,传0），必填
-- ##input fixedDataGuid string[36] NOTNULL;固化内容信息库guid，必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output fixedDataGuid char[36] 固化内容信息库guid;固化内容信息库guid
-- ##output allParentId string[200] 所有父亲及祖父节点id;所有父亲及祖父节点id
-- ##output parentGuid char[36] 父节点guid;父节点guid
-- ##output pathValue string[20] 组系节点名称;组系节点名称
-- ##output fixedDataValueGuid char[36] 字节内容guid;字节内容guid
-- ##output value string[20] 内容名称;内容名称
-- ##output level int[>=0] 1;所在树形层级
-- ##output norder int[>=0] 1;排序
-- ##output hasSon int[>=0] 0;是否还有儿子节点（0：否，1-是）,即是否有下一段字节内容关联
-- ##output createTime string[19] 创建时间;创建时间
-- ##output parentValue string[20] 父内容名称;父内容名称

select 
t1.fixed_data_guid as fixedDataGuid
,t1.all_parent_id as allParentId
,t1.parent_guid as parentGuid
,t1.path_value as pathValue
,t1.guid as fixedDataValueGuid
,t1.value
,t1.level
,t1.norder
,(select value from coz_model_fixed_data_value where t1.parent_guid=guid) as parentValue
,case when exists(select 1 from coz_model_fixed_data_value where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
,left(t1.create_time,19) as createTime
from 
coz_model_fixed_data_value t1
where 
t1.parent_guid='{parentGuid}' and t1.del_flag='0' and t1.fixed_data_guid='{fixedDataGuid}'
order by t1.norder,t1.id