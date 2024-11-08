-- ##Title 根据品类类型guid查询品类类型详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据品类类型guid查询品类类型详情
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填

-- ##output guid char[36] 品类类型guid;品类类型guid
-- ##output name string[200] 字节内容名称;字节内容名称
-- ##output mode int[>=0] 0;品类模式（1：沟通模式，1：交易模式）

select
t.guid
,t.name
,t.mode
from
coz_cattype_fixed_data t
where 
t.guid='{cattypeGuid}'
