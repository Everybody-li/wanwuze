-- ##Title web后台-审批模式-通用配置-供需需求信息管理-查询发布记录列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 查询
-- ##Describe 表名：coz_category_am_aprom_mode_log t1,sys_user t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output publishTime string[19] 发布时间;发布时间（格式：0000年00月00日 00:00）
-- ##output userName string[30] 账号;账号
-- ##output nickName string[30] 姓名;姓名
-- ##output nation string[30] 国家;国家/地区
-- ##output phonenumber string[11] 手机号;手机号


PREPARE q1 FROM '
select
concat(left(t2.create_time,4),''年'',right(left(t2.create_time,7),2),''月'',right(left(t2.create_time,10),2),''日'',right(left(t2.create_time,16),6)) as publishTime
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
from
coz_category_am_aprom_mode_log t2
left join
sys_user t1
on t1.user_id=t2.create_by
where t2.category_guid=''{categoryGuid}''
order by t2.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;