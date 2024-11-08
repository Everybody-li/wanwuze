-- ##Title web-运营经理操作系统-品类供应管理-品类供应渠道管理-有供应渠道-列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output categoryGuid char[36] 品类名称guid;品类名称guid
-- ##output categoryName string[20] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output supplyOrgNum int[>=0] 供应机构数量;供应机构数量
-- ##output saleOnModelNum int[>=0] 1;品类的型号上架数量
-- ##output saleOffModelNum int[>=0] 1;型号未上架数量

select 
categoryGuid
,categoryName
,cattypeName
,supplyOrgNum
,saleOnModelNum
,modelNum-saleOnModelNum as saleOffModelNum
from (select t1.guid                           as categoryGuid
           , t1.name                           as categoryName
           , t1.cattype_name                   as cattypeName
           , t1.id
           , (select count(1)
              from (select a.category_guid
                    from coz_category_supplier a
                    where a.del_flag = '0'
                      and exists(select 1 from coz_org_info where del_flag = '0' and user_id = a.user_id)
                    group by a.category_guid, a.user_id) a
              where a.category_guid = t1.guid) as supplyOrgNum
          ,(select count(1) from coz_category_supplier_am_model a
                inner join coz_category_supplier b on a.supplier_guid=b.guid
                    where b.category_guid = t1.guid and a.del_flag='0' and b.del_flag='0') as modelNum
          ,(select count(1) from coz_category_supplier_am_model a
                inner join coz_category_supplier b on a.supplier_guid=b.guid
                    where b.category_guid = t1.guid and a.del_flag='0' and b.del_flag='0'
                         and exists(select 1 from coz_category_supplier_am_model_plate where del_flag='0' and model_guid=a.guid and status='1')
                         and exists(select 1 from coz_category_supplier_am_model_price_plate where del_flag='0' and model_guid=a.guid and status='1')
                         and exists(select 1 from coz_category_am_modelprice_log where del_flag='0' and biz_guid=a.guid)) as saleOnModelNum
      from
           ( select guid, `name`, cattype_name, id
            from
                coz_category_info t1
                inner join
                    (
                        select distinct cci.guid as categoryGuid
                        from
                            coz_category_info             cci
                            inner join
                                coz_category_supplydemand t2 on cci.guid = t2.category_guid
                            inner join
                                coz_category_scene_tree   t3 on t2.scene_tree_guid = t3.guid
                        where
                              cci.del_flag = '0'
                          and t2.del_flag = '0'
                          and t3.del_flag = '0' {dynamic:categoryName[ and cci.`name` like '%{categoryName}%' ]/dynamic}
                 {dynamic:cattypeGuid[ and  cci.cattype_guid = '{cattypeGuid}' ]/dynamic}  -- 非必填入参,不列出来,两处共用,前端传参不一致
                 {dynamic:sdPathGuid[and t3.sd_path_guid = '{sdPathGuid}']/dynamic}  -- 非必填入参,不列出来,两处共用,前端传参不一致
                  )             catGuid on t1.guid = catGuid.categoryGuid
           )t1
      )t
where supplyOrgNum > 0
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


