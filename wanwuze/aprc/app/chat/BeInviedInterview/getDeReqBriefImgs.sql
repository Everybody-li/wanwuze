-- ##Title app-应聘-应聘进展管理-受邀信息接收-受邀记录管理-查看工作需求受邀记录-受邀记录列表-查看简介图片-子表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-17
-- ##Describe 查询招聘方的简介信息，招聘方的简介图片是多个，要使用复合接口查多个，这是图片子接口
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid
-- ##input supplyUserId char[36] NOTNULL;供方用户id
-- ##input curUserId string[36] NOTNULL;登录用户id


select t.user_id as userId
     , t.img
,t2.guid as deRequestGuid
from coz_user_biz_img t
         inner join coz_cattype_sd_path t1 on t.supply_path_guid = t1.supply_path_guid
         inner join coz_chat_supply_request t2 on t2.sd_path_guid = t1.guid
where t.user_id = '{supplyUserId}'
  and t.del_flag = '0'
  and t1.guid = '{sdPathGuid}'