-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-二维码-查看详情(服务专员)-查看详情(供应机构)-列表上方括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的二维码成果:某一月份的绑定该服务专员的需方办理申请点击数量列表,按服务专员和机构用户id分组统计,统计t1的数量,按t1主键去重
-- ##Describe 查询条件:t1表中品类状态是-312-办理申请点击,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic_detail t1,coz_server3_cate_dealstatus_statistic_detail_outcome t2,sys_user t3c,oz_cattype_sd_path t4,coz_lgcode_fixed_data t5,coz_org_info t6
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input djUserGuid char[36] NOTNULL;对接专员guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input orgName string[30] NULL;姓名或联系电话(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 1;办理申请点击数量

select ifnull(sum(totalNum), 0) as totalNum
from (select cdsd.supply_user_id    as orgUserId,
             t6.org_ID              as orgID,
             t6.create_time         as createTime,
             cdsd.supply_user_name  as orgName,
             cdsd.supply_user_phone as phonenumber,
             lfd.login_sysname      as supplySystem,
             count(1)               as totalNum
      from coz_server3_cate_dealstatus_statistic_detail cdsd
               inner join coz_server3_cate_dealstatus_statistic_detail_outcome cdsdo
                          on cdsd.guid = cdsdo.statistic_detail_guid
               inner join coz_server3_cate_dealstatus_statistic cds on cds.guid = cdsd.statistic_guid
               inner join coz_cattype_sd_path t4 on cds.sd_path_guid = t4.guid
               inner join coz_lgcode_fixed_data lfd on t4.lgcode_guid = lfd.guid
               inner join coz_org_info t6 on cdsd.supply_user_id = t6.user_id
      where cdsd.nstatus = '312'
#   and (t2.cat_tree_code = '{catTreeCode}')
#   and t1.sys_user_guid = '{djUserGuid}'
#   and t2.sys_user_guid = '{targetUserId}'
#   and left(t1.create_time, 7) = '{month}' and (t1.supply_user_name like '%{orgName}%' or t1.supply_user_phone like '%{orgName}%' or '{orgName}'='')
        and cdsdo.cat_tree_code = '{catTreeCode}'
        and cdsdo.sys_user_guid = '{targetUserId}'
        and (('{catTreeCode}' = 'demand' and cds.demand_sys_user_guid = '{djUserGuid}') or
             ('{catTreeCode}' = 'supply' and cdsd.sys_user_guid = '{djUserGuid}'))
        and left(cdsd.create_time, 7) = '{month}'
        and (cdsd.supply_user_name like '%{orgName}%' or cdsd.supply_user_phone like '%{orgName}%' or '{orgName}' = '')
      group by t6.org_ID, lfd.guid) t