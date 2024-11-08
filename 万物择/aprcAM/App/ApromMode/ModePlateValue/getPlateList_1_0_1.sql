-- ##Title  app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-渠道供应-办理申请提交-获取板块列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-13
-- ##Describe 查询：复合接口，嵌套结构，仅需返回2层
-- ##Describe 表名：coz_model_am_modelprice_de_plate_formal
-- ##Describe 排序：板块的顺序升序
-- ##CallType[QueryData]

-- ##input modelGuid char[36] NOTNULL;品类型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateGuid char[36] 板块名称guid;板块名称guid
-- ##output plateAlias string[20] 板块名称别名;板块名称别名
-- ##output plateNorder int[>0] 板块名称排序;板块名称排序
-- ##output fields.plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output fields.plateFieldAlias string[20] 字段名称别名;字段名称别名
-- ##output fields.plateFieldNorder int[>0] 1;字段名称排序
-- ##output fields.plateFieldCode string[20] 字段名称code;字段名称code
-- ##output fields.plateFieldOperation enum[1,2,3,4,5] 1;字段名称操作设置：1-单选框(需要额外请求接口获取字段内容数据)，2-复选框(需要额外请求接口获取字段内容数据)，3-填写文本框，4-图片上传，5-文档上传
-- ##output fields.plateFieldPlaceholder string[200] 3;字段名称操作设置的值是3，4，5，则需要展示
-- ##output fields.plateFieldFileTemplate string[42] 文件/图片模板;文件/图片模板，字段名称操作设置是4，则为图片。字段名称操作设置是5，则为文档
-- ##output fields.plateFieldContentCode string[6] 字段内容固化code; 字段内容固化code，前端根据不同值做不同操作：c00008-行政区域国家/地区。c00009-行政区域省级。c00010-行政区域市级。c00011-行政区域区县级，c00012-行政区域镇级。c00007-日期-年月日。c00017-日期-年月日时分.c00018-日期-年月日时。c00016-产品名称库：从接口[aprc\app\base\catInfo\getCatInfoList_1_0_1]获取字段内容值

select
t.guid as plateGuid
,t.alias as plateAlias
,t.norder as plateNorder
,CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getPlateFieldList_1_0_1:plateGuid=''',t.guid,'''}') as `fields`
from
coz_model_am_modelprice_de_plate_formal t
where 
t.biz_guid='{modelGuid}' and t.del_flag='0'
order by t.norder