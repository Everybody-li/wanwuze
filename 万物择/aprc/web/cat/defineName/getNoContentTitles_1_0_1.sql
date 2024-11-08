-- ##Title web-品类定义-生成品类名称之前判断字节内容是否都有维护
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类定义-生成品类名称之前判断字节内容是否都有维护
-- ##CallType[QueryData]

-- ##output screenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output titleName string[50] 字节标题名称;字节标题名称（返回字节内容没有数据的字节标题名称）

select
Name as titleName
from 
coz_category_name_title t
where 
scene_tree_guid='{screenGuid}'and del_flag='0'
and not exists(select 1 from coz_category_name_tree where level=t.level and scene_tree_guid='{screenGuid}')