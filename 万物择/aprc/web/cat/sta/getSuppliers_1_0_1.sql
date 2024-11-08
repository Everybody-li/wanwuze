-- ##Title web-查询供方数量-沟通类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供方数量-沟通类
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input phonenumber string[20] NULL;供方手机号（后端支持模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output userName string[50] 供方姓名;供方姓名
-- ##output nation string[50] 供方区号;供方区号
-- ##output phonenumber string[50] 联系电话;联系电话

PREPARE q1 FROM '
select
*
from
(
select 
t1.user_name as userName
,t1.nation
,t1.phonenumber
,t.id
from  
coz_category_supplier t
left join
sys_app_user t1
on t.user_id=t1.guid
where 
t.category_guid=''{categoryGuid}'' and (t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and t.del_flag=''0'' and t.user_type=''1''
union all
select 
t1.user_name as userName
,t1.nation
,t1.phonenumber
,t.id
from  
coz_category_supplier t
left join
sys_weborg_user t1
on t.user_id=t1.guid
where 
t.category_guid=''{categoryGuid}'' and (t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and t.del_flag=''0'' and t.user_type=''2''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
