-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-查询已发布的是字段内容不是上传文件或需方填写的字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 按字段名称guid去重
-- ##Describe 表名：coz_model_am_aprom_plate_field_content_formal t4
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output contentSource enum[1,2] 1;字段内容来源：1-字段内容固化库，2-字段内容自建库
-- ##output operation enum[1,2] 1;供/需方操作设置: 1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output plateFieldContentCode string[6] c00016;字段内容固化库code
-- ##output fields.plateFieldContent string[50] 字段内容名称;字段内容名称
-- ##output fields.relateFieldGuid char[36] 关联的字段名称guid;关联的字段名称guid，coz_model_am_field主键：一个字段内容只能关联一个字段名称，一个字段名称从只能被一个字段内容关联(1对1的关系)

select *
from (select t1.guid           as plateFieldGuid
           , t2.operation
           , t2.content_source as contentSource
           , t3.code           as plateFieldContentCode
           , t2.cat_tree_code  as catTreeCode
           , CONCAT(
            '{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Mode\\getDemandPlFieldContFormalList_1_0_1:plateFieldGuid=''',
            t1.guid, '''}')    as `fields`
      from coz_model_am_aprom_plate_field_formal t1
               left join coz_model_am_aprom_plate_field_settings_formal t2 on t1.guid = t2.plate_field_guid
               left join coz_model_fixed_data t3 on t1.content_fixed_data_guid = t3.guid
      where t1.category_guid = '{categoryGuid}'
        and t2.cat_tree_code = 'demand'
        and t1.del_flag = '0') t
group by t.plateFieldGuid, t.operation, t.contentSource, t.plateFieldContentCode, t.`fields`
;








