-- ##Title app-查看好友申请记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查看好友申请记录
-- ##CallType[QueryData]

-- ##input catTreeCode enum[demand,supply] NOTNULL;demand-应聘，supply-招聘，必填
-- ##input userId char[36] NOTNULL;用户id（被申请的目标用户），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output applyGuid char[36] 申请guid;申请guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output applyDate string[10] 申请日期;申请日期（格式：0000-00-00）

select 
t1.guid as applyGuid
,t1.category_name as categoryName
,left(t1.create_time,10) as applyDate
from  
coz_chat_friend_apply t1
where 
t1.cat_tree_code='{catTreeCode}' and t1.user_id='{userId}' and t1.target_user_id='{curUserId}' and t1.del_flag='0'

