-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-二维码-查看详情(服务专员)-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的二维码成果:某一月份的绑定该服务专员的需方办理申请点击数量列表,按服务专员分组统计,统计t1的数量,按t1主键去重
-- ##Describe 查询条件:t1表中品类状态是-312-办理申请点击,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic_detail t1,coz_server3_cate_dealstatus_statistic_detail_outcome t2,sys_user t3
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input phonenumber string[30] NULL;姓名或联系电话(模糊搜索)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output createTime string[16] 账号开通日期;账号开通日期
-- ##output userName string[50] 账号名称;账号名称
-- ##output nickName string[50] 姓名;姓名
-- ##output phonenumber string[50] 联系电话;联系电话
-- ##output totalNum int[>=0] 1;办理申请点击数量
-- ##output djUserGuid decimal[>=0] 10;对接专员guid

select *
from (select demandSysUser.create_time as createTime,
             demandSysUser.user_name   as userName,
             demandSysUser.nick_name   as nickName,
             demandSysUser.phonenumber as phonenumber,
             demandSysUser.user_id     as djUserGuid,
             count(1)                  as totalNum
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
      group by demandSysUser.user_id, demandSysUser.create_time
      union all
      select supplySysUser.create_time as createTime,
             supplySysUser.user_name   as userName,
             supplySysUser.nick_name   as nickName,
             supplySysUser.phonenumber as phonenumber,
             supplySysUser.user_id     as djUserGuid,
             count(1)                  as totalNum
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
      group by supplySysUser.user_id, supplySysUser.create_time) t
order by createTime desc
  Limit {compute:[({page}-1)*{size}]/compute},{size};