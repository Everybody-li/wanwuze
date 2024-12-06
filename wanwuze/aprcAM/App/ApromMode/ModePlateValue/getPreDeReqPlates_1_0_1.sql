-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-查询提交的渠道需求内容详情-板块列表
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 表名：coz_aprom_pre_demand_request,coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]

-- ##input preRequestGuid char[36] NOTNULL;渠道需求guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plates.plateGuid char[36] 板块名称guid;
-- ##output plates.plateCode string[6] 板块名称code;板块名称code
-- ##output plates.plateAlias string[20] 板块名称别名;
-- ##output plates.plateNorder int[>0] 板块名称排序;
-- ##output plates.fields.plateFieldGuid char[36] 字段名称guid;
-- ##output plates.fields.plateFieldAlias string[50] 字段名称别名;
-- ##output plates.fields.plateFieldNorder int[>0] 字段名称排序;
-- ##output plates.fields.relateFlag enum[0,1] 字段名称是否被关联：0-否，1-是。前端：仅显示未被关联的字段名称列表，已被关联的字段名称根据字段内容选中触发动态展示;
-- ##output plates.fields.plateFieldPlaceholder string[500] 字段操作提示语,字段名称操作设置的值是3，4，5，则需要展示;
-- ##output plates.fields.plateFieldFileTemplate string[200] 文件/图片模板，字段名称操作设置是4，则为图片。字段名称操作设置是5，则为文档;
-- ##output plates.fields.plateFieldOperation enum[1,2,3,4,5] 字段名称操作设置：1-单选框(需要额外请求接口获取字段内容数据)，2-复选框(需要额外请求接口获取字段内容数据)，3-填写文本框，4-图片上传，5-文档上传;
-- ##output plates.fields.values.key string[36] 供方填写的字段内容值guid;
-- ##output plates.fields.values.value string[200] 供方填写的字段内容值;
-- ##output plates.fields.values.plateFieldRelateFieldGuid string[36] 字段内容关联的字段名称guid;

select t.request_guid                     as preRequestGuid
     , t.plate_formal_guid                as plateGuid
     , t.plate_code                       as plateCode
     , t.plate_formal_alias               as plateAlias
     , t.plate_norder                     as plateNorder
     ,CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getPreDeReqPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `fields`

from coz_aprom_pre_demand_request_plate t
where t.request_guid = '{preRequestGuid}'
  and t.del_flag = '0'
  and t.status = '1'
group by t.plate_formal_guid, t.plate_formal_alias, t.plate_norder