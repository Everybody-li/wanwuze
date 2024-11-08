-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-审批模式-查看详情(办理申请点击)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类采购交易状态下的办理申请点击信息
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,coz_category_info t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input priceWay enum[1,2] NULL;报价方式:1-非二维码，2-二维码
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime311 char[19] 2023-12-12 12:12:12;渠道需求提交日期
-- ##output operationTime312 char[19] 2023-12-12 12:12:12;办理申请点击日期
-- ##output categoryName string[500] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orgName string[100] 供应机构(渠道)名称;供应机构(渠道)名称
-- ##output bizGuid string[36] 业务guid;业务guid
-- ##output modelGuid string[36] 品类供方型号guid;品类供方型号guid
-- ##output modelName string[50] 型号名称;型号名称


select left(t1.create_time, 19) as operationTime311
     , left(t2.create_time, 19) as operationTime312
     , t3.name                  as categoryName
     , t3.cattype_name          as cattypeName
     , t2.supply_user_name      as orgName
     , t1.biz_guid              as bizGuid 
     , t2.biz_guid              as modelGuid 
     , t2.biz_name              as modelName
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_cate_dealstatus_statistic_detail t2
     on t1.guid = t2.statistic_guid
         inner join
     coz_category_info t3
     on t1.category_guid = t3.guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t1.dstatus = '312'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t2.supply_user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and t1.sd_path_guid = '{sdPathGuid}'
  and t2.price_way = '{priceWay}'
  and (t3.name like '%{categoryName}%' or '{categoryName}' = '')
  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
order by t1.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



