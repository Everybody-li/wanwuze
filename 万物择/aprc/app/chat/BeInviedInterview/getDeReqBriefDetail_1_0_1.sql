-- ##Title app-应聘-应聘进展管理-受邀信息接收-受邀记录管理-查看工作需求受邀记录-受邀记录列表-查看简介-主表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询招聘方的简介信息，招聘方的简介图片是多个，要使用复合接口查多个
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;招聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output deRequestGuid char[36] 招聘需求Guid;招聘需求Guid
-- ##output userId char[36] 招聘方用户id;招聘方用户id
-- ##output userName string[50] 招聘方用户姓名;招聘方用户姓名
-- ##output categoryGuid char[36] 品类名称Guid;品类名称Guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryAlias string[50] 品类名称别名;品类名称别名
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output guidanceMsg string[50] 提示：同意加好友后，请在菜单【人资】的【面试沟通通道】与招聘者在线沟通。;底部操作指引提示信息
-- ##output suImgs.img string[50] 单位简介图片;单位简介图片

select
t.guid as deRequestGuid
,t.user_id as userId
,t.user_name as nickName
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.category_alias as categoryAlias
,t.category_img as categoryImg
,'提示：同意加好友后，请在菜单【人资】的【面试沟通通道】与招聘者在线沟通。' as guidanceMsg
,CONCAT('{ChildRows_aprc\\app\\chat\\BeInviedInterview\\getDeReqBriefImgs:deRequestGuid=''',t.guid,'''}') as `suImgs`
from
coz_chat_supply_request t
where 
t.guid='{deRequestGuid}'