-- ##Title 插件端-web后台-审批模式-供需需求信息管理-发布逻辑-查询渠道需求字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-02-05
-- ##Describe 查询： 
-- ##Describe 表名：coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output preRequestGuid char[36] 渠道需求guid;渠道需求guid
-- ##output fields.plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output fields.operation string[1] 1;供/需方操作（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传）
-- ##output fields.plateFieldValue string[200] 用户填写的值;用户填写的值，存具体内容，例如输入的字符内容

select t.request_guid                                                                 as preRequestGuid
     , t.plate_field_formal_guid                                                      as plateFieldGuid
     , CONCAT(
        '{ChildRows_aprcAM\\PluginServe\\ApromMode\\Cattype\\Mode\\getPreDeReqFieldContList_1_0_1:plateFieldGuid=''',
        t.plate_field_formal_guid, ''' and preRequestGuid=''', t.request_guid, '''}') as `fields`
from coz_aprom_pre_demand_request pdr
         inner join coz_aprom_pre_demand_request_plate t on pdr.guid = t.request_guid
where pdr.category_guid = '{categoryGuid}'
  and pdr.del_flag = '0'
  and pdr.status = '1'
group by t.request_guid, t.plate_field_formal_guid
