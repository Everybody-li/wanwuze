-- ##Title web-型号专员-沟通通用模式-查询品类类型列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类类型通用供需需求信息列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output publishFlag int[>=0] 0;发布标志（0-未发布，其他数值：已发布）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

select
    category_guid as categoryGuid
  , t2.name       as categoryName
  , t2.name       as cattypeName
  , publish_flag  as publishFlag
  , publish_time  as publishTime
  , t.create_time as createTime
from
    coz_category_chat_mode            t
    inner join coz_cattype_fixed_data t2 on t.category_guid = t2.guid
where t.del_flag = '0' and t2.del_flag = '0' and t2.mode = 1
order by t.id desc
