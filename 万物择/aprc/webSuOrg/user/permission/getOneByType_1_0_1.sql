-- ##Title app-供应-查看限制采购/供应理由
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查看限制采购/供应理由
-- ##CallType[QueryData]

-- ##input categoryGuid string[50] NOTNULL;品类guid
-- ##input type int[>=0] NOTNULL;权限类型(4：品类采购操作权限，5：品类供应操作权限)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output userId char[36] 用户id;用户id
-- ##output remark string[100] 理由;理由
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryAlias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output createTime string[19] 禁用起始时间;禁用起始时间


select
t.user_id as userId
,t.remark
,t.biz_guid as categoryGuid
,t2.name as categoryName
,t2.img as categoryImg
,t2.alias as categoryAlias
,t.update_time as createTime
from
coz_app_user_permission_detail t
left join
coz_category_info t2
on t.biz_guid=t2.guid
where 
t.user_id='{curUserId}' and t.type={type} and t.biz_guid='{categoryGuid}' and t.del_flag='0'
;

