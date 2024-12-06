-- ##Title web-查询某一品类服务定价个人供方列表-按型号名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一品类服务定价个人供方列表-按型号名称
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input phonenumber string[100] NULL;联系电话(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t.guid as supplierGuid
,t.user_id as userId
,t1.user_name as userName
,t1.nation
,t1.phonenumber
,left(t.create_time,16) as addCatTime
,left(t1.create_time,16) as registerTime
from
coz_category_supplier t
left join
sys_app_user t1
on t.user_id=t1.guid
where
t.category_guid=''{categoryGuid}''and t.del_flag=''0'' and (t1.phonenumber like''%{phonenumber}%'' or ''{phonenumber}''='''') and t.user_type=''1''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;