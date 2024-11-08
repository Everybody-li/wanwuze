-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-审批模式/交易模式-查看详情(渠道需求提交)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类采购交易状态下的渠道需求提交信息,且t1.业务guid=t2的guid
-- ##Describe 其他过滤条件: t1.需方对接专员
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_aprom_pre_demand_request t2
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime311 char[19] 2023-12-12 12:12:12;渠道需求提交日期
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output demandUserPhone string[50] (+86)18650767213;需方信息
-- ##output bizGuid char[36] 业务guid;业务guid

select
    left(t2.create_time, 19) as operationTime311
     , t2.category_name         as categoryName
     , t2.cattype_name          as cattypeName
     , ''                       as demandUserPhone
     , t1.biz_guid              as bizGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join     coz_aprom_pre_demand_request t2 on t1.biz_guid = t2.guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t1.dstatus = '311'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and t1.sd_path_guid = '{sdPathGuid}'
  and (t2.category_name like '%{categoryName}%' or '{categoryName}' = '')
 and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
order by t2.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



