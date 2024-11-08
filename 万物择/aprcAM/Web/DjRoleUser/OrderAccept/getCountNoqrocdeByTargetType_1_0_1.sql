-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供方对接成果管理-非二维码-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类订单验收通过数量,按订单验收月份分组,按订单验收通过时间倒序
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationMonth char[7] 2023-12;统计时间(订单验收通过时间)
-- ##output totalNum int[>=0] 10;订单验收通过数量

select 
left(t3.accept_time,7) as operationMonth
,count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_order t3
on t1.biz_guid=t3.guid
where t1.del_flag='0' 
and t3.del_flag='0' 
and t3.accept_status='1'
and (
('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or 
('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or 
('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
group by left(t3.accept_time,7)
order by left(t3.accept_time,7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



