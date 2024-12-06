-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-二维码-查看详情(服务专员)-列表上方办理申请点击括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的二维码成果某一月份的订单验收通过数量,统计t1的数量,按t1主键去重,
-- ##Describe 查询条件:t1表中品类状态是-312-办理申请点击,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic_detail t1,coz_server3_cate_dealstatus_statistic_detail_outcome t2
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input phonenumber string[30] NULL;姓名或联系电话(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 1;办理申请点击数量

select sum(totalNum) as totalNum
from (select count(1) as totalNum
      from coz_server3_cate_dealstatus_statistic cds
               inner join coz_server3_cate_dealstatus_statistic_detail cdsd on cds.guid = cdsd.statistic_guid
               inner join coz_server3_cate_dealstatus_statistic_detail_outcome cdsdo
                          on cdsd.guid = cdsdo.statistic_detail_guid
               inner join sys_user demandSysUser
                          on cds.demand_sys_user_guid = demandSysUser.user_id and '{catTreeCode}' = 'demand'
      where cds.dstatus = '312'
        and cds.del_flag = '0'
        and cdsd.del_flag = '0'
        and cdsdo.cat_tree_code = '{catTreeCode}'
        and cdsdo.sys_user_guid = '{targetUserId}'
        and left(cdsdo.create_time, 7) = '{month}'
        and (demandSysUser.nick_name like '%{phonenumber}%' or demandSysUser.phonenumber like '%{phonenumber}%' or
             '{phonenumber}' = '')
      group by demandSysUser.user_id
      union all
      select count(1) as totalNum
      from coz_server3_cate_dealstatus_statistic_detail cdsd
               inner join coz_server3_cate_dealstatus_statistic_detail_outcome cdsdo
                          on cdsd.guid = cdsdo.statistic_detail_guid
               inner join sys_user supplySysUser
                          on cdsd.sys_user_guid = supplySysUser.user_id and '{catTreeCode}' = 'supply'
      where cdsd.nstatus = '312'
        and cdsd.del_flag = '0'
        and cdsdo.del_flag = '0'
        and cdsdo.cat_tree_code = '{catTreeCode}'
        and cdsdo.sys_user_guid = '{targetUserId}'
        and left(cdsdo.create_time, 7) = '{month}'
        and (supplySysUser.nick_name like '%{phonenumber}%' or supplySysUser.phonenumber like '%{phonenumber}%' or
             '{phonenumber}' = '')
      group by supplySysUser.user_id) t
