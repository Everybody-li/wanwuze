-- ##Title web后台-运营经理操作管理-品类交易管理-商品交易跟踪管理-审批模式/交易模式/沟通模式-中间选项卡品类路径名称及数量信息
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询 品类类型模式为审批模式的供应路径数据
-- ##Describe coz_cattype_sd_path t1,coz_cattype_supply_path t2,coz_cattype_fixed_data t3,coz_category_info t4
-- ##CallType[QueryData]

-- ##input catMode enum[1,2,3] NOTNULL;品类模式:1-沟通模式,2-交易模式,3-审批模式
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output cattypeGuid char[36] ;品类类型guid
-- ##output sdPathGuid char[36] ;采购供应路径guid
-- ##output supplyPathGuid char[36] ;供应路径guid
-- ##output supplyPathName string[100] ;供应路径名称(格式：资金资源需求>管理>债权资金申请)
-- ##output catNum int[>=0] ;品类名称数量
-- ##output catMode enum[1,2,3] ;品类模式:1-沟通模式,2-交易模式,3-审批模式


select
    t1.cattype_guid       as cattypeGuid
  , ctfd.catMode
  , t1.guid               as sdPathGuid
  , t2.guid               as supplyPathGuid
  , t2.all_path_name      as supplyPathName
  , t1.norder             as norder
  , count(distinct t5.id) as catNum
from
    (
        select guid, mode as catMode from coz_cattype_fixed_data where mode = {catMode} and del_flag = '0'
    )           ctfd
    left join
              (
                  select sdpath.cattype_guid, sdpath.supply_path_guid, sdpath.guid, sdpath.norder
                  from
                      coz_cattype_sd_path sdpath
                  where sdpath.del_flag = '0'
              ) t1 on ctfd.guid = t1.cattype_guid
    left join (
                  select guid, all_path_name from coz_cattype_supply_path where del_flag = '0'
              ) t2 on t1.supply_path_guid = t2.guid
    left join (
                  select sd_path_guid, guid from coz_category_scene_tree where del_flag = '0'
              ) t3 on t3.sd_path_guid = t1.guid
    left join (
                  select category_guid, scene_tree_guid
                  from
                      coz_category_supplydemand
              ) t4 on t4.scene_tree_guid = t3.guid
    left join (
                  select guid, cattype_guid, id, name
                  from
                      coz_category_info
                  where mode = {catMode} and del_flag = '0'
              ) t5 on t5.guid = t4.category_guid
group by t1.norder, t1.cattype_guid, t1.guid, t2.guid, t2.all_path_name
order by t1.norder, t2.all_path_name, t1.cattype_guid, t1.guid, t2.guid
