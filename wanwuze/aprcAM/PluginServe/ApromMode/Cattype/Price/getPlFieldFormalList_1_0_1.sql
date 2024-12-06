-- ##Title 插件端-web后台-审批模式-通用配置-供应报价信息管理-发布逻辑-查询已发布的是字段内容自建库的字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 按字段名称guid去重
-- ##Describe 表名：coz_model_am_suprice_plate_field_content_formal t4
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid char[36] 字段名称guid;
-- ##output contentSource enum[1,2] 1;字段内容来源：1-字段内容固化库，2-字段内容自建库
-- ##output operation enum[1,2] 1;供/需方操作设置: 1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output plateFieldContentCode string[6] c00016;字段内容固化库code
-- ##output fields.plateFieldContent string[50] 字段内容名称;

select t1.guid           as plateFieldGuid
     , t1.content_source as contentSource
     , t1.operation      as operation
     , t2.code           as plateFieldContentCode
     , CONCAT(
        '{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Price\\getPlFieldContFormalList_1_0_1:plateFieldGuid=''',
        t1.guid, '''}')  as `fields`
from coz_model_am_suprice_plate_field_formal t1
         left join coz_model_fixed_data t2 on t1.content_fixed_data_guid = t2.guid
where t1.biz_guid = '{categoryGuid}'
  and t1.del_flag = '0'