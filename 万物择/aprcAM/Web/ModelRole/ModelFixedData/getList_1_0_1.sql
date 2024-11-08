-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询:仅查询biz_type=7的
-- ##Describe 表名：coz_model_fixed_data t1
-- ##CallType[QueryData]

-- ##input name string[20] NULL;库名称，模糊搜索
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output fixedDataGuid char[36] 固化内容信息库guid;固化内容信息库guid
-- ##output name string[20] 库名称;库名称
-- ##output createTime string[19] 创建时间;创建时间
-- ##output updateTime string[19] 修改时间;修改时间
-- ##output upaterName string[50] 修改人;修改人


select
t.guid as fixedDataGuid
,t.name
,t.create_time as createTime
,t.update_time as updateTime
,t1.user_name as upaterName
from
coz_model_fixed_data t
left join
sys_user t1
on t.update_by=t1.user_id
where 
t.biz_type='7' and t.del_flag='0' and
(t.name like'%{name}%' or '{name}'='')
order by id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};