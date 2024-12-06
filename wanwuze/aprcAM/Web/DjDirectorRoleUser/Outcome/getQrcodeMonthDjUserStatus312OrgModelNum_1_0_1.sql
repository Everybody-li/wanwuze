-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-二维码-查看详情(服务专员)-查看详情(供应机构)-查看详情(办理申请点击)-列表上方括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的二维码成果:某一月份的绑定该服务专员的需方办理申请点击数量列表,按服务专员分组统计,统计t1的数量,按t1主键去重
-- ##Describe 查询条件:t1表中品类状态是-312-办理申请点击,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic_detail cdsd,coz_server3_cate_dealstatus_statistic_detail_outcome dsdo
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input djUserGuid char[36] NOTNULL;服务专员用户id
-- ##input orgUserId char[36] NOTNULL;机构用户id
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input orgName string[30] NULL;机构名称或联系电话(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 1;办理申请点击数量

select count(1) as totalNum
from coz_server3_cate_dealstatus_statistic cds
         inner join coz_server3_cate_dealstatus_statistic_detail cdsd on cds.guid = cdsd.statistic_guid
         inner join coz_category_info t3 on cds.category_guid = t3.guid
         inner join coz_server3_cate_dealstatus_statistic_detail_outcome cdsdo
                    on cdsdo.statistic_detail_guid = cdsd.guid
         left join coz_aprom_pre_demand_request t5 on cds.biz_guid = t5.guid
         left join sys_app_user t6 on t5.user_id = t6.guid
where cds.del_flag = '0'
  and cdsd.del_flag = '0'
  and t3.del_flag = '0'
  and cds.dstatus = '312'
  and cdsdo.cat_tree_code = '{catTreeCode}'
  and cdsdo.sys_user_guid = '{targetUserId}'
  and cdsd.supply_user_id = '{orgUserId}'
  and (('{catTreeCode}' = 'demand' and cds.demand_sys_user_guid = '{djUserGuid}') or
       ('{catTreeCode}' = 'supply' and cdsd.sys_user_guid = '{djUserGuid}'))
  and left(cdsd.create_time, 7) = '{month}'
  and (cdsd.supply_user_name like '%{orgName}%' or cdsd.supply_user_phone like '%{orgName}%' or '{orgName}' = '')
