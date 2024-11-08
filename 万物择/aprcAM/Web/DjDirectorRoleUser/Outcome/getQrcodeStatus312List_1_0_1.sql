-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-二维码-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的二维码成果列表,统计t1的数量,按t1主键去重,按统计时间倒序
-- ##Describe 查询条件:t1表中品类状态是-312-办理申请点击,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic cds,coz_server3_cate_dealstatus_statistic_detail t1,coz_server3_cate_dealstatus_statistic_detail_outcome t2
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output month char[19] 2023-12;统计时间,月份
-- ##output totalNum int[>=0] 1;办理申请点击数量


select left(cdsd.create_time, 7) as month
     , count(1)                  as totalNum
from coz_server3_cate_dealstatus_statistic_detail cdsd
         inner join coz_server3_cate_dealstatus_statistic_detail_outcome t2 on cdsd.guid = t2.statistic_detail_guid
where cdsd.del_flag = '0'
  and t2.del_flag = '0'
  and cdsd.nstatus = '312'
  and cdsd.sys_user_guid <> ''
  and t2.sys_user_guid = '{targetUserId}'
  and t2.cat_tree_code = '{catTreeCode}'
group by left(t2.create_time, 7)
order by left(t2.create_time, 7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



