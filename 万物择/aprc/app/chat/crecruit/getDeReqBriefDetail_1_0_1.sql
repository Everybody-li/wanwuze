-- ##Title app-招聘-查询应聘简历信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘-查询应聘简历信息
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output deRequestGuid char[36] 应聘需求Guid;应聘需求Guid
-- ##output userId char[36] 应聘方用户id;应聘方用户id
-- ##output userName string[50] 应聘方用户姓名;应聘方用户姓名
-- ##output categoryGuid char[36] 品类名称Guid;品类名称Guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryAlias string[50] 品类名称别名;品类名称别名
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output guidanceMsg string[50] 提示：同意加好友后，请在菜单【人资】的【面试沟通通道】与应聘者在线沟通。;底部操作指引提示信息

select
t.guid as deRequestGuid
,t.user_id as userId
,t.user_name as userName
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.category_alias as categoryAlias
,t.reimg
,t.category_img as categoryImg
,'提示：同意加好友后，请在菜单【人资】的【面试沟通通道】与应聘者在线沟通。' as guidanceMsg
from
coz_chat_demand_request t
where 
t.guid='{deRequestGuid}'