-- ##Title 获取版本发布列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 获取版本发布列表
-- ##CallType[QueryData]

-- ##input status string[50] NULL;发布状态(0：全部，1：已发布，2：未发布)，非必填
-- ##input platform string[50] NULL;发布平台(0：全部，1：Android，2：IOS)，非必填
-- ##input version string[50] NULL;版本号(后端支持模糊搜索)，非必填
-- ##input publishUserName string[50] NULL;发布者用户名(后端支持模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output versionGuid char[36] 版本guid;版本guid
-- ##output version string[50] 版本号;版本号
-- ##output wegiht int[>=0] 10;权重
-- ##output status string[50] 1;发布状态(0：全部，1：已发布，2：未发布)
-- ##output platform string[50] 0;发布平台(0：全部，1：Android，2：IOS)
-- ##output publishTime string[50] 0000-00-00 00:00:00;发布时间(格式：0000-00-00 00:00:00)
-- ##output remark string[50] 版本说明;版本说明
-- ##output publishUserName string[50] 发布者用户名;发布者用户名

PREPARE q1 FROM '
select
t.guid as versionGuid
,t.version
,t.weight
,t.status
,t.platform
,t.publish_time as publishTime
,t.remark
,t1.user_name as publishUserName
,t.size as apkSize
,''DOWNLOAD'' as apkPath
from
coz_app_version t
left join
sys_user t1
on t.update_by=t1.user_id

where 
(t.status=''{status}'' or ''{status}''=''0'') and 
(t.platform=''{platform}'' or ''{platform}''=''0'') and 
(t.version like''%{version}%'' or ''{version}''='''') and 
(t1.user_name like''%{publishUserName}%'' or ''{publishUserName}''='''') and
((t.publish_time>= ''{startPublishTime}'' and t.publish_time<=''{endPublishTime}'') or t.publish_time is null)
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;