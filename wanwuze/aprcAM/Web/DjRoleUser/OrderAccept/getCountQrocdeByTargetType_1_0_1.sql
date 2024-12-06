-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户成果管理/供方对接成果管理-二维码-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类办理申请点击次数,按点击时间倒序
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationMonth char[7] 2023-12;统计时间(办理申请点击时间)
-- ##output totalNum int[>=0] 10;办理申请点击

select left(t2.create_time, 7) as operationMonth
     , count(1)                as totalNum
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_cate_dealstatus_statistic_detail t2
     on t1.guid = t2.statistic_guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t2.price_way = '2'
  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '2' and t1.supply_sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}'))
group by left(t2.create_time, 7)
order by left(t2.create_time, 7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



