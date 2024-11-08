-- ##Title web-查询采购需求支付管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询采购需求支付管理
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input orgName string[50] NULL;采购编号(模糊搜索)，非必填
-- ##input startDate string[50] NULL;合同开始日期(格式：0000-00-00)，必填
-- ##input endDate string[10] NULL;合同终止日期(格式：0000-00-00)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
*
from
(
select
t2.user_id as supplyUserId
,concat(''(+86)'',t2.phonenumber) as phonenumber
,t2.name as orgName
,left(t2.create_time,16) as registerTime
,t2.id
,(select count(1) from coz_order where supply_user_id=t2.user_id and category_guid=''{categoryGuid}'' and accept_status=''1'' and del_flag=''0'') as accpetNum
from 
coz_org_info t2
where 
(t2.name like''%{orgName}%'' or ''{orgName}''='''') 
)t 
where 
accpetNum>0
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;