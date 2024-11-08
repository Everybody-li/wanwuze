-- ##Title web-品类供应机构管理-有供应机构数量_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-品类供应机构管理-有供应机构数量_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output noOrgNum int[>=0] ;无供应渠道数量
-- ##output orgNum int[>=0] ;有供应渠道数量


with t as (select distinct t1.guid
           from coz_category_info t1
                    inner join coz_category_supplydemand t3 on t1.guid = t3.category_guid
                    inner join coz_category_scene_tree t4 on t3.scene_tree_guid = t4.guid
           where t1.del_flag = '0' and t3.del_flag = '0' and t4.del_flag = '0'
            {dynamic:cattypeGuid[ and t1.cattype_guid = '{cattypeGuid}' ]/dynamic}
            {dynamic:sdPathGuid[ and t4.sd_path_guid = '{sdPathGuid}' ]/dynamic}
    )
select count(t.guid) - t2.orgNum as noOrgNum, t2.orgNum
from t,
     (select count(distinct t.guid) as orgNum
      from t left join coz_category_supplier cs
                         on t.guid = cs.category_guid
      where  cs.del_flag = '0') t2
;





