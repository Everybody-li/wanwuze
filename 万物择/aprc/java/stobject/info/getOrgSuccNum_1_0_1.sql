-- ##Title 根据处理批次查询处理成功数量
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 根据处理批次查询处理成功数量
-- ##CallType[QueryData]

-- ##input batchUuid string[36] NOTNULL;批量处理批次，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output successNum int[>=0] 1;累计反馈内容已被回复但是未查看的数量

select 
count(1) as successNum
from
coz_target_object_org t
where
t.batch_uuid='{batchUuid}'
